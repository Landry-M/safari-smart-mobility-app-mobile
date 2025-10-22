# Modal de Déconnexion de l'Équipe de Bord - Avertissement de Suppression

## 🎯 Objectif
Ajouter un message d'avertissement clair dans la modal de déconnexion pour informer l'utilisateur que **toutes les données stockées localement seront supprimées**.

---

## ✅ Modification Effectuée

### **Fichier modifié**: `lib/screens/driver/home_driver_screen.dart`

**Méthode modifiée**: `_handleLogout()` - Ligne 450

---

## 🎨 Nouvelle Interface

### **Avant**
```
┌─────────────────────────────┐
│ Déconnexion                 │
├─────────────────────────────┤
│ Voulez-vous vraiment        │
│ déconnecter toute l'équipe ?│
│                             │
│ [Annuler] [Déconnexion]     │
└─────────────────────────────┘
```

### **Après**
```
┌──────────────────────────────────────┐
│ ⚠️  Déconnexion                      │
├──────────────────────────────────────┤
│ Voulez-vous vraiment déconnecter     │
│ toute l'équipe ?                     │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ 🗑️  Toutes les données stockées  │ │
│ │     localement seront supprimées.│ │
│ └──────────────────────────────────┘ │
│                                      │
│      [Annuler]    [Déconnexion]     │
└──────────────────────────────────────┘
```

---

## 📋 Détails de l'Implémentation

### **1. Icône d'Avertissement dans le Titre**
```dart
title: Row(
  children: [
    Icon(
      Icons.warning_amber_rounded,
      color: AppColors.warning,
      size: 28,
    ),
    const SizedBox(width: 12),
    const Text('Déconnexion'),
  ],
),
```

### **2. Message Principal**
```dart
const Text(
  'Voulez-vous vraiment déconnecter toute l\'équipe ?',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
),
```

### **3. Encadré d'Avertissement**
```dart
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: AppColors.error.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: AppColors.error.withOpacity(0.3),
      width: 1,
    ),
  ),
  child: Row(
    children: [
      Icon(
        Icons.delete_forever,
        color: AppColors.error,
        size: 20,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          'Toutes les données stockées localement seront supprimées.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.error,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  ),
)
```

---

## 🎨 Éléments Visuels

### **Couleurs**
- **Icône d'avertissement** : `AppColors.warning` (jaune/orange)
- **Fond de l'encadré** : `AppColors.error.withOpacity(0.1)` (rouge transparent)
- **Bordure** : `AppColors.error.withOpacity(0.3)` (rouge semi-transparent)
- **Texte d'avertissement** : `AppColors.error` (rouge)
- **Icône de suppression** : `AppColors.error` (rouge)

### **Icônes**
- **Titre** : `Icons.warning_amber_rounded` (⚠️)
- **Encadré** : `Icons.delete_forever` (🗑️)

### **Typographie**
- **Message principal** : `fontSize: 16`, `fontWeight: w500`
- **Message d'avertissement** : `fontSize: 13`, `fontWeight: w500`

---

## 📊 Données Concernées par la Suppression

Lorsque l'utilisateur confirme la déconnexion, les données suivantes sont supprimées de la base locale **Isar** :

### **1. Sessions**
- ✅ Session active de l'équipe de bord
- ✅ Historique des sessions

### **2. Membres de l'Équipe**
- ✅ Informations du chauffeur
- ✅ Informations du receveur
- ✅ Informations du contrôleur

### **3. Bus**
- ✅ Informations du bus affecté
- ✅ Configuration du bus

### **4. Billets Scannés**
- ✅ Tous les billets scannés pendant la session
- ✅ Historique des scans

### **5. Autres Données Locales**
- ✅ Préférences de session
- ✅ Données temporaires

---

## 🔄 Flux de Déconnexion

```
1. Utilisateur clique sur le bouton de déconnexion (🔓)
   ↓
2. Modal s'affiche avec :
   - Titre avec icône d'avertissement ⚠️
   - Message de confirmation
   - Encadré rouge d'avertissement 🗑️
   ↓
3. Utilisateur a deux choix :
   
   A. Cliquer sur "Annuler"
      → Modal se ferme
      → Aucune action
      → Retour à l'écran d'accueil
   
   B. Cliquer sur "Déconnexion" (rouge)
      → Modal se ferme
      → _equipeBordService.logout()
      → _sessionService.logout()
      → Suppression de toutes les données locales
      → Navigation vers '/login'
```

---

## 🔒 Sécurité & Clarté

### **Pourquoi cet avertissement ?**

1. **Transparence** : L'utilisateur sait exactement ce qui va se passer
2. **Prévention d'erreurs** : Évite les déconnexions accidentelles
3. **Conformité** : Respect des bonnes pratiques UX
4. **Traçabilité** : L'utilisateur est informé que les données seront perdues

### **Ce qui est préservé**

Les données suivantes restent **dans la base MySQL** en ligne :
- ✅ Informations des membres de l'équipe
- ✅ Historique des sessions (avec dates de login/logout)
- ✅ Billets vendus et scannés (avec traçabilité)
- ✅ Transactions effectuées
- ✅ Configuration des bus et trajets

---

## 🧪 Test de la Modal

### **Scénario 1 : Annulation**
1. Cliquer sur le bouton de déconnexion
2. Lire le message d'avertissement
3. Cliquer sur "Annuler"
4. ✅ La modal se ferme, rien n'est supprimé

### **Scénario 2 : Confirmation**
1. Cliquer sur le bouton de déconnexion
2. Lire le message d'avertissement
3. Cliquer sur "Déconnexion"
4. ✅ Déconnexion effective
5. ✅ Redirection vers la page de login
6. ✅ Données locales supprimées

---

## 📱 Responsivité

La modal s'adapte automatiquement :
- **Petits écrans** : Le texte s'ajuste, l'icône reste visible
- **Grands écrans** : Layout optimisé avec espaces confortables
- **Orientation** : Fonctionne en portrait et paysage

---

## 🎉 Résultat Final

✅ **Avertissement clair et visible**  
✅ **Design moderne avec icônes**  
✅ **Couleurs distinctives (rouge pour danger)**  
✅ **Message explicite sur la suppression**  
✅ **Meilleure expérience utilisateur**  
✅ **Prévention des erreurs**

---

## 📝 Notes Techniques

### **Code ajouté**
- Ligne 454-463 : Titre avec icône d'avertissement
- Ligne 465-508 : Contenu restructuré avec encadré d'avertissement
- Ligne 510-524 : Actions (Annuler / Déconnexion)

### **Dépendances**
- `AppColors.warning` : Couleur jaune/orange pour l'avertissement
- `AppColors.error` : Couleur rouge pour le danger
- `Icons.warning_amber_rounded` : Icône d'avertissement
- `Icons.delete_forever` : Icône de suppression

---

L'implémentation est complète et prête à être testée ! 🚀
