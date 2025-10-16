# Guide de diagnostic - Insertion des billets dans MySQL

## Problème rapporté
Les achats de billets ne s'insèrent pas dans la base de données MySQL.

## Corrections apportées

### 1. Amélioration du logging
- ✅ Ajout de logs détaillés dans `bus_ticket_order_screen.dart`
- ✅ Logs avant/après chaque étape (récupération client_id, insertion billet)
- ✅ Capture du stack trace complet en cas d'erreur

### 2. Correction du type de données
- ✅ Conversion de `bus_id` STRING → INT dans `Billet.php`
- ✅ Le modèle accepte maintenant les deux formats

### 3. Script de test créé
- ✅ `api/test_billet_api.php` - Pour tester l'API indépendamment

## Étapes de diagnostic

### Étape 1: Exécuter le script de test
```bash
cd /Users/apple/Documents/dev/flutter/safari_smart_mobility/api
php test_billet_api.php
```

**Ce qui doit apparaître :**
```
=== TEST 1: Connexion à la base de données ===
✅ Connexion réussie

=== TEST 2: Vérification de la table billets ===
✅ Table 'billets' existe

=== TEST 3: Structure de la table billets ===
Colonnes trouvées:
  - id (int(11))
  - numero_billet (varchar(50))
  - qr_code (varchar(255))
  - bus_id (int(11))
  ...

=== TEST 4: Création d'un billet de test ===
✅ Billet créé avec succès
   ID: xxx
   Numéro: TEST-xxx

=== TEST 5: Vérification de l'insertion ===
✅ Billet trouvé dans la base de données
```

**Si vous voyez des ❌**, notez l'erreur exacte.

### Étape 2: Vérifier les logs Flutter

Après avoir fait un nouvel achat, cherchez dans les logs :

```
🔵 Début de l'insertion du billet dans MySQL...
🔵 Récupération du client_id pour UID: xxxxx
🔵 Réponse getClientByUid: {...}
✅ client_id trouvé: xx
🔵 Données du billet à insérer:
  - numeroBillet: TKTxxxxx
  - busId: xxx
  - clientId: xxx
  ...
🔵 Réponse createBillet: {...}
✅ Billet enregistré dans MySQL avec succès - ID: xxx
```

### Étape 3: Vérifier que le client existe dans MySQL

```bash
# Via curl
curl https://apiv2.hakika.events/clients/uid/VOTRE_FIREBASE_UID

# Ou en SQL
mysql -u ngla4195_ngla4195 -p ngla4195_safari
SELECT * FROM clients WHERE uid = 'VOTRE_FIREBASE_UID';
```

**Si le client n'existe pas**, c'est normal pour la première inscription. Le système devrait le créer automatiquement.

### Étape 4: Test manuel de l'API via curl

```bash
curl -X POST https://apiv2.hakika.events/billets \
  -H 'Content-Type: application/json' \
  -d '{
    "numero_billet": "TEST-MANUEL-'$(date +%s)'",
    "qr_code": "QR-TEST-'$(date +%s)'",
    "arret_depart": "Test Départ",
    "arret_arrivee": "Test Arrivée",
    "date_voyage": "'$(date +%Y-%m-%d)'",
    "prix_paye": 100.00,
    "devise": "CDF",
    "statut_billet": "paye",
    "mode_paiement": "autre"
  }'
```

**Réponse attendue :**
```json
{
  "success": true,
  "message": "Billet créé avec succès",
  "data": {
    "id": xxx,
    "numero_billet": "TEST-MANUEL-xxx",
    ...
  }
}
```

### Étape 5: Vérifier directement en base de données

```sql
-- Connexion MySQL
mysql -u ngla4195_ngla4195 -p'vlE+(*efYDZj' ngla4195_safari

-- Voir les derniers billets
SELECT * FROM billets ORDER BY date_creation DESC LIMIT 5;

-- Compter les billets
SELECT COUNT(*) FROM billets;

-- Voir les billets d'aujourd'hui
SELECT * FROM billets WHERE DATE(date_creation) = CURDATE();
```

## Problèmes courants et solutions

### ❌ Erreur: "Client non trouvé dans MySQL"
**Solution :** Le client n'a pas été créé lors de l'inscription.
```dart
// Vérifier que l'inscription crée bien le client
// Fichier: lib/providers/auth_provider.dart
// Méthode: verifyFirebaseOTP()
await _apiService.createClientInMySQL(...)
```

### ❌ Erreur: "bus_id must be an integer"
**Solution :** Déjà corrigée dans `Billet.php` (conversion automatique)

### ❌ Erreur: "Connection timeout"
**Solution :** Vérifier que l'URL de l'API est accessible
```dart
// lib/core/services/api_service.dart
static const String _mysqlApiUrl = 'https://apiv2.hakika.events';
```

### ❌ Erreur: "arret_depart is required"
**Solution :** Vérifier que `widget.bus.routeName` contient bien une valeur

### ❌ Aucune erreur mais rien n'est inséré
**Solution :** Vérifier les logs détaillés activés dans le code

## Fichiers modifiés

1. ✅ `api/models/Billet.php` - Conversion bus_id
2. ✅ `lib/screens/tickets/bus_ticket_order_screen.dart` - Logs améliorés
3. ✅ `api/test_billet_api.php` - Script de test créé

## Prochaine étape

1. **Compiler et réinstaller l'APK**
   ```bash
   cd /Users/apple/Documents/dev/flutter/safari_smart_mobility
   flutter build apk --split-per-abi
   ```

2. **Installer sur votre appareil**

3. **Faire un nouvel achat de billet**

4. **Vérifier les logs**
   - Dans Android Studio : onglet "Run" ou "Logcat"
   - Chercher les lignes avec 🔵, ✅ ou ❌

5. **Vérifier en base de données**
   ```sql
   SELECT * FROM billets ORDER BY date_creation DESC LIMIT 1;
   ```

## Support

Si le problème persiste après ces étapes :
1. Exécuter `php api/test_billet_api.php`
2. Capturer les logs Flutter complets
3. Vérifier la réponse de l'API avec curl
4. Partager les messages d'erreur exacts

## Logs à vérifier

Les nouveaux logs commencent par des emojis :
- 🔵 = Information / Étape en cours
- ✅ = Succès
- ⚠️ = Avertissement (non-bloquant)
- ❌ = Erreur

Exemple de flux réussi :
```
🔵 Début de l'insertion du billet dans MySQL...
🔵 Récupération du client_id pour UID: abc123
🔵 Réponse getClientByUid: {success: true, data: {id: 5, ...}}
✅ client_id trouvé: 5
🔵 Données du billet à insérer:
  - numeroBillet: TKT1729065234567
  - busId: 421
  - clientId: 5
  - arretDepart: KAPELA
  - arretArrivee: CLINIC NGALIEMA
  - dateVoyage: 2025-10-16
  - prixPaye: 200.0
  - devise: CDF
  - modePaiement: autre
📝 Création de billet dans MySQL: TKT1729065234567
🔵 Réponse createBillet: {success: true, message: Billet créé avec succès, data: {id: 123, ...}}
✅ Billet créé avec succès dans MySQL: 123
✅ Billet enregistré dans MySQL avec succès - ID: 123
```
