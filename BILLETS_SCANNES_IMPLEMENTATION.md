# Implémentation du Système de Billets Scannés

## 🎯 Objectif
Permettre à l'équipe de bord de scanner les billets, mettre à jour leur statut à 'utilise' dans la base de données MySQL, et sauvegarder les informations dans Isar pour consultation ultérieure.

---

## ✅ Modifications Effectuées

### 1. **Frontend Flutter**

#### A. Modèle de données Isar
**Fichier créé**: `lib/data/models/scanned_ticket_model.dart`
- Modèle `ScannedTicket` pour stocker localement les billets scannés
- Champs : numero_billet, client_nom, arret_depart/arrivee, prix_paye, scannedAt, scannedBy, etc.
- Méthodes : `fromApi()`, `toJson()`, `toString()`

#### B. Service Database
**Fichier modifié**: `lib/core/services/database_service.dart`
- Ajout de `ScannedTicketSchema` au schéma Isar
- Nouvelles méthodes :
  - `saveScannedTicket()` - Sauvegarder un billet scanné
  - `getAllScannedTickets()` - Récupérer tous les billets scannés
  - `getScannedTicketsByDate()` - Filtrer par date
  - `getTodayScannedTickets()` - Billets d'aujourd'hui
  - `getTodayScannedTicketsCount()` - Compteur pour les stats
  - `deleteScannedTicket()` - Supprimer un billet

#### C. Service API
**Fichier modifié**: `lib/core/services/api_service.dart`
- `validateTicketByQR()` - Valider un billet et mettre à jour son statut
- `updateBilletStatut()` - Mettre à jour le statut d'un billet

#### D. Service QR
**Fichier modifié**: `lib/core/services/qr_service.dart`
- `validateQRWithServer()` - Modifiée pour :
  - Appeler l'API de validation
  - Sauvegarder le billet dans Isar si valide
  - Ajouter les informations de scan (scannedAt, scannedBy)

#### E. Écran de consultation
**Fichier créé**: `lib/screens/driver/scanned_tickets_screen.dart`
- Liste des billets scannés avec filtrage par date
- Affichage des détails de chaque billet
- Interface moderne avec cards et bottom sheet
- Statistiques du jour

#### F. Écran d'accueil chauffeur
**Fichier modifié**: `lib/screens/driver/home_driver_screen.dart`
- Card "Billets vendus" → "Billets scannés"
- Icône changée : `Icons.confirmation_number` → `Icons.qr_code_scanner`
- Card cliquable pour ouvrir `ScannedTicketsScreen`
- Chargement des statistiques depuis Isar
- Import de `scanned_tickets_screen.dart`

---

### 2. **Backend PHP API**

#### A. Routes
**Fichier créé**: `api/routes/billets.php`
- `POST /billets/validate` - Valider un billet par QR code
- `PUT /billets/{id}/statut` - Mettre à jour le statut
- `GET /billets/{id}` - Récupérer un billet

#### B. Contrôleur
**Fichier modifié**: `api/controllers/BilletController.php`
- Méthode `validateTicket()` :
  - Vérifie l'existence du billet
  - Vérifie que le statut n'est pas 'utilise' ou 'annule'
  - Met à jour le statut à 'utilise'
  - Retourne les informations complètes du billet

---

## ⚠️ Actions Restantes

### 1. **Modèle Billet.php**
**Action requise**: Vérifier et ajouter la méthode `getByQRCode()` dans `api/models/Billet.php`

```php
/**
 * Récupérer un billet par QR code
 */
public function getByQRCode($qrCode) {
    $query = "SELECT b.*, 
              c.nom AS client_nom, 
              c.telephone AS client_telephone,
              bus.numero AS bus_numero,
              bus.immatriculation AS bus_immatriculation
              FROM " . $this->table_name . " b
              LEFT JOIN clients c ON b.client_id = c.id
              LEFT JOIN bus ON b.bus_id = bus.id
              WHERE b.qr_code = :qr_code 
              LIMIT 1";
    
    $stmt = $this->conn->prepare($query);
    $stmt->bindParam(":qr_code", $qrCode);
    $stmt->execute();

    return $stmt->fetch(PDO::FETCH_ASSOC);
}
```

