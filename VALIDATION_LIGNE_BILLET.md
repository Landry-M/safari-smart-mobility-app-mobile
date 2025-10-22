# Validation de la Ligne du Billet lors du Scan

## 🎯 Objectif
Lors du scan d'un billet, vérifier que le `trajet_id` du billet correspond à la `ligne_affectee` du bus de l'équipe qui scanne. Si les lignes ne correspondent pas, afficher un message d'avertissement clair avec les deux lignes et empêcher la validation.

---

## ✅ Implémentation

### 1. **Backend PHP - Récupération des Données**

#### **Modèle Billet**
**Fichier modifié**: `api/models/Billet.php`

**Méthode modifiée**: `getByQRCodeWithDetails()` - Ligne 225

**Champs ajoutés à la requête SQL**:
```php
t.id AS ligne_billet,           // ID du trajet (ligne du billet)
bus.ligne_affectee AS ligne_bus // ID de la ligne affectée au bus
```

**Requête SQL complète**:
```sql
SELECT 
  b.*,
  c.nom AS client_nom,
  c.prenom AS client_prenom,
  c.telephone AS client_telephone,
  c.email AS client_email,
  t.nom AS trajet_nom,
  t.distance_totale AS trajet_distance,
  t.duree_estimee AS trajet_duree,
  t.id AS ligne_billet,              -- ← NOUVEAU
  bus.numero AS bus_numero,
  bus.immatriculation AS bus_immatriculation,
  bus.marque AS bus_marque,
  bus.modele AS bus_modele,
  bus.ligne_affectee AS ligne_bus    -- ← NOUVEAU
FROM billets b
LEFT JOIN clients c ON b.client_id = c.id
LEFT JOIN trajets t ON b.trajet_id = t.id
LEFT JOIN bus ON b.bus_id = bus.id
WHERE b.qr_code = :qr_code
LIMIT 1
```

---

### 2. **Frontend Flutter - Validation**

#### **A. Services et Champs**
**Fichier modifié**: `lib/screens/scanner/qr_scanner_screen.dart`

**Imports ajoutés**:
```dart
import '../../core/services/database_service.dart';
```

**Nouveaux champs d'état**:
```dart
final DatabaseService _dbService = DatabaseService();
String? _currentBusLigneAffectee;  // Ligne du bus actuel
String? _currentBusLigneName;      // Nom de la ligne du bus actuel
```

#### **B. Chargement de la Ligne du Bus**

**Nouvelle méthode** - Ligne 38:
```dart
/// Charger la ligne du bus de l'équipe actuelle
Future<void> _loadCurrentBusLine() async {
  try {
    final session = await _dbService.getActiveDriverSession();
    if (session != null && session.busNumber != null) {
      final bus = await _dbService.getBusByNumero(session.busNumber!);
      if (bus != null) {
        setState(() {
          _currentBusLigneAffectee = bus.ligneAffectee;
          _currentBusLigneName = bus.nomLigne ?? 'Ligne ${bus.ligneAffectee}';
        });
        print('🚌 Ligne du bus actuel: $_currentBusLigneAffectee ($_currentBusLigneName)');
      }
    }
  } catch (e) {
    print('❌ Erreur lors du chargement de la ligne du bus: $e');
  }
}
```

**Appelée dans initState**:
```dart
@override
void initState() {
  super.initState();
  _initializeScanner();
  _loadCurrentBusLine();  // ← NOUVEAU
}
```

#### **C. Vérification de Concordance**

**Dans la modal de détails** - Ligne 520:
```dart
// Vérifier la concordance des lignes
final ligneBillet = ticketData['ligne_billet']?.toString();
final ligneBus = _currentBusLigneAffectee?.toString();
final bool lignesCorrespondent = ligneBillet == null || 
                                 ligneBus == null || 
                                 ligneBillet == ligneBus;

// Récupérer les noms des trajets pour affichage
final String nomLigneBillet = ticketData['trajet_nom'] ?? 'Ligne inconnue';
```

