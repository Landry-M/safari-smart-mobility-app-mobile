# Modal de Confirmation Avant Validation de Billet

## 🎯 Objectif
Afficher une modal de confirmation avec toutes les informations du billet (récupérées via jointures SQL) avant de permettre à l'équipe de bord de valider le billet. L'utilisateur peut alors choisir de valider ou d'annuler.

---

## ✅ Modifications Effectuées

### 1. **Backend PHP API**

#### A. Modèle Billet
**Fichier modifié**: `api/models/Billet.php`

**Nouvelles méthodes ajoutées**:

1. **`getByQRCode($qrCode)`** - Ligne 209
   - Récupère un billet par QR code (simple, sans jointures)
   - Retourne toutes les colonnes de la table billets

2. **`getByQRCodeWithDetails($qrCode)`** - Ligne 224
   - Récupère un billet avec TOUTES les informations détaillées
   - **Jointures incluses**:
     - `LEFT JOIN clients` → nom, prénom, téléphone, email du client
     - `LEFT JOIN trajets` → nom du trajet, distance, durée estimée
     - `LEFT JOIN bus` → numéro, immatriculation, marque, modèle du bus

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
  bus.numero AS bus_numero,
  bus.immatriculation AS bus_immatriculation,
  bus.marque AS bus_marque,
  bus.modele AS bus_modele
