# Documentation API - Safari Smart Mobility

**Base URL:** `https://apiv2.hakika.events`

## Routes Clients

### 1. Créer un client
```http
POST /clients
Content-Type: application/json

Body:
{
  "uid": "firebase_uid_123",
  "telephone": "+243812345678",
  "nom": "Doe",
  "prenom": "John",
  "email": "john@example.com"
}

Response 201:
{
  "success": true,
  "message": "Client créé avec succès",
  "data": {
    "id": 1,
    "uid": "firebase_uid_123",
    "nom": "Doe",
    "prenom": "John",
    "telephone": "+243812345678",
    "email": "john@example.com"
  }
}
```

### 2. Récupérer tous les clients
```http
GET /clients

Response 200:
{
  "success": true,
  "count": 10,
  "data": [...]
}
```

### 3. Récupérer un client par ID
```http
GET /clients/{id}

Response 200:
{
  "success": true,
  "data": {...}
}
```

### 4. Récupérer un client par UID Firebase
```http
GET /clients/uid/{uid}

Exemple: GET /clients/uid/firebase_uid_123

Response 200:
{
  "success": true,
  "data": {
    "id": 1,
    "uid": "firebase_uid_123",
    ...
  }
}
```

### 5. Récupérer un client par téléphone
```http
GET /clients/phone/{phone}

Exemple: GET /clients/phone/%2B243812345678

Response 200:
{
  "success": true,
  "data": {...}
}
```

### 6. Mettre à jour un client
```http
PUT /clients/{id}
Content-Type: application/json

Body:
{
  "nom": "Smith",
  "prenom": "Jane",
  "telephone": "+243823456789",
  "email": "jane@example.com"
}

Response 200:
{
  "success": true,
  "message": "Client mis à jour avec succès"
}
```

### 7. Supprimer un client
```http
DELETE /clients/{id}

Response 200:
{
  "success": true,
  "message": "Client supprimé avec succès"
}
```

### 8. Vérifier existence d'un client par ID
```http
GET /clients/{id}/exists

Response 200:
{
  "success": true,
  "exists": true
}
```

### 9. Vérifier existence d'un client par UID
```http
GET /clients/uid/{uid}/exists

Response 200:
{
  "success": true,
  "exists": true
}
```

## Routes Bus

### 1. Récupérer tous les bus actifs
```http
GET /bus

Response 200:
{
  "success": true,
  "count": 15,
  "data": [
    {
      "id": 1,
      "numero": "421",
      "immatriculation": "KIN-1234-AB",
      "marque": "Mercedes",
      "modele": "Sprinter",
      "annee": 2022,
      "capacite": 50,
      "kilometrage": 125450,
      "ligne_affectee": "8",
      "statut": "actif",
      "modules": "datcha,wifi,pos",
      "notes": "",
      "derniere_activite": "2025-10-15 18:35:52",
      "latitude": "-4.33091979",
      "longitude": "15.27416397",
      "date_creation": "2025-10-08 17:23:37"
    },
    ...
  ]
}
```

### 2. Récupérer les bus par ligne affectée ⭐
```http
GET /bus/ligne/{ligne_id}

Exemple: GET /bus/ligne/8

Response 200:
{
  "success": true,
  "count": 3,
  "data": [
    {
      "id": 1,
      "numero": "421",
      "ligne_affectee": "8",
      "statut": "actif",
      ...
    },
    ...
  ]
}
```

### 3. Récupérer un bus par ID
```http
GET /bus/{id}

Exemple: GET /bus/1

Response 200:
{
  "success": true,
  "data": {...}
}
```

### 4. Récupérer un bus par numéro
```http
GET /bus/numero/{numero}

Exemple: GET /bus/numero/421

Response 200:
{
  "success": true,
  "data": {...}
}
```

### 5. Vérifier existence d'un bus
```http
GET /bus/{id}/exists

Response 200:
{
  "success": true,
  "exists": true
}
```

## Routes Trajets

### 1. Récupérer tous les trajets actifs
```http
GET /trajets

Response 200:
{
  "success": true,
  "count": 8,
  "data": [
    {
      "id": 7,
      "code": null,
      "nom": "KAPELA - CLINIC NGALIEMA",
      "distance_totale": "27.00",
      "duree_estimee": "0",
      "statut": "actif",
      "latitude_depart": null,
      "longitude_depart": null,
      "latitude_arrivee": null,
      "longitude_arrivee": null,
      "date_creation": "2025-10-10 14:08:42"
    },
    ...
  ]
}
```

### 2. Récupérer les noms de lignes (pour dropdown)
```http
GET /trajets/lignes

Response 200:
{
  "success": true,
  "count": 8,
  "data": [
    {
      "id": 7,
      "nom": "KAPELA - CLINIC NGALIEMA",
      "code": null,
      "distance_totale": "27.00",
      "duree_estimee": "0"
    },
    {
      "id": 8,
      "nom": "UPN - CAMPUS (TRAFIC)",
      "code": null,
      "distance_totale": "15.00",
      "duree_estimee": "0"
    },
    ...
  ]
}
```

