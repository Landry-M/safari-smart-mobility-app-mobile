# Changelog API Safari Smart Mobility

## [v2.0.0] - 2025-10-16

### ✨ Changements majeurs

#### Structure de la base de données

**AVANT :**
```sql
id BIGINT PRIMARY KEY (Firebase UID)
nom VARCHAR(50)
prenom VARCHAR(50)
telephone VARCHAR(50)
email VARCHAR(50)
date_creation TIMESTAMP
```

**APRÈS :**
```sql
id BIGINT AUTO_INCREMENT PRIMARY KEY
uid VARCHAR(255) UNIQUE (Firebase UID)
nom VARCHAR(50)
prenom VARCHAR(50)
telephone VARCHAR(50)
email VARCHAR(50)
date_creation TIMESTAMP
```

### 🔄 Modifications API

#### Endpoints modifiés

1. **POST /clients**
   - ✅ Utilise maintenant `uid` au lieu de `id` dans le body
   - ✅ Retourne l'`id` auto-incrémenté et l'`uid` Firebase
   - ✅ Gère l'upsert automatique (INSERT ou UPDATE si uid existe)

2. **Nouveaux endpoints ajoutés**
   - `GET /clients/uid/{uid}` - Récupérer un client par UID Firebase
   - `GET /clients/uid/{uid}/exists` - Vérifier l'existence par UID Firebase

3. **Endpoints existants conservés**
   - `GET /clients/{id}` - Récupérer par ID auto-incrémenté
   - `GET /clients/phone/{phone}` - Récupérer par téléphone
   - `PUT /clients/{id}` - Mettre à jour par ID
   - `DELETE /clients/{id}` - Supprimer par ID
   - `GET /clients/{id}/exists` - Vérifier l'existence par ID

### 📝 Modifications du code

#### Modèle (`api/models/Client.php`)

**Ajouts :**
- Propriété `$uid` pour l'identifiant Firebase
- Méthode `getByUid()` - Récupération par UID Firebase
- Méthode `updateByUid()` - Mise à jour par UID Firebase
- Méthode `existsByUid()` - Vérification d'existence par UID

**Modifications :**
- `create()` : Utilise `uid` au lieu de `id`, récupère l'ID auto-incrémenté avec `lastInsertId()`
- Gestion automatique de l'upsert sur conflit d'`uid` unique

#### Contrôleur (`api/controllers/ClientController.php`)

**Modifications :**
- `create()` : Validation sur `uid` au lieu de `id`
- Ajout de `getByUid($uid)` pour récupération par UID Firebase
- Ajout de `existsByUid($uid)` pour vérification par UID Firebase

#### Routeur (`api/routes/api.php`)

**Ajouts :**
- Routes pour `/clients/uid/{uid}` et `/clients/uid/{uid}/exists`
- Priorisation des routes `uid` et `phone` avant les routes ID numériques

#### Application Flutter (`lib/core/services/api_service.dart`)

**Modifications :**
- Méthode `createClientInMySQL()` : Paramètre `id` renommé en `uid`
- Envoi de `uid` au lieu de `id` dans le body de la requête

#### Provider Flutter (`lib/providers/auth_provider.dart`)

**Modifications :**
- Appel à `createClientInMySQL()` avec le paramètre `uid: uid` au lieu de `id: uid`

### 📚 Documentation mise à jour

- ✅ `README.md` : Tous les exemples et endpoints documentés
- ✅ `INSTALLATION.md` : Exemples de test curl mis à jour
- ✅ `test_api.php` : Tests adaptés avec uid et test supplémentaire `getByUid()`

### 🔧 Migration requise

Pour migrer votre base de données existante :

```sql
-- 1. Ajouter la colonne uid
ALTER TABLE clients ADD COLUMN uid VARCHAR(255) AFTER id;

-- 2. Migrer les données existantes (id -> uid)
UPDATE clients SET uid = id WHERE uid IS NULL;

-- 3. Modifier id en auto-increment
ALTER TABLE clients MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT;

-- 4. Ajouter une contrainte unique sur uid
ALTER TABLE clients ADD UNIQUE KEY unique_uid (uid);

-- 5. Optionnel : Réinitialiser l'auto-increment
ALTER TABLE clients AUTO_INCREMENT = 1;
```

### ⚠️ Breaking Changes

**Pour les applications existantes :**
1. Les requêtes POST doivent maintenant envoyer `uid` au lieu de `id`
2. Les réponses incluent maintenant à la fois `id` (auto-incrémenté) et `uid` (Firebase)
3. Pour récupérer un client par Firebase UID, utiliser `/clients/uid/{uid}` au lieu de `/clients/{id}`

### 📊 Exemples

**Création d'un client :**
```bash
curl -X POST http://localhost/clients \
  -H "Content-Type: application/json" \
  -d '{
    "uid": "firebase_uid_abc123",
    "telephone": "+243812345678",
    "nom": "Doe",
    "prenom": "John",
    "email": "john@example.com"
  }'
```

**Réponse :**
```json
{
  "success": true,
  "message": "Client créé avec succès",
  "data": {
    "id": 1,
    "uid": "firebase_uid_abc123",
    "nom": "Doe",
    "prenom": "John",
    "telephone": "+243812345678",
    "email": "john@example.com"
  }
}
```

**Récupération par UID Firebase :**
```bash
curl http://localhost/clients/uid/firebase_uid_abc123
```

### ✅ Avantages

1. **Performance** : Recherches plus rapides avec index sur ID numérique
2. **Compatibilité** : Support des deux identifiants (ID auto-incrémenté et UID Firebase)
3. **Flexibilité** : Possibilité d'interroger par ID, UID ou téléphone
4. **Intégrité** : Contrainte unique sur UID empêche les doublons Firebase
5. **Évolutivité** : Structure plus standard pour intégrations futures

### 🐛 Corrections

- Gestion correcte de l'upsert (INSERT ou UPDATE automatique)
- Validation renforcée des données requises
- Messages d'erreur plus explicites
- Logs d'erreur améliorés

### 🔐 Sécurité

- Sanitisation des données maintenue (htmlspecialchars, strip_tags)
- Protection contre injection SQL avec PDO prepared statements
- Validation des champs requis côté serveur

---

## Comment tester

```bash
# Tester avec le script PHP
php api/test_api.php

# Ou tester manuellement
curl -X POST http://localhost/clients \
  -H "Content-Type: application/json" \
  -d '{"uid":"test_uid","telephone":"+243812345678","nom":"Test","prenom":"User"}'
```

## Support

Pour toute question sur cette mise à jour, contactez l'équipe de développement.
