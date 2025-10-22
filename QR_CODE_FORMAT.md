# Format du QR Code des billets

## Format attendu

Le QR code des billets suit le format suivant:
```
QR-numero_du_billet-XXXX
```

### Exemple
```
QR-BT-2025-001234-ABC123
```

Où:
- `QR-` : Préfixe identifiant un QR code de billet
- `BT-2025-001234` : Numéro du billet (peut contenir des tirets)
- `ABC123` : Code de vérification/checksum

## Extraction du numéro de billet

Le système extrait automatiquement le numéro de billet du QR code:

1. **QR Code complet**: `QR-BT-2025-001234-ABC123`
2. **Numéro extrait**: `BT-2025-001234`

### Logique d'extraction
- Retire le préfixe `QR-`
- Retire le dernier segment (code de vérification)
- Conserve tous les segments intermédiaires (le numéro de billet)

## Utilisation dans l'application

### 1. Validation du format
```dart
bool isValidTicketQR(String qrCode) {
  if (qrCode.startsWith('QR-')) {
    final parts = qrCode.split('-');
    return parts.length >= 3;
  }
  return false;
}
```

### 2. Extraction du numéro
```dart
String extractTicketNumber(String qrCode) {
  if (qrCode.startsWith('QR-')) {
    final parts = qrCode.split('-');
    if (parts.length >= 3) {
      parts.removeAt(0); // Enlever "QR"
      parts.removeLast(); // Enlever le code de vérification
      return parts.join('-'); // Retourner le numéro
    }
  }
  return qrCode;
}
```

### 3. Requêtes API

Les endpoints backend reçoivent maintenant le **numéro de billet** au lieu du QR code complet:

#### Récupération des détails

**⚠️ Problème rencontré:** L'endpoint POST `/billets/details` attend tous les champs de création d'un billet au lieu de juste le numéro.

**Solutions implémentées:** L'application essaie maintenant 3 méthodes différentes:

1. **Méthode 1 (Recommandée):** GET avec path parameter
```
GET /billets/details/{numero_billet}
```

2. **Méthode 2:** GET avec query parameter
```
GET /billets/details?numero_billet=BT-2025-001234
```

3. **Méthode 3:** GET direct
```
GET /billets/{numero_billet}
```

#### Validation du billet
```json
POST /billets/validate
{
  "numero_billet": "BT-2025-001234",
  "scanned_by": "matricule_chauffeur"
}
```

## Rétrocompatibilité

Le système accepte aussi les codes sans préfixe `QR-` pour assurer la rétrocompatibilité:
- Si le code ne commence pas par `QR-`, il est utilisé tel quel
- Longueur minimale: 10 caractères

## Modifications apportées

### Fichiers modifiés

1. **`lib/core/services/qr_service.dart`**
   - Ajout de `extractTicketNumber()` pour extraire le numéro
   - Mise à jour de `isValidTicketQR()` pour valider le format
   - Mise à jour de `parseTicketQR()` pour inclure le numéro extrait
   - Modification de `validateQRWithServer()` pour utiliser le numéro extrait

2. **`lib/core/services/api_service.dart`**
   - Modification de `getTicketDetailsByQR()` : paramètre `qr_code` → `numero_billet`
   - Modification de `validateTicketByQR()` : paramètre `qr_code` → `numero_billet`
   - Ajout de logs de débogage pour tracer les appels

3. **`lib/screens/scanner/qr_scanner_screen.dart`**
   - Extraction du numéro de billet avant l'appel API
   - Ajout de logs pour tracer le QR code scanné et le numéro extrait

## Backend - Endpoints à mettre à jour

### ⚠️ `/billets/details` - CORRECTION REQUISE

**Problème actuel:** L'endpoint attend tous les champs comme pour créer un billet:
```json
{
  "numero_billet": "...",
  "arret_depart": "...",
  "arret_arrivee": "...",
  "date_voyage": "...",
  "prix_paye": "..."
}
```

**Correction recommandée:** Créer un endpoint GET qui accepte seulement le numéro:

