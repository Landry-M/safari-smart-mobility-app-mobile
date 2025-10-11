# Guide de Débogage - Recherche de Numéro de Téléphone

## Problème
Les numéros `+243845517445` et `+243977948183` existent dans Firestore mais ne sont pas trouvés lors de la connexion.

## Logs de Débogage Ajoutés

### 1. Écran de Login
```
🔍 [LOGIN] Numéro saisi: [le numéro entré par l'utilisateur]
🔍 [LOGIN] Résultat recherche: TROUVÉ / NON TROUVÉ
🔍 [LOGIN] Données utilisateur: [nom], [téléphone]
```

### 2. AuthProvider
```
🔵 [AuthProvider] checkPhoneExists - Numéro reçu: [numéro original]
🔵 [AuthProvider] checkPhoneExists - Numéro formaté: [après formatage]
🔵 [AuthProvider] checkPhoneExists - Résultat: Utilisateur trouvé / Aucun utilisateur
```

### 3. FirestoreService (Recherche Multiple)
```
🟢 [FirestoreService] getUserByPhone - Recherche pour: [numéro]
🟢 [FirestoreService] getUserByPhone - Nombre de documents trouvés (format exact): X
🟡 [FirestoreService] getUserByPhone - Tentative sans espaces: [numéro]
🟡 [FirestoreService] getUserByPhone - Tentative sans +: [numéro]
🟡 [FirestoreService] getUserByPhone - Tentative avec +: [numéro]
🟢 [FirestoreService] getUserByPhone - Utilisateur trouvé: [nom] ([téléphone])
```

## Stratégie de Recherche Multi-Format

Le système essaie maintenant **4 formats différents** pour trouver le numéro :

### Format 1 : Tel quel
```
Recherche : +243845517445
```

### Format 2 : Sans espaces
```
Si l'utilisateur entre : +243 845 517 445
Recherche aussi : +243845517445
```

### Format 3 : Sans le signe +
```
Si le numéro commence par +
Recherche : +243845517445
Recherche aussi : 243845517445
```

### Format 4 : Avec le signe +
```
Si le numéro ne commence pas par +
Recherche : 243845517445
Recherche aussi : +243845517445
```

## Comment Déboguer

### Étape 1 : Vérifier dans Firestore
1. Ouvrir la console Firebase
2. Aller dans Firestore Database
3. Ouvrir la collection `users`
4. Trouver les documents pour les numéros problématiques
5. **Noter le format exact du champ `phone`**

Exemples possibles :
- ✅ `+243845517445`
- ✅ `243845517445`
- ✅ `+243 845 517 445`
- ✅ `0845517445`

### Étape 2 : Tester la Connexion
1. Lancer l'application en mode debug
2. Aller sur l'écran de connexion
3. Entrer le numéro : `+243845517445`
4. Cliquer sur "Recevoir le code"
5. **Regarder les logs dans la console**

### Étape 3 : Analyser les Logs

#### Scénario 1 : Le numéro est trouvé ✅
```
🔍 [LOGIN] Numéro saisi: +243845517445
🔵 [AuthProvider] checkPhoneExists - Numéro reçu: +243845517445
🔵 [AuthProvider] checkPhoneExists - Numéro formaté: +243845517445
🟢 [FirestoreService] getUserByPhone - Recherche pour: +243845517445
🟢 [FirestoreService] getUserByPhone - Nombre de documents trouvés (format exact): 1
🟢 [FirestoreService] getUserByPhone - Utilisateur trouvé: John Doe (+243845517445)
🔵 [AuthProvider] checkPhoneExists - Résultat: Utilisateur trouvé
🔍 [LOGIN] Résultat recherche: TROUVÉ
```
→ **Tout fonctionne ! L'OTP sera envoyé.**

#### Scénario 2 : Format différent, trouvé au 2ème essai ⚠️
```
🔍 [LOGIN] Numéro saisi: +243845517445
🔵 [AuthProvider] checkPhoneExists - Numéro reçu: +243845517445
🔵 [AuthProvider] checkPhoneExists - Numéro formaté: +243845517445
🟢 [FirestoreService] getUserByPhone - Recherche pour: +243845517445
🟢 [FirestoreService] getUserByPhone - Nombre de documents trouvés (format exact): 0
🟡 [FirestoreService] getUserByPhone - Tentative sans +: 243845517445
🟢 [FirestoreService] getUserByPhone - Utilisateur trouvé (sans +): John Doe (243845517445)
```
→ **Le numéro est stocké SANS le +**
→ **Solution** : Mettre à jour Firestore pour utiliser le format `+243XXXXXXXXX`

