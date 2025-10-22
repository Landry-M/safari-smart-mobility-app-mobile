# Migration : ligne_affectee → trajet_id

## 📋 Vue d'ensemble

Le champ `ligne_affectee` (String) a été **complètement supprimé** et remplacé par `trajet_id` (int) dans toute l'application Flutter et dans le schéma de base de données.

## ✅ Modifications terminées (Application Flutter)

### 1. Base de données locale (SQL)
- **Fichier**: `lib/data/safari_db.sql`
- **Changement**: Colonne `ligne_affectee VARCHAR(100)` → `trajet_id INT(11)`
- **Valeurs**: Converties de chaînes (`'8'`, `'14'`) vers entiers (`8`, `14`)

### 2. Modèle de données
- **Fichier**: `lib/data/models/bus_model.dart`
- **Supprimé**: `late String? ligneAffectee;`
- **Conservé**: `late int? trajetId;` et `late String? nomLigne;`
- **Régénération Isar**: ✅ Exécutée avec succès

### 3. Écrans mis à jour
| Fichier | Modifications |
|---------|--------------|
| `home_driver_screen.dart` | Remplacement de toutes les références `ligneAffectee` par `trajetId` |
| `qr_scanner_screen.dart` | Variable `_currentBusLigneAffectee` → `_currentBusTrajetId` (int) |
| `nearby_buses_screen.dart` | Utilisation de `bus['trajet_id']` au lieu de `bus['ligne_affectee']` |
| `auth_driver_screen.dart` | Mise à jour des logs de debug |

### 4. Services et providers
| Fichier | Modifications |
|---------|--------------|
| `api_service.dart` | Commentaires mis à jour |
| `ticket_validation_provider.dart` | Migration de `_currentBusLigneAffectee` vers `_currentBusTrajetId` |

### 5. Backend SQL
- **Fichier**: `backend_example/bus_endpoint_fix.sql`
- **Changement**: Toutes les requêtes utilisent maintenant `b.trajet_id` au lieu de `b.ligne_affectee`
- **Jointure**: `LEFT JOIN trajets t ON b.trajet_id = t.id`

## ⚠️ ACTIONS REQUISES CÔTÉ BACKEND

### 🔧 Étape 1: Modifier le schéma de la table `bus`

```sql
-- Option A: Renommer la colonne (si elle contient déjà des IDs numériques)
ALTER TABLE bus 
CHANGE COLUMN ligne_affectee trajet_id INT(11) DEFAULT NULL;

-- Option B: Créer nouvelle colonne + migration des données
ALTER TABLE bus ADD COLUMN trajet_id INT(11) DEFAULT NULL AFTER kilometrage;

-- Si ligne_affectee contient des IDs numériques comme '8', '14', etc.
UPDATE bus SET trajet_id = CAST(ligne_affectee AS UNSIGNED) WHERE ligne_affectee REGEXP '^[0-9]+$';

-- Supprimer l'ancienne colonne après vérification
-- ALTER TABLE bus DROP COLUMN ligne_affectee;
```

### 🔧 Étape 2: Mettre à jour l'endpoint `/bus/numero/:numero`

**Avant:**
```javascript
router.get('/bus/numero/:numero', async (req, res) => {
  const { numero } = req.params;
  
  const [rows] = await pool.query(`
    SELECT 
      id, numero, immatriculation, marque, modele, annee, capacite,
      kilometrage, ligne_affectee, statut, modules, notes,
      derniere_activite, latitude, longitude, date_creation
    FROM bus
    WHERE numero = ?
  `, [numero]);
  
  // ...
});
```

**Après:**
```javascript
router.get('/bus/numero/:numero', async (req, res) => {
  const { numero } = req.params;
  
  const [rows] = await pool.query(`
    SELECT 
      b.id, b.numero, b.immatriculation, b.marque, b.modele, b.annee, 
      b.capacite, b.kilometrage, 
      b.trajet_id,                -- ← CHANGEMENT ICI
      b.statut, b.modules, b.notes,
      b.derniere_activite, b.latitude, b.longitude, b.date_creation,
      t.nom AS nom_ligne           -- ← Récupérer le nom du trajet
    FROM bus b
    LEFT JOIN trajets t ON b.trajet_id = t.id
    WHERE b.numero = ?
  `, [numero]);
  
  // ...
});
```

### 🔧 Étape 3: Mettre à jour tous les autres endpoints

