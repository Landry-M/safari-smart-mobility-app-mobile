# Flux d'Authentification - Safari Smart Mobility

## Vue d'ensemble
L'application utilise Firebase Phone Authentication avec vérification de l'existence du compte dans Firestore avant l'envoi de l'OTP.

## Flux de Connexion (Login)

### 1. Saisie du numéro de téléphone
- L'utilisateur entre son numéro de téléphone sur l'écran de login
- Aucun mot de passe n'est requis

### 2. Vérification de l'existence du compte
**Fichier**: `lib/screens/auth/login_screen.dart` - méthode `_handleLogin()`

```
Numéro saisi → Formatage (+243XXXXXXXXX) → Recherche dans Firestore
```

- Le numéro est formaté via `FirebaseAuthService.formatPhoneNumber()`
- Recherche dans Firestore via `AuthProvider.checkPhoneExists()`
- La recherche utilise `FirestoreService.getUserByPhone()` qui fait une query sur le champ `phone`

### 3a. Si le compte N'EXISTE PAS
**Action**: Afficher une popup d'erreur

- **Titre**: "Compte introuvable"
- **Message**: "Ce numéro de téléphone n'est associé à aucun compte. Veuillez créer un compte pour continuer."
- **Boutons**: 
  - "Annuler" : Ferme la popup
  - "Créer un compte" : Redirige vers `/register`

### 3b. Si le compte EXISTE
**Action**: Continuer le processus d'authentification

1. **Envoi de l'OTP Firebase**
   - Appel à `AuthProvider.sendFirebaseOTP()`
   - Utilise un `Completer` pour attendre les callbacks Firebase
   - Timeout de 10 secondes

2. **Réception du verificationId**
   - Si succès : Navigation vers `/otp-verification` avec :
     - `phone`: Numéro de téléphone
     - `verificationId`: ID de vérification Firebase
     - `isLogin: true`: Indique qu'il s'agit d'une connexion
   - Si erreur : Afficher un SnackBar avec le message d'erreur

### 4. Vérification du code OTP
**Fichier**: `lib/screens/auth/otp_verification_screen.dart`

- L'utilisateur saisit le code à 6 chiffres
- Appel à `AuthProvider.verifyFirebaseOTP()` avec `userData: null`

### 5. Récupération des données depuis Firestore
**Fichier**: `lib/providers/auth_provider.dart` - méthode `verifyFirebaseOTP()`

Puisque `userData == null` (connexion), le système :

1. **Authentifie avec Firebase**
   ```
   signInWithCredential(credential) → UserCredential
   ```

2. **Récupère le UID Firebase**
   ```
   final uid = userCredential.user.uid
   ```

3. **Charge les données depuis Firestore**
   ```
   FirestoreService.getUser(uid) → Map<String, dynamic>
   ```
   
   Données récupérées :
   - `name` : Nom de l'utilisateur
   - `phone` : Numéro de téléphone (formaté)
   - `email` : Email
   - `role` : Rôle (passenger, driver, controller, receiver)
   - `balance` : Solde du compte
   - `badges` : Liste des badges obtenus

4. **Sauvegarde locale dans Isar**
   ```
   DatabaseService.saveUser(user) → Persistance locale
   ```

5. **Navigation vers la page d'accueil**
   ```
   context.go('/home')
   ```

---

## Flux d'Inscription (Register)

### 1. Saisie des informations
**Fichier**: `lib/screens/auth/gamified_register_screen.dart`

L'utilisateur remplit le formulaire en 5 étapes :
- Nom complet
- Numéro de téléphone
- Email (optionnel)
- Objectif de voyage
- Préférences

### 2. Envoi de l'OTP
- Appel à `AuthProvider.sendFirebaseOTP()`
- Navigation vers `/otp-verification` avec :
  - `phone`: Numéro saisi
  - `verificationId`: ID de vérification
  - `userData`: Objet contenant toutes les infos saisies
  - `isLogin: false`: Indique qu'il s'agit d'une inscription

### 3. Vérification OTP et Création du compte
**Fichier**: `lib/providers/auth_provider.dart` - méthode `verifyFirebaseOTP()`

Puisque `userData != null` (inscription), le système :

1. **Authentifie avec Firebase**
   ```
   signInWithCredential(credential) → UserCredential
   ```

2. **Récupère le UID et le numéro formaté**
   ```
   final uid = userCredential.user.uid
   final firebasePhone = userCredential.user.phoneNumber
   ```

3. **Crée l'utilisateur dans Firestore**
   ```
   FirestoreService.createUser(
     uid: uid,
     name: userName,
     phone: firebasePhone,  // ⚠️ IMPORTANT : Utilise le numéro formaté Firebase
     email: userEmail,
     role: UserRole.passenger,
   )
   ```

4. **Sauvegarde locale dans Isar**
   ```
   DatabaseService.saveUser(user)
   ```