#### Scénario 3 : Aucun format ne correspond ❌
```
🔍 [LOGIN] Numéro saisi: +243845517445
🔵 [AuthProvider] checkPhoneExists - Numéro reçu: +243845517445
🔵 [AuthProvider] checkPhoneExists - Numéro formaté: +243845517445
🟢 [FirestoreService] getUserByPhone - Recherche pour: +243845517445
🟢 [FirestoreService] getUserByPhone - Nombre de documents trouvés (format exact): 0
🟡 [FirestoreService] getUserByPhone - Tentative sans espaces: +243845517445
🟡 [FirestoreService] getUserByPhone - Tentative sans +: 243845517445
🟡 [FirestoreService] getUserByPhone - Tentative avec +: +243845517445
🟡 [FirestoreService] getUserByPhone - Aucun utilisateur trouvé pour: +243845517445 (tous les formats testés)
```
→ **Le numéro n'existe vraiment pas dans Firestore OU est dans un format très différent**

### Étape 4 : Solutions Possibles

#### Solution 1 : Standardiser les Numéros dans Firestore
Si les numéros sont dans différents formats, exécuter ce script Firestore :

```javascript
// À exécuter dans la console Firebase (Firestore Rules Playground ou Functions)
const users = await db.collection('users').get();
users.forEach(async (doc) => {
  const phone = doc.data().phone;
  if (phone) {
    // Nettoyer et formater
    let cleaned = phone.replace(/[^\d+]/g, ''); // Garder seulement chiffres et +
    
    // Ajouter le + si nécessaire
    if (!cleaned.startsWith('+')) {
      if (cleaned.startsWith('0')) {
        cleaned = cleaned.substring(1); // Retirer le 0
      }
      cleaned = '+243' + cleaned; // Ajouter code pays
    }
    
    // Mettre à jour si différent
    if (cleaned !== phone) {
      await doc.ref.update({ phone: cleaned });
      console.log(`Updated: ${phone} -> ${cleaned}`);
    }
  }
});
```

#### Solution 2 : Vérifier les Permissions Firestore
Assurez-vous que les règles Firestore permettent la lecture :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if true; // Pour le debug, à sécuriser ensuite
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### Solution 3 : Index Firestore
Si vous avez beaucoup d'utilisateurs, créer un index composite :
1. Aller dans Firestore > Indexes
2. Créer un index sur `users` collection
3. Champ : `phone` (Ascending)

## Tests à Effectuer

### Test 1 : Numéro avec +
```
Input : +243845517445
Attendu : TROUVÉ
```

### Test 2 : Numéro sans +
```
Input : 243845517445
Attendu : TROUVÉ (après ajout automatique du +)
```

### Test 3 : Numéro avec 0 au début
```
Input : 0845517445
Attendu : TROUVÉ (transformé en +243845517445)
```

### Test 4 : Numéro avec espaces
```
Input : +243 845 517 445
Attendu : TROUVÉ (espaces retirés)
```

## Commandes Utiles

### Voir les logs en temps réel
```bash
cd /Users/apple/Documents/dev/flutter/safari_smart_mobility
flutter run
```

### Filtrer uniquement les logs de recherche
```bash
flutter logs | grep -E "LOGIN|AuthProvider|FirestoreService"
```

### Lister tous les numéros dans Firestore (via Firebase CLI)
```bash
firebase firestore:get users --project YOUR_PROJECT_ID
```

## Checklist de Vérification

- [ ] Les numéros existent bien dans Firestore (vérifier manuellement)
- [ ] Le champ est bien nommé `phone` (pas `phoneNumber` ou autre)
- [ ] Les règles Firestore permettent la lecture
- [ ] L'application a accès à Internet
- [ ] Firebase est bien configuré (google-services.json présent)
- [ ] Les logs montrent les tentatives de recherche
- [ ] Tester avec et sans le signe +
- [ ] Tester avec et sans espaces

## Contact

Si le problème persiste après ces vérifications :
1. Copier TOUS les logs de console
2. Faire une capture d'écran du document Firestore
3. Noter le format exact du numéro dans Firestore
4. Noter le format exact du numéro saisi

---

**Dernière mise à jour** : Implémentation de la recherche multi-format
**Status** : Logs de debug activés ✅
