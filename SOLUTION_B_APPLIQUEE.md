# Solution B appliquée : Utiliser routeId du bus comme trajet_id

## ✅ Modifications effectuées

### 1. **Backend PHP** (`api/controllers/BilletController.php`)
```php
// Ligne 40
$this->billet->trajet_id = $data->trajet_id ?? 7; // Default: KAPELA - CLINIC NGALIEMA (ID=7)
```

**Logique :**
- Si `trajet_id` est fourni par Flutter → on l'utilise
- Sinon → on utilise **7** (KAPELA - CLINIC NGALIEMA, premier trajet existant)

### 2. **Frontend Flutter** (`lib/screens/tickets/bus_ticket_order_screen.dart`)
```dart
// Lignes 797-802
// Récupérer le trajet_id depuis le bus
int trajetId = 7; // Valeur par défaut: premier trajet existant
if (widget.bus.routeId != null && widget.bus.routeId!.isNotEmpty) {
  trajetId = int.tryParse(widget.bus.routeId!) ?? 7;
}
```

**Logique :**
- Si le bus a un `routeId` valide → conversion en `int` et utilisation
- Si `routeId` est vide/invalide → utilise **7** par défaut
- Passe `trajetId` (non-null) à l'API

## 🎯 Fonctionnement

### Cas 1 : Bus avec routeId défini
```dart
Bus avec routeId = "8"
→ trajetId = 8 (UPN - CAMPUS)
→ Insertion dans MySQL avec trajet_id = 8
```

### Cas 2 : Bus sans routeId
```dart
Bus sans routeId (null ou vide)
→ trajetId = 7 (KAPELA - CLINIC NGALIEMA)
→ Insertion dans MySQL avec trajet_id = 7
```

### Cas 3 : routeId invalide (non-numérique)
```dart
Bus avec routeId = "ABC"
→ int.tryParse("ABC") retourne null
→ trajetId = 7 (fallback)
→ Insertion dans MySQL avec trajet_id = 7
```

## 📊 Trajets existants dans la base de données

| ID | Nom du trajet                    | Statut |
|----|----------------------------------|--------|
| 7  | KAPELA - CLINIC NGALIEMA         | actif  |
| 8  | UPN - CAMPUS (TRAFIC)            | actif  |
| 9  | MASINA Q3 - PLACE DES EVOLUEE    | actif  |

**Trajet par défaut utilisé :** ID = 7 (KAPELA - CLINIC NGALIEMA)

## ✅ Avantages de cette solution

1. **Respecte la contrainte NOT NULL** de la base de données
2. **Utilise le routeId du bus** quand il est disponible
3. **Fallback intelligent** vers un trajet existant
4. **Pas de modification de la structure de la base de données** requise
5. **Données cohérentes** : chaque billet est lié à un trajet réel

## 🔍 Vérification

### Logs à surveiller
```
🔵 Données du billet à insérer:
  - trajetId: 7 (ou 8, 9 selon le bus)
```

### Requête SQL pour vérifier
```sql
-- Voir les derniers billets avec leur trajet
SELECT 
    b.id,
    b.numero_billet,
    b.trajet_id,
    t.nom as trajet_nom,
    b.arret_depart,
    b.arret_arrivee,
    b.date_creation
FROM billets b
LEFT JOIN trajets t ON b.trajet_id = t.id
ORDER BY b.date_creation DESC
LIMIT 10;
```

## 🚀 Prochaines étapes

1. **Recompiler l'application**
   ```bash
   cd /Users/apple/Documents/dev/flutter/safari_smart_mobility
   flutter build apk --split-per-abi
   ```

2. **Installer sur l'appareil**

3. **Tester un achat de billet**
   - Avec un bus qui a un `routeId` valide
   - Avec un bus sans `routeId`

4. **Vérifier en base de données**
   ```sql
   SELECT * FROM billets ORDER BY date_creation DESC LIMIT 1;
   ```

5. **Vérifier les logs**
   - Chercher `trajetId: 7` ou `trajetId: 8` dans les logs
   - Confirmer `✅ Billet enregistré dans MySQL avec succès`

## 📝 Notes importantes

### Si vous ajoutez de nouveaux trajets
Les trajets avec `routeId` correspondant seront automatiquement utilisés. Par exemple :
- Bus avec `routeId = "10"` → utilise trajet_id = 10
- Bus avec `routeId = "NEW"` → utilise trajet_id = 7 (fallback)

### Si vous voulez changer le trajet par défaut
Modifiez la valeur dans **2 endroits** :
1. `api/controllers/BilletController.php` ligne 40
2. `lib/screens/tickets/bus_ticket_order_screen.dart` ligne 799

### Maintenance future
Si le trajet ID=7 est désactivé ou supprimé, changez le trajet par défaut pour un autre ID actif.

## ❌ Erreurs possibles

### Erreur : "trajet_id not found"
**Cause :** Le trajet ID=7 n'existe pas dans votre base de données  
**Solution :** Vérifier les trajets existants et changer l'ID par défaut

### Erreur : "Foreign key constraint fails"
**Cause :** Le trajet_id n'existe pas dans la table `trajets`  
**Solution :** Utiliser l'ID d'un trajet existant comme valeur par défaut

## ✅ Résultat attendu

Après compilation et test, vous devriez voir :
```
🔵 Début de l'insertion du billet dans MySQL...
🔵 Récupération du client_id pour UID: ...
✅ client_id trouvé: X
🔵 Données du billet à insérer:
  - trajetId: 7
  - busId: XXX
  ...
📝 Création de billet dans MySQL: TKT...
✅ Billet créé avec succès dans MySQL: XXX
✅ Billet enregistré dans MySQL avec succès - ID: XXX
```

Et en base de données :
```sql
mysql> SELECT id, numero_billet, trajet_id FROM billets ORDER BY id DESC LIMIT 1;
+-----+-------------------+-----------+
| id  | numero_billet     | trajet_id |
+-----+-------------------+-----------+
| 123 | TKT1729065234567  |     7     |
+-----+-------------------+-----------+
```

## 🎉 C'est prêt !

La solution B est maintenant **100% appliquée**. Vous pouvez compiler et tester ! 🚀
