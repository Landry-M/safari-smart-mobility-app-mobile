# Configuration des Règles Firestore

## 🔴 Problème Résolu
```
Status{code=PERMISSION_DENIED, description=Missing or insufficient permissions.}
[cloud_firestore/permission-denied] The caller does not have permission to execute the specified operation.
```

## ✅ Solution : 2 Méthodes

### Méthode 1 : Via Firebase CLI (RECOMMANDÉ) 🚀

#### Étape 1 : Installer Firebase CLI (si pas déjà installé)
```bash
npm install -g firebase-tools
```

#### Étape 2 : Se connecter à Firebase
```bash
firebase login
```
Une page web s'ouvrira pour vous connecter avec votre compte Google.

#### Étape 3 : Initialiser Firebase dans le projet (si pas déjà fait)
```bash
cd /Users/apple/Documents/dev/flutter/safari_smart_mobility
firebase init firestore
```

Répondre aux questions :
- **"What file should be used for Firestore Rules?"** → Appuyez sur Entrée (utilise `firestore.rules` par défaut)
- **"File firestore.rules already exists. Do you want to overwrite?"** → `N` (Non, garder notre fichier)

#### Étape 4 : Déployer les Règles
```bash
firebase deploy --only firestore:rules
```

✅ Vous devriez voir :
```
✔  Deploy complete!
```

---

### Méthode 2 : Via Console Firebase (Plus Simple) 🌐

#### Étape 1 : Ouvrir la Console Firebase
1. Aller sur [console.firebase.google.com](https://console.firebase.google.com)
2. Sélectionner le projet **safari-82202**

#### Étape 2 : Naviguer vers Firestore
1. Dans le menu latéral, cliquer sur **Firestore Database**
2. Cliquer sur l'onglet **Règles** (ou **Rules**)

#### Étape 3 : Copier-Coller les Règles
Copier le contenu ci-dessous et le coller dans l'éditeur :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Collection des utilisateurs
    match /users/{userId} {
      // Lecture publique limitée pour vérifier l'existence d'un numéro de téléphone
      // OU lecture complète si l'utilisateur est authentifié
      allow read: if request.auth != null ||
                     (request.query != null && 
                      request.query.limit == 1);
      
      // Création : Utilisateur authentifié créant son propre document
      allow create: if request.auth != null && 
                       request.auth.uid == userId;
      
      // Mise à jour : Propriétaire uniquement
      allow update: if request.auth != null && 
                       request.auth.uid == userId;
      
      // Suppression : Propriétaire uniquement
      allow delete: if request.auth != null && 
                       request.auth.uid == userId;
    }
    
    // Collection des tickets
    match /tickets/{ticketId} {
      // Lecture : Utilisateurs authentifiés
      allow read: if request.auth != null;
      
      // Création : Utilisateurs authentifiés
      allow create: if request.auth != null;
      
      // Mise à jour/Suppression : Propriétaire du ticket uniquement
      allow update, delete: if request.auth != null && 
                               resource.data.userId == request.auth.uid;
    }
    
    // Collection des trajets
    match /trips/{tripId} {
      // Lecture : Utilisateurs authentifiés
      allow read: if request.auth != null;
      
      // Écriture : Utilisateurs authentifiés (chauffeurs, contrôleurs)
      allow write: if request.auth != null;
    }
  }
}
```

#### Étape 4 : Publier
1. Cliquer sur le bouton **Publier** (ou **Publish**)
2. Confirmer la publication

✅ Les règles sont maintenant actives !

---

## 🔍 Explication des Règles

### Collection `users`

#### Lecture (Read)
```javascript
allow read: if request.auth != null ||
               (request.query != null && 
                request.query.limit == 1);
```
**Signification** :
- ✅ **Si authentifié** : Peut lire tous les documents
- ✅ **Si non authentifié** : Peut faire UNE requête limitée à 1 résultat (pour vérifier l'existence d'un numéro)
- ❌ **Si non authentifié** : Ne peut PAS lister tous les utilisateurs

**Cas d'usage** :
- Lors de la **connexion**, l'app vérifie si le numéro existe (sans authentification)
- Après **authentification**, l'app peut lire les profils utilisateurs

#### Création (Create)
```javascript
allow create: if request.auth != null && 
                 request.auth.uid == userId;
```
**Signification** :
- ✅ Un utilisateur authentifié peut créer SON propre document
- ❌ Ne peut pas créer de document pour quelqu'un d'autre

#### Mise à jour (Update)
```javascript
allow update: if request.auth != null && 
                 request.auth.uid == userId;