#### **D. Modification du Header**

**Icône et couleur** - Ligne 550:
```dart
color: (canValidate && lignesCorrespondent)
    ? AppColors.success.withOpacity(0.1)
    : AppColors.error.withOpacity(0.1),
```

**Titre** - Ligne 568:
```dart
Text(
  !lignesCorrespondent
      ? 'Ligne incorrecte'
      : canValidate
          ? 'Billet valide'
          : 'Billet déjà utilisé',
  // ...
)
```

#### **E. Encadré d'Avertissement**

**Affiché si** `!lignesCorrespondent` - Ligne 597:
```dart
if (!lignesCorrespondent) ...[
  Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.error.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColors.error.withOpacity(0.3),
        width: 1.5,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre avec icône
        Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ce billet ne peut pas être validé',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
        
        // Message explicatif
        const SizedBox(height: 12),
        Text(
          'Ce billet appartient à une ligne différente de celle de votre bus.',
          style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
        ),
        
        // Comparaison des lignes
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Ligne du billet
              Row(
                children: [
                  Icon(Icons.confirmation_number, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text('Ligne du billet:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      nomLigneBillet,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Ligne du bus
              Row(
                children: [
                  Icon(Icons.directions_bus, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text('Ligne de votre bus:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentBusLigneName ?? 'Ligne inconnue',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
  const SizedBox(height: 24),
],
```

#### **F. Désactivation du Bouton de Validation**

**Modification de la condition** - Ligne 852:
```dart
onPressed: (canValidate && lignesCorrespondent)  // ← Ajout de && lignesCorrespondent
    ? () => _validateTicket(qrCode, ticketData)
    : null,
```

---

## 🎨 Interface Utilisateur

### **Cas 1: Billet Valide (Même Ligne)**

```
┌──────────────────────────────────────┐
│ ✅ Billet valide                     │
│    BIL-2024-12345                    │
├──────────────────────────────────────┤
│ Informations du passager             │
│ ...                                  │
├──────────────────────────────────────┤
│      [Annuler]  [Valider le billet] │
└──────────────────────────────────────┘
```

### **Cas 2: Ligne Incorrecte**

```
┌──────────────────────────────────────────┐
│ ❌ Ligne incorrecte                      │
│    BIL-2024-12345                        │
├──────────────────────────────────────────┤
│ ┌──────────────────────────────────────┐ │
│ │ ⚠️  Ce billet ne peut pas être validé│ │
│ │                                      │ │
│ │ Ce billet appartient à une ligne     │ │
│ │ différente de celle de votre bus.    │ │
│ │                                      │ │
│ │ ┌──────────────────────────────────┐ │ │
│ │ │ 🎫 Ligne du billet:              │ │ │
│ │ │    KAPELA - NGALIEMA             │ │ │
│ │ │ 🚌 Ligne de votre bus:           │ │ │
│ │ │    BINZA - VICTOIRE              │ │ │
│ │ └──────────────────────────────────┘ │ │
│ └──────────────────────────────────────┘ │
├──────────────────────────────────────────┤
│ Informations du passager                 │
│ ...                                      │
├──────────────────────────────────────────┤
│      [Annuler]  [Valider (désactivé)]   │
└──────────────────────────────────────────┘
```

---

## 🔄 Flux de Fonctionnement

```
1. Scanner scanne un QR code
   ↓
2. Appel API: POST /billets/details
   ↓
3. Backend retourne:
   - ligne_billet (trajet_id)
   - ligne_bus (ligne_affectee du bus)
   - trajet_nom (nom de la ligne du billet)
   ↓
4. Frontend compare:
   ligne_billet == ligne_bus (du bus actuel)
   ↓
5A. Si lignes correspondent:
    ✅ Header vert "Billet valide"
    ✅ Bouton "Valider" activé
   
5B. Si lignes NE correspondent PAS:
    ❌ Header rouge "Ligne incorrecte"
    ❌ Encadré d'avertissement affiché
    ❌ Bouton "Valider" désactivé
```