Recherchez dans votre code backend:
- `ligne_affectee` → remplacer par `trajet_id`
- Toute requête `INSERT` ou `UPDATE` sur la table `bus`
- Toute jointure avec la table `trajets`

### 🔧 Étape 4: Vérifier la structure de réponse API

L'application Flutter attend maintenant ce format:

```json
{
  "success": true,
  "data": {
    "id": 1,
    "numero": "421",
    "immatriculation": "KIN-1234-AB",
    "marque": "Mercedes",
    "modele": "Sprinter",
    "annee": 2020,
    "capacite": 50,
    "kilometrage": 125450,
    "trajet_id": 8,              // ← INT, pas STRING
    "nom_ligne": "Kinshasa - Matadi",
    "statut": "actif",
    "modules": "datcha,wifi,pos",
    "notes": "",
    "derniere_activite": "2025-10-22T03:30:00Z",
    "latitude": -4.3309,
    "longitude": 15.2742,
    "date_creation": "2025-10-08T17:23:37Z"
  }
}
```

**⚠️ Points importants:**
- `trajet_id` doit être un **entier** (8) et non une chaîne ("8")
- `nom_ligne` est récupéré depuis la table `trajets` via jointure
- Ne **PAS** inclure `ligne_affectee` dans la réponse

## 🧪 Tests

### Test 1: Vérifier la structure de la table
```sql
DESCRIBE bus;
-- Doit afficher trajet_id INT(11), pas ligne_affectee VARCHAR
```

### Test 2: Vérifier les données
```sql
SELECT numero, trajet_id, statut 
FROM bus 
LIMIT 5;
-- trajet_id doit contenir des entiers: 1, 8, 14, etc.
```

### Test 3: Tester l'endpoint
```bash
curl http://votre-api.com/bus/numero/421
```

Vérifier que la réponse contient:
- ✅ `"trajet_id": 8` (nombre)
- ✅ `"nom_ligne": "Kinshasa - Matadi"`
- ❌ Pas de `"ligne_affectee"`

### Test 4: Test end-to-end
1. Ouvrir l'app Flutter
2. Se connecter comme chauffeur
3. Aller à "Consulter les arrêts"
4. Vérifier dans les logs:
```
🔍 DEBUG - Bus: 421
🔍 DEBUG - trajetId: 8
🔍 DEBUG - nomLigne: Kinshasa - Matadi
📡 Appel API getArretsLigne avec trajetId=8
```

## 📝 Checklist backend

- [ ] Migration du schéma: `ligne_affectee` → `trajet_id`
- [ ] Migration des données (conversion string → int)
- [ ] Mise à jour de l'endpoint `/bus/numero/:numero`
- [ ] Mise à jour des autres endpoints concernés
- [ ] Tests unitaires mis à jour
- [ ] Vérification de la réponse JSON
- [ ] Test avec l'application Flutter
- [ ] Déploiement en production

## 🆘 En cas de problème

### L'app ne trouve pas les arrêts
**Symptôme**: "Aucune ligne affectée au bus"

**Solution**:
1. Vérifier que l'API retourne `trajet_id` (pas `ligne_affectee`)
2. Vérifier que `trajet_id` est un **nombre** et non une chaîne
3. Logs backend: `console.log('trajet_id:', typeof bus.trajet_id, bus.trajet_id)`

### Erreur de type dans l'API
**Symptôme**: `trajet_id` est retourné comme `"8"` au lieu de `8`

**Solution**: S'assurer que la colonne SQL est `INT(11)` et non `VARCHAR`

## 📚 Documentation mise à jour

- ✅ `FIX_ARRETS_TRAJET_ID.md` - Documentation technique mise à jour
- ✅ `backend_example/bus_endpoint_fix.sql` - Exemples de requêtes SQL
- ✅ Ce fichier - Guide de migration complet

## 🎯 Résumé

| Aspect | Avant | Après |
|--------|-------|-------|
| **Type de données** | String | Int |
| **Nom du champ SQL** | `ligne_affectee` | `trajet_id` |
| **Nom de la propriété Dart** | `ligneAffectee` | `trajetId` |
| **Exemple de valeur** | `"8"` | `8` |
| **Utilisation** | Stockait un numéro/nom de ligne | Référence directe vers `trajets.id` |

---

**Date de migration**: 22 octobre 2025  
**Version de l'app**: Compatible après build runner  
**Impact**: Rétrocompatibilité rompue - backend doit être mis à jour
