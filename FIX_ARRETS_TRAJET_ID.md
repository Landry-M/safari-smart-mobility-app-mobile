# Fix : Affichage des arrêts de la ligne

## Problème identifié
L'application affiche "Aucun arrêt trouvé pour cette ligne" alors que des arrêts existent dans la table `arrets` avec `trajet_id = 8`.

## Cause racine
L'API `getArretsLigne(trajetId)` attend le **trajet_id** (ID de la table `trajets`). Le champ `ligne_affectee` a été remplacé par `trajet_id` dans toute l'application.

## Architecture de la base de données

```
Table: bus
├── id (PK)
├── numero (ex: "BUS-225")
├── immatriculation
└── trajet_id (FK → trajets.id)

Table: trajets
├── id (PK) ← C'est ce qu'on cherche !
├── nom
├── depart
└── arrivee

Table: arrets
├── id (PK)
├── trajet_id (FK → trajets.id)
├── nom
├── ordre
└── ...
```

## Solution appliquée

### 1. Migration du champ `ligneAffectee` vers `trajetId`
```dart
class Bus {
  // AVANT: late String? ligneAffectee;
  late int? trajetId;          // ID du trajet dans la table trajets
  late String? nomLigne;       // Nom du trajet
}
```

### 2. Logique de récupération simplifiée
```dart
// Utiliser directement trajetId
int? trajetId = _bus!.trajetId;

if (trajetId != null) {
  // Appel API avec le trajet_id
  _apiService.getArretsLigne(trajetId);
}
```

### 3. Logs de debug ajoutés
```dart
print('🔍 DEBUG - Bus: ${_bus!.numero}');
print('🔍 DEBUG - trajetId: ${_bus!.trajetId}');
print('🔍 DEBUG - nomLigne: ${_bus!.nomLigne}');
print('📡 Appel API getArretsLigne avec trajetId=$trajetId');
```

## ⚠️ ACTION REQUISE CÔTÉ BACKEND

L'endpoint `/bus/numero/{numero}` doit être modifié pour retourner le champ `trajet_id` :

### Requête SQL à modifier
```sql
-- AVANT (ne retourne pas trajet_id)
SELECT 
  id, numero, immatriculation, marque, modele, annee, capacite,
  kilometrage, ligne_affectee, statut, modules, notes
FROM bus
WHERE numero = ?;

-- APRÈS (avec jointure pour récupérer le nom de la ligne)
SELECT 
  b.id, b.numero, b.immatriculation, b.marque, b.modele, b.annee, 
  b.capacite, b.kilometrage, b.trajet_id, b.statut, 
  b.modules, b.notes,
  t.nom AS nom_ligne
FROM bus b
LEFT JOIN trajets t ON b.trajet_id = t.id
WHERE b.numero = ?;
```

### Réponse API attendue
```json
{
  "success": true,
  "data": {
    "id": 1,
    "numero": "BUS-225",
    "immatriculation": "ABC-123",
    "trajet_id": 8,          // ← Champ requis
    "nom_ligne": "Kinshasa - Matadi",
    ...
  }
}
```

## Comment tester

### 1. Vérifier les logs dans la console
```
🔍 DEBUG - Bus: BUS-225
🔍 DEBUG - trajetId: 8
🔍 DEBUG - nomLigne: Kinshasa - Matadi
📡 Appel API getArretsLigne avec trajetId=8
🔍 Récupération des arrêts pour la ligne 8
```

### 2. Vérifier la réponse de l'API
Dans votre backend, ajoutez un log dans `/bus/numero/:numero` :
```javascript
console.log('Réponse bus:', {
  numero: bus.numero,
  trajet_id: bus.trajet_id,  // ← Doit être présent
  nom_ligne: trajet.nom,
});
```

### 3. Vérifier la base de données
```sql
-- Vérifier que le bus a bien un trajet associé
SELECT b.numero, b.trajet_id, t.nom 
FROM bus b 
LEFT JOIN trajets t ON b.trajet_id = t.id
WHERE b.numero = 'BUS-225';

-- Vérifier que les arrêts existent
SELECT COUNT(*) FROM arrets WHERE trajet_id = 8;
```

## Scénarios de test

### ✅ Cas normal : trajet_id retourné par l'API
```
Backend retourne: { trajet_id: 8 }
→ App utilise trajetId = 8
→ Appel GET /trajets/8/arrets
→ Arrêts affichés
```

### ❌ Erreur : trajet_id manquant
```
Backend retourne: { trajet_id: null }
→ Message: "Aucune ligne affectée au bus"
```

## Prochaines étapes

1. ✅ **App Flutter** : Migration terminée
   - Champ `ligneAffectee` supprimé du modèle Bus
   - Utilisation exclusive de `trajetId`
   - Tous les écrans mis à jour
   - Build runner exécuté

2. ⚠️ **Backend API** : Action requise
   - Renommer le champ `ligne_affectee` en `trajet_id` dans la table `bus`
   - Modifier `/bus/numero/:numero` pour utiliser `b.trajet_id`
   - Mettre à jour la jointure: `LEFT JOIN trajets t ON b.trajet_id = t.id`
   - Tester et déployer

3. 🔄 **Test end-to-end**
   - Relancer l'app
   - Se connecter avec une équipe
   - Consulter les arrêts
   - Vérifier les logs

## Fichiers modifiés
- `lib/data/models/bus_model.dart` - Migration de ligneAffectee vers trajetId
- `lib/data/safari_db.sql` - Remplacement de ligne_affectee par trajet_id
- `backend_example/bus_endpoint_fix.sql` - Mise à jour des requêtes SQL
- `lib/screens/driver/home_driver_screen.dart` - Utilisation de trajetId
- `lib/screens/scanner/qr_scanner_screen.dart` - Utilisation de trajetId
- `lib/screens/map/nearby_buses_screen.dart` - Utilisation de trajet_id
- `lib/screens/driver/auth_driver_screen.dart` - Mise à jour des logs
- `lib/providers/ticket_validation_provider.dart` - Migration vers trajetId
- `lib/core/services/api_service.dart` - Mise à jour des commentaires