FROM billets b
LEFT JOIN clients c ON b.client_id = c.id
LEFT JOIN trajets t ON b.trajet_id = t.id
LEFT JOIN bus ON b.bus_id = bus.id
WHERE b.qr_code = :qr_code
```

#### B. Contrôleur Billet
**Fichier modifié**: `api/controllers/BilletController.php`

**Nouvelle méthode ajoutée** - Ligne 247:

**`getTicketDetails()`**:
- Endpoint: `POST /billets/details`
- Body: `{ "qr_code": "..." }`
- Récupère les détails d'un billet **SANS le valider**
- Retourne:
  - `success`: true/false
  - `data`: Toutes les informations du billet avec jointures
  - `can_validate`: boolean indiquant si le billet peut être validé (statut != 'utilise' && != 'annule')

#### C. Routes
**Fichier modifié**: `api/routes/billets.php`

**Nouvelle route ajoutée** - Ligne 24:
```php
// POST /billets/details - Récupérer les détails d'un billet par QR code
if ($requestMethod == 'POST' && isset($uri[2]) && $uri[2] == 'details') {
    $billetController->getTicketDetails();
}
```

---

### 2. **Frontend Flutter**

#### A. Service API
**Fichier modifié**: `lib/core/services/api_service.dart`

**Nouvelle méthode ajoutée** - Ligne 839:

**`getTicketDetailsByQR(String qrCode)`**:
- Appelle l'endpoint `POST /billets/details`
- Récupère toutes les informations du billet avec jointures
- Retourne un `Map<String, dynamic>` avec:
  - `success`: true/false
  - `data`: Les données complètes du billet
  - `can_validate`: Si le billet peut être validé
  - `message`: Message d'erreur le cas échéant

#### B. Scanner QR
**Fichier modifié**: `lib/screens/scanner/qr_scanner_screen.dart`

**Modifications principales**:

1. **Imports ajoutés**:
   - `import 'package:intl/intl.dart';`
   - `import '../../core/services/api_service.dart';`

2. **Nouveaux champs d'état**:
   - `final ApiService _apiService = ApiService();`
   - `bool _isLoadingDetails = false;`

3. **Méthode `_handleBarcodeDetection` modifiée** - Ligne 59:
   - Au lieu de valider directement, appelle maintenant `_showTicketConfirmationModal()`
   - Affiche une modal avec les détails avant validation

4. **Nouvelle méthode `_showTicketConfirmationModal()`** - Ligne 399:
   - Affiche une BottomSheet modale
   - Non dismissible (l'utilisateur doit choisir une action)
   - Appelle `_buildTicketDetailsModal()` pour construire l'UI

5. **Nouvelle méthode `_buildTicketDetailsModal()`** - Ligne 412:
   - Utilise un `FutureBuilder` pour afficher un loader pendant la récupération
   - **3 états possibles**:
     - **Loading**: CircularProgressIndicator + texte "Récupération des informations..."
     - **Error**: Icône d'erreur + message + bouton "Fermer"
     - **Success**: Modal complète avec toutes les infos + boutons d'action

6. **Nouvelle méthode `_buildDetailRow()`** - Ligne 719:
   - Widget réutilisable pour afficher une ligne d'information
   - Format: Icône + Label + Valeur

7. **Nouvelle méthode `_validateTicket()`** - Ligne 751:
   - Appelée quand l'utilisateur clique sur "Valider le billet"
   - Ferme la modal
   - Appelle `_qrService.validateQRWithServer()` pour valider
   - Affiche le résultat (succès ou erreur)

---

## 📱 Interface Utilisateur de la Modal

### **État 1: Chargement**
```
┌────────────────────────────────┐
│                                │
│     ⏳ (Loader animé)          │
│                                │
│  Récupération des              │
│  informations...               │
│                                │
└────────────────────────────────┘
```

### **État 2: Erreur**
```
┌────────────────────────────────┐
│                                │
│      ⚠️  (Icône erreur)        │
│                                │
│  Billet non trouvé             │
│                                │
│  [     Fermer     ]            │
│                                │
└────────────────────────────────┘
```

### **État 3: Billet Valide - Modal Complète**
```
┌────────────────────────────────────────┐
│ ✅ Billet valide                       │
│    BIL-2024-12345                      │
├────────────────────────────────────────┤
│ Informations du passager               │
│ 👤 Nom        Jean Dupont              │
│ 📞 Téléphone  +243 XXX XXX XXX         │
├────────────────────────────────────────┤
│ Informations du trajet                 │
│ 🚌 Ligne       KAPELA - NGALIEMA       │
│ 📍 Départ      Kapela                  │
│ 📍 Destination Ngaliema                │
│ 📅 Date        2025-10-22              │
│ ⏰ Heure       08:30                   │
├────────────────────────────────────────┤
│ Informations de paiement               │
│ 💰 Prix        500 CDF                 │
│ 💳 Mode        Mobile Money            │
│ 🧾 Référence   REF-202401234567        │
├────────────────────────────────────────┤
│                                        │
│ [  Annuler  ] [ Valider le billet ]   │
│                                        │
└────────────────────────────────────────┘
```

### **État 4: Billet Déjà Utilisé**
```
┌────────────────────────────────────────┐
│ ❌ Billet déjà utilisé                 │
│    BIL-2024-12345                      │
├────────────────────────────────────────┤
│ ... (mêmes informations) ...          │
├────────────────────────────────────────┤
│                                        │
│ [  Annuler  ] [ Valider (désactivé) ] │
│                                        │
└────────────────────────────────────────┘
```

---

## 🔄 Flux de Fonctionnement

### **Scan d'un Billet**

1. **Scan QR Code**
   - L'équipe scanne un QR code
   - Validation du format (longueur minimale 10 caractères)

2. **Récupération des Détails** (`POST /billets/details`)
   - Affichage immédiat du loader
   - Appel API avec jointures SQL
   - Récupération des informations complètes :
     - Client (nom, prénom, téléphone)
     - Trajet (nom de la ligne)
     - Bus (numéro, immatriculation)
     - Paiement (prix, mode, référence)
   - Vérification du statut (peut valider ou non)

3. **Affichage de la Modal**
   - Si succès : Modal complète avec toutes les infos
   - Si erreur : Modal d'erreur avec bouton "Fermer"
   - Si billet déjà utilisé : Modal avec bouton "Valider" désactivé

4. **Actions Utilisateur**
   - **Bouton "Annuler"** :
     - Ferme la modal
     - Aucune action effectuée
     - Permet de scanner un autre billet
   
   - **Bouton "Valider le billet"** (si `can_validate = true`) :
     - Ferme la modal
     - Appelle `POST /billets/validate`
     - Met à jour le statut à 'utilise' en base MySQL
     - Sauvegarde dans Isar local
     - Affiche un message de confirmation

---

## 🎨 Détails Visuels

### **Couleurs**
- **Billet valide**: 
  - Header vert `AppColors.success`
  - Icône: `Icons.check_circle`
  
- **Billet déjà utilisé**: 
  - Header rouge `AppColors.error`
  - Icône: `Icons.cancel`

- **Erreur**:
  - Icône: `Icons.error_outline`
  - Bouton rouge

### **Boutons**
- **Annuler**:
  - `OutlinedButton`
  - Bordure grise
  - Texte noir
  
- **Valider le billet**:
  - `ElevatedButton`
  - Fond vert si activé
  - Fond gris si désactivé
  - Plus large que le bouton "Annuler" (flex: 2)

### **Sections**
Chaque section est séparée par un `Divider()`:
1. Informations du passager (optionnel si client_nom existe)
2. Informations du trajet
3. Informations de paiement

---

## 🔒 Sécurité & Validation

### **Côté Backend**
- Vérification de l'existence du QR code
- Jointures pour récupérer les vraies valeurs (noms au lieu d'IDs)
- Indication si le billet peut être validé (`can_validate`)
- Pas de modification de la base de données tant que l'utilisateur ne confirme pas

### **Côté Frontend**
- Validation du format QR code
- Gestion des erreurs réseau
- Loader pendant la récupération
- Bouton de validation désactivé si billet déjà utilisé
- Modal non dismissible (l'utilisateur doit choisir)

---

## 📊 Données Affichées

### **Informations Client** (si disponibles)
- Nom complet (prénom + nom)
- Téléphone

### **Informations Trajet**
- **Nom de la ligne** (récupéré via jointure avec `trajets`)
- Arret de départ
- Arret d'arrivée
- Date de voyage
- Heure de départ (optionnel)

### **Informations Paiement**
- Prix payé + devise
- Mode de paiement
- Référence de paiement (optionnel)

### **Autres**
- Numéro du billet
- Statut (affiché visuellement via couleur et icône)

---

## 🚀 Avantages de Cette Approche

1. **Transparence**: L'équipe voit toutes les informations avant validation
2. **Sécurité**: Confirmation explicite requise
3. **Traçabilité**: Affichage des vraies valeurs (noms) au lieu des IDs
4. **UX**: Feedback visuel clair (loader, couleurs, icônes)
5. **Prévention d'erreurs**: Impossible de valider un billet déjà utilisé
6. **Performance**: Les jointures SQL sont faites côté backend
7. **Offline**: Les données récupérées sont sauvegardées dans Isar après validation

---

## 📝 Fichiers Modifiés

### Backend (3 fichiers)
- ✅ `api/models/Billet.php` - Ajout de 2 méthodes
- ✅ `api/controllers/BilletController.php` - Ajout de `getTicketDetails()`
- ✅ `api/routes/billets.php` - Ajout de la route `/billets/details`

### Frontend (2 fichiers)
- ✅ `lib/core/services/api_service.dart` - Ajout de `getTicketDetailsByQR()`
- ✅ `lib/screens/scanner/qr_scanner_screen.dart` - Ajout de la modal complète

---

## 🧪 Tests Recommandés

1. **Scanner un billet valide** → Modal doit s'afficher avec toutes les infos + bouton "Valider" actif
2. **Scanner un billet déjà utilisé** → Modal doit afficher "Billet déjà utilisé" + bouton "Valider" désactivé
3. **Scanner un QR invalide** → Modal d'erreur avec message
4. **Cliquer sur "Annuler"** → Modal se ferme, aucune action
5. **Cliquer sur "Valider"** → Billet validé, modal se ferme, message de succès
6. **Vérifier les jointures** → Les noms de clients, trajets et bus doivent s'afficher au lieu des IDs
7. **Tester sans connexion** → Message d'erreur approprié

---

## 🎉 Résultat Final

✅ **Modal de confirmation implémentée**  
✅ **Jointures SQL pour afficher les vraies valeurs**  
✅ **Loader pendant la récupération**  
✅ **Boutons Valider/Annuler fonctionnels**  
✅ **Gestion des cas d'erreur**  
✅ **Interface moderne et intuitive**  
✅ **Prévention des validations multiples**  
✅ **Toutes les informations affichées avant validation**

L'implémentation est complète et prête à être testée ! 🚀
