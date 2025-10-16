# Guide d'installation de l'API Safari Smart Mobility

Ce guide vous aidera à configurer l'API RESTful pour l'application Safari Smart Mobility.

## Prérequis

- **Serveur Web** : Apache 2.4+ ou Nginx
- **PHP** : Version 7.4 ou supérieure (8.0+ recommandé)
- **MySQL/MariaDB** : Version 5.7+ / 10.4+
- **Extensions PHP requises** :
  - PDO
  - PDO_MySQL
  - JSON
  - mbstring

## Étape 1 : Configuration du serveur web

### Pour Apache

1. **Activer les modules nécessaires** :
```bash
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod deflate
sudo systemctl restart apache2
```

2. **Configurer le Virtual Host** (optionnel mais recommandé) :

Créer un fichier `/etc/apache2/sites-available/safari-api.conf` :

```apache
<VirtualHost *:80>
    ServerName api.safari-mobility.local
    DocumentRoot /chemin/vers/safari_smart_mobility/api
    
    <Directory /chemin/vers/safari_smart_mobility/api>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/safari-api-error.log
    CustomLog ${APACHE_LOG_DIR}/safari-api-access.log combined
</VirtualHost>
```

Activer le site :
```bash
sudo a2ensite safari-api.conf
sudo systemctl reload apache2
```

3. **Ajouter au fichier hosts (pour test local)** :
```bash
sudo nano /etc/hosts
# Ajouter la ligne :
127.0.0.1    api.safari-mobility.local
```

### Pour Nginx

Créer un fichier `/etc/nginx/sites-available/safari-api` :

```nginx
server {
    listen 80;
    server_name api.safari-mobility.local;
    root /chemin/vers/safari_smart_mobility/api;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

Activer le site :
```bash
sudo ln -s /etc/nginx/sites-available/safari-api /etc/nginx/sites-enabled/
sudo systemctl reload nginx
```

## Étape 2 : Configuration de la base de données

1. **Importer le schéma SQL** :
```bash
mysql -u root -p < /chemin/vers/safari_smart_mobility/lib/data/ngla4195_safari.sql
```

Ou via phpMyAdmin :
- Créer une nouvelle base de données `ngla4195_safari`
- Importer le fichier SQL

2. **Créer un utilisateur MySQL dédié** (recommandé) :
```sql
CREATE USER 'safari_api'@'localhost' IDENTIFIED BY 'VotreMotDePasseSecurise';
GRANT SELECT, INSERT, UPDATE, DELETE ON ngla4195_safari.* TO 'safari_api'@'localhost';
FLUSH PRIVILEGES;
```

3. **Configurer les identifiants dans l'API** :

Éditer le fichier `api/config/database.php` :

```php
private $host = "localhost";
private $db_name = "ngla4195_safari";
private $username = "safari_api"; // Utilisateur créé ci-dessus
private $password = "VotreMotDePasseSecurise";
```

## Étape 3 : Configuration des permissions

```bash
# Permissions du dossier API
sudo chown -R www-data:www-data /chemin/vers/safari_smart_mobility/api
sudo chmod -R 755 /chemin/vers/safari_smart_mobility/api

# Créer et donner les permissions au dossier logs
mkdir -p /chemin/vers/safari_smart_mobility/api/logs
sudo chmod 755 /chemin/vers/safari_smart_mobility/api/logs
```

## Étape 4 : Configuration de l'application Flutter

Éditer le fichier `lib/core/services/api_service.dart` :

```dart
// Pour le développement local
static const String _mysqlApiUrl = 'http://localhost/api';

// Pour la production (remplacer par votre domaine réel)
static const String _mysqlApiUrl = 'https://api.safari-mobility.com';
```

### Configuration pour Android

Si vous testez sur un émulateur Android, utilisez l'IP spéciale :
```dart
static const String _mysqlApiUrl = 'http://10.0.2.2/api';
```

Si vous testez sur un appareil physique, utilisez l'IP de votre machine :
```dart
static const String _mysqlApiUrl = 'http://192.168.x.x/api';
```

### Configuration pour iOS

Ajoutez dans `ios/Runner/Info.plist` :
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Étape 5 : Test de l'API

### Test depuis le terminal

1. **Créer un client** :
```bash
curl -X POST http://localhost/clients \
  -H "Content-Type: application/json" \
  -d '{
    "uid": "firebase_uid_test123",
    "telephone": "+243 812 345 678",
    "nom": "Test",
    "prenom": "User",
    "email": "test@example.com"
  }'
```

2. **Récupérer un client** :
```bash
curl http://localhost/api/clients/test123
```

3. **Récupérer tous les clients** :
```bash
curl http://localhost/api/clients
```

### Test depuis l'application

1. Lancez l'application Flutter
2. Créez un nouveau compte
3. Vérifiez les logs dans la console :
   - ✅ `Client créé avec succès dans la base de données MySQL`
   - Ou ⚠️ message d'erreur détaillé

4. Vérifiez dans la base de données :
```sql
SELECT * FROM clients ORDER BY date_creation DESC LIMIT 5;
```

## Étape 6 : Déploiement en production

### Sécurité

1. **Activer HTTPS** (obligatoire en production)
2. **Restreindre CORS** dans `api/config/cors.php` :
```php
// Remplacer * par votre domaine
header("Access-Control-Allow-Origin: https://votre-app.com");
```

3. **Désactiver l'affichage des erreurs** dans `api/index.php` :
```php
ini_set('display_errors', 0);
```

4. **Ajouter l'authentification JWT** (recommandé)

5. **Implémenter un rate limiting**

### Mise à jour de l'URL

Dans `api_service.dart`, mettre à jour :
```dart
static const String _mysqlApiUrl = 'https://votre-domaine.com/api';
```

## Dépannage

### Erreur 500 - Vérifier les logs

```bash
# Logs Apache
tail -f /var/log/apache2/safari-api-error.log

# Logs de l'API
tail -f /chemin/vers/api/logs/error.log

# Logs PHP
tail -f /var/log/php/error.log
```

### Erreur de connexion à la base de données

1. Vérifier que MySQL est démarré :
```bash
sudo systemctl status mysql
```

2. Tester la connexion :
```bash
mysql -u safari_api -p ngla4195_safari
```

### Problème CORS

Vérifier que les headers sont bien envoyés :
```bash
curl -I http://localhost/api/clients
```

### L'API ne répond pas

1. Vérifier que mod_rewrite est activé
2. Vérifier les permissions du fichier .htaccess
3. Tester l'accès direct : `http://localhost/api/index.php/clients`

## Support

Pour toute assistance, consultez :
- La documentation dans `api/README.md`
- Les logs d'erreur
- L'équipe de développement Safari Smart Mobility

## Checklist de déploiement

- [ ] Base de données importée
- [ ] Utilisateur MySQL créé
- [ ] Fichier `config/database.php` configuré
- [ ] Permissions des fichiers définies
- [ ] Apache/Nginx configuré
- [ ] .htaccess en place
- [ ] Test de création de client réussi
- [ ] Logs d'erreur vides
- [ ] CORS configuré
- [ ] HTTPS activé (production)
- [ ] URL mise à jour dans l'app Flutter
- [ ] Application testée avec l'API
