# API Safari Smart Mobility

API RESTful pour la gestion des clients de l'application Safari Smart Mobility.

## Architecture MVC

```
api/
├── config/
│   ├── database.php    # Configuration de la base de données
│   └── cors.php        # Configuration CORS
├── models/
│   └── Client.php      # Modèle Client
├── controllers/
│   └── ClientController.php  # Contrôleur Client
├── routes/
│   └── api.php         # Routeur API
├── logs/
│   └── error.log       # Logs d'erreur
├── .htaccess           # Configuration Apache
├── index.php           # Point d'entrée
└── README.md           # Documentation
```

## Configuration

### 1. Base de données

Modifiez les paramètres de connexion dans `config/database.php` :

```php
private $host = "localhost";
private $db_name = "ngla4195_safari";
private $username = "votre_username";
private $password = "votre_password";
```

### 2. Apache

Assurez-vous que les modules Apache suivants sont activés :
- `mod_rewrite`
- `mod_headers`
- `mod_deflate`

Pour activer ces modules sur Ubuntu/Debian :
```bash
sudo a2enmod rewrite headers deflate
sudo systemctl restart apache2
```

### 3. Permissions

Donnez les permissions nécessaires au dossier logs :
```bash
chmod 755 api/logs
```

## Endpoints

### Base URL
```
http://votre-domaine.com/api/
```

### 1. Créer un client

**Endpoint:** `POST /clients`

**Body:**
```json
{
  "uid": "firebase_uid",
  "nom": "Doe",
  "prenom": "John",
  "telephone": "+243 812 345 678",
  "email": "john.doe@example.com"
}
```

**Réponse (201):**
```json
{
  "success": true,
  "message": "Client créé avec succès",
  "data": {
    "id": 1,
    "uid": "firebase_uid",
    "nom": "Doe",
    "prenom": "John",
    "telephone": "+243 812 345 678",
    "email": "john.doe@example.com"
  }
}
```

**Note:** Le champ `id` est auto-incrémenté par la base de données, le champ `uid` contient l'identifiant Firebase.

### 2. Récupérer un client par ID auto-incrémenté

**Endpoint:** `GET /clients/{id}`

**Réponse (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "uid": "firebase_uid",
    "nom": "Doe",
    "prenom": "John",
    "telephone": "+243 812 345 678",
    "email": "john.doe@example.com",
    "date_creation": "2025-10-16 03:27:00"
  }
}
```

### 3. Récupérer un client par UID Firebase

**Endpoint:** `GET /clients/uid/{uid}`

**Exemple:** `GET /clients/uid/firebase_uid_123`

**Réponse (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "uid": "firebase_uid_123",
    "nom": "Doe",
    "prenom": "John",
    "telephone": "+243 812 345 678",
    "email": "john.doe@example.com",
    "date_creation": "2025-10-16 03:27:00"
  }
}
```

### 4. Récupérer un client par téléphone

**Endpoint:** `GET /clients/phone/{phone}`

**Exemple:** `GET /clients/phone/+243%20812%20345%20678`

**Réponse (200):**
```json
{
  "success": true,
  "data": {
    "id": "firebase_uid",
    "nom": "Doe",
    "prenom": "John",
    "telephone": "+243 812 345 678",
    "email": "john.doe@example.com",
    "date_creation": "2025-10-16 03:27:00"
  }
}
```

### 5. Récupérer tous les clients

**Endpoint:** `GET /clients`

**Réponse (200):**
```json
{
  "success": true,
  "count": 10,
  "data": [
    {
      "id": "firebase_uid_1",
      "nom": "Doe",
      "prenom": "John",
      "telephone": "+243 812 345 678",
      "email": "john.doe@example.com",
      "date_creation": "2025-10-16 03:27:00"
    }
  ]
}
```

### 6. Mettre à jour un client

**Endpoint:** `PUT /clients/{id}`

**Body:**
```json
{
  "nom": "Smith",
  "prenom": "Jane",
  "telephone": "+243 823 456 789",
  "email": "jane.smith@example.com"
}
```

**Réponse (200):**
```json
{
  "success": true,
  "message": "Client mis à jour avec succès"
}
```

**Note:** Cette route est utilisée automatiquement par l'application mobile lors de la mise à jour du profil utilisateur. Le client est d'abord récupéré par son UID Firebase via `GET /clients/uid/{uid}`, puis mis à jour avec son ID auto-incrémenté.

### 7. Supprimer un client

**Endpoint:** `DELETE /clients/{id}`

**Réponse (200):**
```json
{
  "success": true,
  "message": "Client supprimé avec succès"
}
```

### 8. Vérifier l'existence d'un client par ID

**Endpoint:** `GET /clients/{id}/exists`

**Réponse (200):**
```json
{
  "success": true,
  "exists": true
}
```

### 9. Vérifier l'existence d'un client par UID Firebase

**Endpoint:** `GET /clients/uid/{uid}/exists`

**Exemple:** `GET /clients/uid/firebase_uid_123/exists`

**Réponse (200):**
```json
{
  "success": true,
  "exists": true
}
```

## Codes de statut HTTP

- `200 OK` : Requête réussie
- `201 Created` : Ressource créée avec succès
- `400 Bad Request` : Données invalides
- `404 Not Found` : Ressource non trouvée
- `405 Method Not Allowed` : Méthode HTTP non autorisée
- `500 Internal Server Error` : Erreur serveur

## Sécurité

### En production, n'oubliez pas de :

1. **Restreindre CORS** : Modifier `Access-Control-Allow-Origin` dans `config/cors.php`
2. **Ajouter une authentification** : Implémenter un système de tokens JWT
3. **Valider les données** : Ajouter une validation plus stricte des entrées
4. **Chiffrer les communications** : Utiliser HTTPS
5. **Limiter le débit** : Implémenter un rate limiting
6. **Désactiver les erreurs** : Mettre `display_errors = 0` en production

## Logs

Les erreurs sont enregistrées dans `api/logs/error.log`. Consultez ce fichier en cas de problème.

## Cas d'usage

### 1. Inscription d'un nouvel utilisateur
L'application mobile appelle automatiquement `POST /clients` après l'authentification Firebase :
```bash
POST /clients
Body: { "uid": "firebase_uid", "telephone": "+243...", "nom": "...", "prenom": "..." }
```

### 2. Mise à jour du profil utilisateur
L'application mobile met à jour automatiquement MySQL après Firestore :
```bash
# 1. Récupération du client par UID
GET /clients/uid/{firebase_uid}

# 2. Mise à jour avec l'ID récupéré
PUT /clients/{id}
Body: { "nom": "...", "prenom": "...", "telephone": "...", "email": "..." }
```

### 3. Vérification d'existence
Avant toute opération, vérifier si un utilisateur existe :
```bash
GET /clients/uid/{firebase_uid}/exists
```

## Support

Pour toute question, contactez l'équipe de développement Safari Smart Mobility.

### Documentation complémentaire
- **`SYNC_PROFILE.md`** - Détails sur la synchronisation du profil utilisateur
- **`CHANGELOG.md`** - Historique des versions et changements
- **`INSTALLATION.md`** - Guide d'installation détaillé