```
**Signification** :
- ✅ Un utilisateur peut modifier uniquement SON propre profil
- ❌ Ne peut pas modifier le profil d'un autre utilisateur

#### Suppression (Delete)
```javascript
allow delete: if request.auth != null && 
                 request.auth.uid == userId;
```
**Signification** :
- ✅ Un utilisateur peut supprimer uniquement SON propre compte

### Collection `tickets`

```javascript
allow read: if request.auth != null;
allow create: if request.auth != null;
allow update, delete: if request.auth != null && 
                         resource.data.userId == request.auth.uid;
```
**Signification** :
- ✅ Tous les utilisateurs authentifiés peuvent voir et créer des tickets
- ✅ Seul le propriétaire peut modifier/supprimer son ticket

### Collection `trips`

```javascript
allow read: if request.auth != null;
allow write: if request.auth != null;
```
**Signification** :
- ✅ Tous les utilisateurs authentifiés peuvent lire et écrire les trajets

---

## 🧪 Vérifier que les Règles Fonctionnent

### Test 1 : Lancer l'Application
```bash
cd /Users/apple/Documents/dev/flutter/safari_smart_mobility
flutter run
```

### Test 2 : Tester la Connexion
1. Ouvrir l'écran de connexion
2. Entrer un numéro : `+243845517445`
3. Cliquer sur "Recevoir le code"

### Test 3 : Vérifier les Logs
✅ **Succès** - Vous devriez voir :
```
🟢 [FirestoreService] getUserByPhone - Recherche pour: +243845517445
🟢 [FirestoreService] getUserByPhone - Nombre de documents trouvés (format exact): 1
🟢 [FirestoreService] getUserByPhone - Utilisateur trouvé: John Doe (+243845517445)
```

❌ **Échec** - Si vous voyez encore :
```
🔴 [FirestoreService] getUserByPhone - Erreur: [cloud_firestore/permission-denied]
```
→ Les règles n'ont pas été déployées correctement. Réessayer la méthode 2 (Console Firebase).

---

## 🔒 Sécurité des Règles

### Ce qui est AUTORISÉ ✅
1. **Vérifier si un numéro existe** (sans authentification) → Nécessaire pour le login
2. **Créer son propre compte** (après authentification Firebase)
3. **Lire/modifier son propre profil** (authentifié)
4. **Lire les tickets et trajets** (authentifié)

### Ce qui est BLOQUÉ ❌
1. **Lister tous les utilisateurs** (sans authentification)
2. **Modifier le profil d'un autre utilisateur**
3. **Supprimer le compte d'un autre utilisateur**
4. **Accéder aux données sans être authentifié** (sauf vérification du numéro)

---

## 🚨 Règles de Développement (Temporaire)

Si vous voulez des règles **très permissives** pour le développement (⚠️ NE PAS UTILISER EN PRODUCTION) :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

⚠️ **ATTENTION** : Ces règles permettent à TOUT LE MONDE de lire et écrire dans votre base de données !

---

## 📝 Commandes Utiles

### Voir les règles actuelles
```bash
firebase firestore:rules:list
```

### Tester les règles localement
```bash
firebase emulators:start --only firestore
```

### Déployer uniquement les règles
```bash
firebase deploy --only firestore:rules
```

### Déployer tout Firebase
```bash
firebase deploy
```

---

## ✅ Checklist

- [ ] Firebase CLI installé
- [ ] Connecté avec `firebase login`
- [ ] Fichier `firestore.rules` créé
- [ ] Fichier `firebase.json` mis à jour
- [ ] Règles déployées avec `firebase deploy --only firestore:rules`
- [ ] Application testée : connexion fonctionne
- [ ] Logs ne montrent plus d'erreur PERMISSION_DENIED

---

## 🆘 Aide Supplémentaire

Si le problème persiste :

1. **Vérifier le projet Firebase** :
   ```bash
   firebase projects:list
   ```
   Assurez-vous que `safari-82202` est dans la liste.

2. **Vérifier la connexion** :
   ```bash
   firebase use safari-82202
   ```

3. **Vérifier les règles actuelles** dans la console Firebase :
   - Aller sur [console.firebase.google.com](https://console.firebase.google.com)
   - Projet : safari-82202
   - Firestore Database → Règles
   - Vérifier que les règles correspondent

4. **Forcer le redéploiement** :
   ```bash
   firebase deploy --only firestore:rules --force
   ```

---

**Dernière mise à jour** : Configuration des règles Firestore pour Safari Smart Mobility
**Projet** : safari-82202
**Status** : Règles créées ✅ | À déployer ⏳