5. **Attribution du badge "First Step"**
   ```
   AuthProvider.addBadge(AppStrings.firstStepBadge)
   ```

6. **Navigation vers la page d'accueil**
   ```
   context.go('/home')
   ```

---

## Points Critiques

### Format du Numéro de Téléphone
**TRÈS IMPORTANT** : Le numéro de téléphone doit toujours être formaté de la même manière :

1. **Lors de l'inscription** : Utiliser `firebaseUser.phoneNumber` (déjà formaté par Firebase)
2. **Lors de la connexion** : Formater avec `FirebaseAuthService.formatPhoneNumber()` avant la recherche
3. **Format RDC Congo** : `+243XXXXXXXXX` (sans espaces ni tirets)

### Cohérence des Données

```
┌──────────────────────────────────────────────────────┐
│              SOURCES DE VÉRITÉ                        │
├──────────────────────────────────────────────────────┤
│                                                       │
│  Firebase Auth                                        │
│  └─ UID (unique par numéro de téléphone)            │
│  └─ phoneNumber (formaté +243XXXXXXXXX)              │
│                                                       │
│  Firestore                                           │
│  └─ Collection: users                                │
│     └─ Document ID: {UID Firebase}                   │
│        └─ phone: {phoneNumber formaté}               │
│        └─ name, email, role, balance, badges...      │
│                                                       │
│  Isar (Local)                                        │
│  └─ Copie des données Firestore                     │
│  └─ Utilisé pour la persistance offline             │
│                                                       │
└──────────────────────────────────────────────────────┘
```

### Gestion des Erreurs

| Erreur | Action |
|--------|--------|
| Numéro n'existe pas (login) | Popup → Redirection vers inscription |
| Code OTP invalide | Message d'erreur + possibilité de renvoyer |
| Utilisateur non trouvé dans Firestore | Message d'erreur + déconnexion |
| Timeout OTP (10s) | Message d'erreur + possibilité de réessayer |
| Problème réseau | Message d'erreur réseau |

---

## Fichiers Modifiés

### Services
- `lib/core/services/firestore_service.dart`
  - ✅ Ajout de `getUserByPhone()` pour rechercher un utilisateur par téléphone
  
- `lib/core/services/firebase_auth_service.dart`
  - Existant : `formatPhoneNumber()`, `sendOTP()`, `verifyOTP()`

### Providers
- `lib/providers/auth_provider.dart`
  - ✅ Ajout de `checkPhoneExists()` pour vérifier l'existence d'un numéro
  - ✅ Modification de `verifyFirebaseOTP()` pour utiliser le numéro formaté Firebase lors de l'inscription

### Screens
- `lib/screens/auth/login_screen.dart`
  - ✅ Ajout de la vérification Firestore avant l'envoi de l'OTP
  - ✅ Ajout de `_showAccountNotFoundDialog()` pour la popup d'erreur
  - ✅ Suppression du champ mot de passe
  
- `lib/screens/auth/otp_verification_screen.dart`
  - ✅ Ajout du paramètre `isLogin` pour gérer le bouton retour

### Navigation
- `lib/main.dart`
  - ✅ Ajout du paramètre `isLogin` dans la route `/otp-verification`

---

## Tests Recommandés

### Scénario 1 : Première Inscription
1. Aller sur l'écran d'inscription
2. Remplir le formulaire avec un nouveau numéro
3. Recevoir et valider l'OTP
4. Vérifier que l'utilisateur est créé dans Firestore avec le numéro formaté
5. Vérifier la navigation vers `/home`

### Scénario 2 : Connexion avec Compte Existant
1. Aller sur l'écran de connexion
2. Entrer un numéro existant dans Firestore
3. Vérifier que l'OTP est envoyé
4. Valider l'OTP
5. Vérifier que les données sont chargées depuis Firestore et sauvegardées localement
6. Vérifier la navigation vers `/home`

### Scénario 3 : Connexion avec Compte Inexistant
1. Aller sur l'écran de connexion
2. Entrer un numéro non enregistré
3. Vérifier l'affichage de la popup "Compte introuvable"
4. Cliquer sur "Créer un compte"
5. Vérifier la redirection vers `/register`

### Scénario 4 : Format de Numéro Cohérent
1. S'inscrire avec le numéro `0123456789`
2. Vérifier dans Firestore que le numéro est stocké comme `+243123456789`
3. Se déconnecter
4. Se reconnecter avec `0123456789`
5. Vérifier que le compte est trouvé et la connexion réussie

---

## Notes de Développement

- ⚠️ Assurez-vous que l'authentification par téléphone est activée dans la console Firebase
- ⚠️ Configurez les quotas SMS dans Firebase pour éviter les dépassements
- ⚠️ Pour les tests, utilisez les numéros de test Firebase pour éviter d'envoyer de vrais SMS
- ⚠️ Le code pays par défaut est +243 (RDC Congo), modifiable dans `FirebaseAuthService.formatPhoneNumber()`