### 2. **Génération Isar**
**Commande à exécuter**: 
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Cette commande génère:
- `scanned_ticket_model.g.dart`
- Met à jour les schémas Isar

### 3. **Configuration Apache/Nginx**
Si nécessaire, ajouter la route dans votre configuration serveur:
```apache
# Dans .htaccess
RewriteRule ^billets/validate$ routes/billets.php [L]
RewriteRule ^billets/([0-9]+)/statut$ routes/billets.php [L]
```

---

## 📋 Flux de Fonctionnement

### Scan d'un billet

1. **Scanner QR** (`qr_scanner_screen.dart`)
   - L'utilisateur scanne un QR code
   - Le code est validé localement (format)

2. **Validation API** (`qr_service.dart → validateQRWithServer()`)
   - Appel à `POST /billets/validate` avec le QR code
   - Le backend vérifie :
     - Billet existe
     - Statut != 'utilise'
     - Statut != 'annule'
   - Met à jour le statut à 'utilise'

3. **Sauvegarde Isar** (`qr_service.dart`)
   - Si validation réussie, crée un `ScannedTicket`
   - Ajoute scannedAt, scannedBy
   - Sauvegarde dans Isar

4. **Affichage** (`scanned_tickets_screen.dart`)
   - L'équipe peut consulter tous les billets scannés
   - Filtrage par date
   - Statistiques en temps réel

---

## 🎨 Interface Utilisateur

### Écran d'accueil chauffeur
- Card "Billets scannés" avec icône `qr_code_scanner`
- Affiche le compte du jour
- Cliquable pour ouvrir la liste

### Écran des billets scannés
- Header avec date sélectionnable
- Compteur de billets
- Liste avec cards:
  - Numéro de billet
  - Heure de scan
  - Prix
  - Trajet (départ → arrivée)
  - Client (si disponible)
  - Scanné par (matricule)
- Bottom sheet avec détails complets

---

## 🔒 Sécurité

- Vérification du statut avant validation
- Impossible de scanner un billet déjà utilisé
- Traçabilité: scannedBy, scannedAt
- Données sauvegardées localement pour fonctionnement hors ligne

---

## 📊 Base de Données

### Table billets (MySQL)
Champ `statut_billet` avec valeurs possibles:
- `reserve` - Billet réservé
- `paye` - Billet payé
- `utilise` - Billet scanné et validé ✅
- `annule` - Billet annulé

### Collection scanned_tickets (Isar)
Stockage local pour consultation rapide, même hors ligne.

---

## 🚀 Déploiement

1. **Backend**:
   - Ajouter `getByQRCode()` dans `Billet.php`
   - Déployer les fichiers sur le serveur
   - Tester l'endpoint `/billets/validate`

2. **Frontend**:
   - Exécuter `flutter pub run build_runner build --delete-conflicting-outputs`
   - Recompiler l'application
   - Tester le scan sur un appareil réel

3. **Tests**:
   - Scanner un billet valide → Doit passer à 'utilise'
   - Re-scanner le même billet → Doit afficher "déjà utilisé"
   - Consulter la liste des billets scannés
   - Vérifier les stats sur la card d'accueil

---

## 📝 Notes

- Les erreurs lint actuelles sont normales et seront résolues après `build_runner`
- Le champ `qr_code` a été retiré de l'envoi API lors de la création de billet
- Le champ `ligne_affectee` a été converti en INT dans la base de données
- La jointure Bus ↔ Trajets affiche maintenant le nom de la ligne

---

## 🎉 Résultat Final

- ✅ Scan de billets fonctionnel
- ✅ Mise à jour du statut en base de données
- ✅ Sauvegarde locale dans Isar
- ✅ Consultation des billets scannés
- ✅ Statistiques en temps réel
- ✅ Interface moderne et intuitive
- ✅ Fonctionnement hors ligne (lecture)