### 3. Récupérer un trajet par ID
```http
GET /trajets/{id}

Exemple: GET /trajets/7

Response 200:
{
  "success": true,
  "data": {
    "id": 7,
    "code": null,
    "nom": "KAPELA - CLINIC NGALIEMA",
    "distance_totale": "27.00",
    "duree_estimee": "0",
    "statut": "actif",
    "latitude_depart": null,
    "longitude_depart": null,
    "latitude_arrivee": null,
    "longitude_arrivee": null,
    ...
  }
}
```

### 4. Récupérer un trajet par nom
```http
GET /trajets/ligne/{nom}

Exemple: GET /trajets/ligne/KAPELA%20-%20CLINIC%20NGALIEMA

Response 200:
{
  "success": true,
  "data": {...}
}
```

### 5. Vérifier existence d'un trajet
```http
GET /trajets/{id}/exists

Response 200:
{
  "success": true,
  "exists": true
}
```

## Codes de statut HTTP

- **200 OK** : Requête réussie
- **201 Created** : Ressource créée avec succès
- **400 Bad Request** : Données invalides ou manquantes
- **404 Not Found** : Ressource non trouvée
- **405 Method Not Allowed** : Méthode HTTP non autorisée
- **500 Internal Server Error** : Erreur serveur

## Exemples avec cURL

### Créer un client
```bash
curl -X POST https://apiv2.hakika.events/clients \
  -H "Content-Type: application/json" \
  -d '{
    "uid": "firebase_uid_test",
    "telephone": "+243812345678",
    "nom": "Doe",
    "prenom": "John",
    "email": "john@example.com"
  }'
```

### Récupérer les lignes pour le dropdown
```bash
curl https://apiv2.hakika.events/trajets/lignes
```

### Récupérer les bus d'une ligne spécifique
```bash
curl https://apiv2.hakika.events/bus/ligne/8
```

### Récupérer un client par UID Firebase
```bash
curl https://apiv2.hakika.events/clients/uid/firebase_uid_123
```

### Mettre à jour un client
```bash
curl -X PUT https://apiv2.hakika.events/clients/1 \
  -H "Content-Type: application/json" \
  -d '{
    "nom": "Smith",
    "prenom": "Jane",
    "telephone": "+243823456789",
    "email": "jane@example.com"
  }'
```

## Notes importantes

1. **CORS** : L'API accepte les requêtes cross-origin (configuré dans `config/cors.php`)
2. **Content-Type** : Toujours utiliser `application/json` pour les requêtes POST/PUT
3. **Encodage URL** : Les caractères spéciaux doivent être encodés (ex: `+` → `%2B`, espace → `%20`)
4. **Champs requis** :
   - Clients : `uid`, `telephone`
   - Trajets : lecture seule, pas de création via API
5. **Upsert automatique** : Si un client avec le même `uid` existe, il sera mis à jour au lieu d'être créé

## Structure de la base de données

### Table `clients`
- `id` : BIGINT AUTO_INCREMENT PRIMARY KEY
- `uid` : VARCHAR(255) UNIQUE (Firebase UID)
- `nom` : VARCHAR(50)
- `prenom` : VARCHAR(50)
- `telephone` : VARCHAR(50)
- `email` : VARCHAR(50)
- `date_creation` : TIMESTAMP

### Table `trajets`
- `id` : INT AUTO_INCREMENT PRIMARY KEY
- `code` : VARCHAR(50)
- `nom` : VARCHAR(100) NOT NULL
- `distance_totale` : DECIMAL(10,2)
- `duree_estimee` : VARCHAR(50)
- `statut` : ENUM('actif', 'inactif')
- Coordonnées GPS (latitude/longitude départ et arrivée)
- `date_creation` : DATETIME

### Table `bus`
- `id` : INT AUTO_INCREMENT PRIMARY KEY
- `numero` : VARCHAR(20) NOT NULL
- `immatriculation` : VARCHAR(50) NOT NULL
- `marque` : VARCHAR(50)
- `modele` : VARCHAR(50)
- `annee` : INT
- `capacite` : INT
- `kilometrage` : INT
- `ligne_affectee` : VARCHAR(100) (ID du trajet)
- `statut` : ENUM('actif', 'maintenance', 'panne', 'inactif')
- `modules` : TEXT (datcha, wifi, pos, gps, camera)
- `notes` : TEXT
- `derniere_activite` : DATETIME
- `latitude` : DECIMAL(10,8)
- `longitude` : DECIMAL(11,8)
- `date_creation` : DATETIME

## Configuration

**Fichier de configuration :** `api/config/database.php`

```php
$host = "localhost"
$db_name = "ngla4195_safari"
$username = "ngla4195_ngla4195"
$password = "vlE+(*efYDZj"
```

## Logs

Les erreurs sont enregistrées dans `api/logs/error.log`