---

## 📊 Données Comparées

### **Base de Données MySQL**

**Table `billets`**:
- `trajet_id` → ID de la ligne du billet (ex: 7)

**Table `bus`**:
- `ligne_affectee` → ID de la ligne du bus (ex: 7, stocké en VARCHAR)

**Table `trajets`**:
- `id` → ID du trajet/ligne
- `nom` → Nom du trajet (ex: "KAPELA - NGALIEMA")

### **Comparaison**

```
Si billets.trajet_id == bus.ligne_affectee
  → Validation autorisée ✅

Si billets.trajet_id != bus.ligne_affectee
  → Validation bloquée ❌
```

---

## 🎨 Design de l'Avertissement

### **Couleurs**
- **Fond**: `AppColors.error.withOpacity(0.1)` (rouge transparent)
- **Bordure**: `AppColors.error.withOpacity(0.3)` (rouge semi-transparent)
- **Icône warning**: `AppColors.error`
- **Texte principal**: `AppColors.error`
- **Ligne du billet**: `AppColors.textPrimary` (noir)
- **Ligne du bus**: `AppColors.primaryPurple` (violet)

### **Icônes**
- **Avertissement**: `Icons.warning_amber_rounded` (⚠️)
- **Billet**: `Icons.confirmation_number` (🎫)
- **Bus**: `Icons.directions_bus` (🚌)

---

## 🔒 Cas Particuliers

### **Cas 1: Bus sans ligne affectée**
```dart
final bool lignesCorrespondent = ligneBillet == null || 
                                 ligneBus == null ||  // ← Autorise si ligne_bus est null
                                 ligneBillet == ligneBus;
```
→ **Validation autorisée** (pas de restriction)

### **Cas 2: Billet sans trajet_id**
```dart
final ligneBillet = ticketData['ligne_billet']?.toString();
// Si null → lignesCorrespondent = true
```
→ **Validation autorisée** (pas de restriction)

### **Cas 3: Billet déjà utilisé**
- L'avertissement de ligne s'affiche **en priorité** si les lignes ne correspondent pas
- Sinon, l'avertissement "Billet déjà utilisé" s'affiche

---

## 🧪 Tests Recommandés

### **Test 1: Même Ligne**
1. Bus affecté à la ligne 7
2. Scanner un billet de la ligne 7
3. ✅ "Billet valide" + bouton "Valider" actif

### **Test 2: Lignes Différentes**
1. Bus affecté à la ligne 7
2. Scanner un billet de la ligne 3
3. ❌ "Ligne incorrecte" + encadré d'avertissement + bouton désactivé

### **Test 3: Bus sans ligne**
1. Bus sans `ligne_affectee`
2. Scanner n'importe quel billet
3. ✅ Validation autorisée (pas de restriction)

### **Test 4: Billet déjà utilisé + Ligne incorrecte**
1. Scanner un billet déjà utilisé d'une autre ligne
2. ❌ Avertissement de ligne incorrecte affiché en priorité

---

## 📝 Fichiers Modifiés

### Backend (1 fichier)
- ✅ `api/models/Billet.php` - Ajout de `ligne_billet` et `ligne_bus`

### Frontend (1 fichier)
- ✅ `lib/screens/scanner/qr_scanner_screen.dart`:
  - Ajout de `DatabaseService`
  - Ajout de `_loadCurrentBusLine()`
  - Vérification de concordance des lignes
  - Encadré d'avertissement
  - Désactivation du bouton de validation

---

## 🎉 Résultat Final

✅ **Validation de ligne implémentée**  
✅ **Avertissement clair avec comparaison visuelle**  
✅ **Prévention des validations incorrectes**  
✅ **Message explicite pour l'utilisateur**  
✅ **Bouton de validation désactivé automatiquement**  
✅ **Design moderne avec icônes et couleurs**

L'implémentation est complète et prête à être testée ! 🚀