```javascript
// Option 1: Path parameter (RECOMMANDÉ)
app.get('/billets/details/:numero_billet', async (req, res) => {
  const { numero_billet } = req.params;
  
  try {
    const query = `
      SELECT 
        b.*,
        c.nom as client_nom,
        c.prenom as client_prenom,
        c.telephone as client_telephone,
        t.nom as trajet_nom,
        ad.nom as arret_depart,
        aa.nom as arret_arrivee
      FROM billets b
      LEFT JOIN clients c ON b.client_id = c.id
      LEFT JOIN trajets t ON b.ligne_billet = t.id
      LEFT JOIN arrets ad ON b.arret_depart = ad.id
      LEFT JOIN arrets aa ON b.arret_arrivee = aa.id
      WHERE b.numero_billet = ?
    `;
    
    const [rows] = await db.query(query, [numero_billet]);
    
    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Billet non trouvé'
      });
    }
    
    const billet = rows[0];
    
    res.json({
      success: true,
      can_validate: billet.statut_billet === 'paye',
      data: billet
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Option 2: Query parameter
app.get('/billets/details', async (req, res) => {
  const { numero_billet } = req.query;
  // ... même logique que ci-dessus
});
```

### `/billets/validate`

**Important:** Lors de la validation, mettre à jour **à la fois** `statut_billet` ET `date_utilisation`:

```javascript
app.post('/billets/validate', async (req, res) => {
  const { numero_billet, scanned_by } = req.body;
  
  try {
    // 1. Vérifier si le billet existe et son statut
    const [billets] = await db.query(
      'SELECT * FROM billets WHERE numero_billet = ?',
      [numero_billet]
    );
    
    if (billets.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Billet non trouvé'
      });
    }
    
    const billet = billets[0];
    
    // 2. Vérifier si le billet peut être validé
    if (billet.statut_billet === 'utilise') {
      return res.status(400).json({
        success: false,
        message: 'Billet déjà utilisé',
        data: billet
      });
    }
    
    if (billet.statut_billet !== 'paye') {
      return res.status(400).json({
        success: false,
        message: 'Billet non payé ou invalide',
        data: billet
      });
    }
    
    // 3. Mettre à jour le statut ET la date_utilisation
    const now = new Date();
    await db.query(
      `UPDATE billets 
       SET statut_billet = 'utilise',
           date_utilisation = ?,
           date_scan = CURDATE(),
           heure_scan = CURTIME(),
           scanned_by = ?
       WHERE numero_billet = ?`,
      [now, scanned_by, numero_billet]
    );
    
    // 4. Récupérer le billet mis à jour
    const [updatedBillet] = await db.query(
      'SELECT * FROM billets WHERE numero_billet = ?',
      [numero_billet]
    );
    
    res.json({
      success: true,
      message: 'Billet validé avec succès',
      data: updatedBillet[0]
    });
    
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});
```

### Structure de la table billets

Assurez-vous que votre table contient ces champs:

```sql
ALTER TABLE billets ADD COLUMN IF NOT EXISTS date_utilisation DATETIME NULL;
ALTER TABLE billets ADD COLUMN IF NOT EXISTS date_scan DATE NULL;
ALTER TABLE billets ADD COLUMN IF NOT EXISTS heure_scan TIME NULL;
ALTER TABLE billets ADD COLUMN IF NOT EXISTS scanned_by VARCHAR(100) NULL;
```

## Tests

Pour tester le système:

1. Scanner un QR code au format `QR-BT-2025-001234-ABC123`
2. Vérifier les logs:
   ```
   🎫 QR Code scanné: QR-BT-2025-001234-ABC123
   🎫 Numéro de billet extrait: BT-2025-001234
   🔍 Récupération des détails du billet: BT-2025-001234
   ```
3. Vérifier que l'API reçoit bien le numéro de billet

## Gestion des erreurs

Si le backend renvoie une erreur 400, vérifier:
- Le format du paramètre envoyé (`numero_billet`)
- La requête SQL utilise le bon champ
- Le numéro de billet existe dans la base de données

Les logs détaillés afficheront:
```
❌ Erreur lors de la récupération des détails du billet: [message]
   Status Code: 400
   Response Data: {...}
   Message du backend: [message exact]
```
