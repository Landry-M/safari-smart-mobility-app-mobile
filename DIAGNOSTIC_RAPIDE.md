# Diagnostic rapide - Pas d'insertion dans MySQL

## 1. Vérifier les logs Flutter

Après avoir fait un achat, vous DEVEZ voir ces logs :

```
🔵 Début de l'insertion du billet dans MySQL...
🔵 Récupération du client_id pour UID: xxxxx
```

### ❓ Question 1 : Voyez-vous ce log "🔵 Début de l'insertion" ?

**Si NON** → Le code n'est pas exécuté, recompiler l'APK
**Si OUI** → Passez à la question 2

### ❓ Question 2 : Quel est le message après ?

**A. `⚠️ Impossible de récupérer le client_id`**
→ Problème : Le client n'existe pas dans MySQL
→ Solution : Vérifier que l'inscription crée bien le client

**B. `✅ client_id trouvé: XX`**
→ Bon, passez à la question 3

**C. `⚠️ Erreur lors de l'enregistrement dans MySQL (non-bloquante): ...`**
→ Erreur API, voir le message exact

### ❓ Question 3 : Voyez-vous "🔵 Réponse createBillet: ..." ?

**Si NON** → L'appel API échoue avant la réponse
**Si OUI** → Quelle est la réponse ?

## 2. Tests à faire

### Test A : Vérifier que le client existe
```bash
curl https://apiv2.hakika.events/clients/uid/VOTRE_FIREBASE_UID
```

**Résultat attendu :**
```json
{
  "success": true,
  "data": {
    "id": XX,
    "uid": "votre_uid",
    ...
  }
}
```

**Si erreur 404** → Le client n'a pas été créé lors de l'inscription

### Test B : Tester l'API billets manuellement
```bash
curl -X POST https://apiv2.hakika.events/billets \
  -H 'Content-Type: application/json' \
  -d '{
    "numero_billet": "TEST-MANUAL-'$(date +%s)'",
    "qr_code": "QR-TEST",
    "trajet_id": 7,
    "bus_id": 421,
    "client_id": 1,
    "arret_depart": "KAPELA",
    "arret_arrivee": "CLINIC NGALIEMA",
    "date_voyage": "'$(date +%Y-%m-%d)'",
    "prix_paye": 100.00,
    "devise": "CDF",
    "statut_billet": "paye",
    "mode_paiement": "autre"
  }'
```

**Résultat attendu :**
```json
{
  "success": true,
  "message": "Billet créé avec succès",
  "data": {
    "id": XXX,
    ...
  }
}
```

### Test C : Vérifier en base de données
```bash
mysql -u ngla4195_ngla4195 -p'vlE+(*efYDZj' ngla4195_safari -e "SELECT COUNT(*) as total FROM billets;"
```

## 3. Problèmes courants

### Problème A : L'app utilise l'ancien code
**Symptôme :** Aucun log avec 🔵, ✅ ou ❌

**Solution :**
```bash
# Nettoyer le build
cd /Users/apple/Documents/dev/flutter/safari_smart_mobility
flutter clean
flutter pub get

# Recompiler
flutter build apk --release

# Ou si vous testez en debug
flutter build apk --debug
```

### Problème B : L'API n'est pas accessible
**Symptôme :** `⚠️ Erreur lors de l'enregistrement dans MySQL (non-bloquante): SocketException`

**Solution :** Vérifier la connexion internet et l'URL de l'API

### Problème C : Le client n'existe pas dans MySQL
**Symptôme :** `⚠️ Client non trouvé dans MySQL pour UID: xxxxx`

**Solution :** Vérifier le code d'inscription dans `auth_provider.dart`
```dart
// Dans verifyFirebaseOTP(), ligne ~355
await _apiService.createClientInMySQL(
  uid: uid,  // ← Doit être l'UID Firebase
  ...
);
```

### Problème D : Erreur de type de données
**Symptôme :** `❌ Échec de l'enregistrement du billet: ...`

**Solution :** Voir le message exact dans les logs

## 4. Actions immédiates

### Étape 1 : Afficher les logs
```bash
# Si vous utilisez Android Studio
# Allez dans l'onglet "Run" ou "Logcat"
# Filtrez avec "flutter" ou "I/flutter"

# Ou via terminal
flutter logs
```

### Étape 2 : Faire un achat de test
1. Ouvrir l'app
2. Aller sur "Acheter un billet"
3. Sélectionner un bus
4. Confirmer l'achat
5. **NOTER TOUS LES LOGS** qui apparaissent

### Étape 3 : Copier les logs ici
Cherchez spécifiquement :
- `🔵` - Logs d'information
- `✅` - Logs de succès
- `⚠️` - Avertissements
- `❌` - Erreurs

## 5. Checklist de vérification

- [ ] L'APK a été recompilé après les modifications
- [ ] L'app est bien installée (nouvelle version)
- [ ] Les logs Flutter sont visibles
- [ ] Un achat a été fait pour tester
- [ ] Les logs montrent "🔵 Début de l'insertion du billet dans MySQL..."
- [ ] Le client_id est bien récupéré
- [ ] L'API répond (pas de SocketException)

## 6. Commandes de diagnostic rapide

```bash
# 1. Vérifier que l'API fonctionne
curl https://apiv2.hakika.events/clients

# 2. Tester la création de billet
php /Users/apple/Documents/dev/flutter/safari_smart_mobility/api/test_billet_api.php

# 3. Vérifier les billets en BDD
mysql -u ngla4195_ngla4195 -p'vlE+(*efYDZj' ngla4195_safari \
  -e "SELECT id, numero_billet, trajet_id, client_id, date_creation FROM billets ORDER BY id DESC LIMIT 5;"

# 4. Vérifier les clients
mysql -u ngla4195_ngla4195 -p'vlE+(*efYDZj' ngla4195_safari \
  -e "SELECT id, uid, nom, prenom FROM clients ORDER BY id DESC LIMIT 5;"
```

## 7. Information à me donner

Pour que je puisse vous aider, donnez-moi :

1. **Les logs complets** après un achat (copier-coller)
2. **Le résultat du Test A** (vérification client)
3. **Le résultat du Test B** (test API manuel)
4. **Le nombre de billets** actuellement en BDD (`SELECT COUNT(*) FROM billets`)
5. **La version de l'app** installée (vérifier la date/heure de compilation)

## 8. Solution rapide probable

Le problème le plus probable : **L'APK n'a pas été recompilé**

Faites ceci maintenant :
```bash
cd /Users/apple/Documents/dev/flutter/safari_smart_mobility
flutter clean
flutter build apk --split-per-abi
# Installer le nouvel APK
# Refaire un test d'achat
# Vérifier les logs
```
