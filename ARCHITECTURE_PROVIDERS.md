# Architecture avec Providers - Logiques de Validation Centralisées

## 🎯 Objectif
Centraliser toutes les logiques de validation et vérification dans des **Providers** pour:
- Séparer la logique métier de l'UI
- Faciliter la réutilisation du code
- Améliorer la testabilité
- Simplifier la gestion d'état
- Respecter les bonnes pratiques Flutter

---

## 📦 Providers Créés

### 1. **EquipeBordProvider**
**Fichier**: `lib/providers/equipe_bord_provider.dart`

**Responsabilités**:
- ✅ Authentification des membres de l'équipe (chauffeur, receveur, contrôleur)
- ✅ Validation du `bus_affecte` (vérifier que tous sont affectés au même bus)
- ✅ Gestion des étapes d'authentification
- ✅ Synchronisation du bus pour toute l'équipe
- ✅ Sauvegarde de la session complète
- ✅ Déconnexion

**État géré**:
```dart
bool _isLoading;                      // Chargement en cours
int _currentStep;                     // Étape actuelle (0-2)
String? _errorMessage;                // Message d'erreur
Map<String, dynamic>? _chauffeurData; // Données du chauffeur
Map<String, dynamic>? _receveurData;  // Données du receveur
Map<String, dynamic>? _controleurData; // Données du contrôleur
```

**Méthodes principales**:
- `validateAuthenticationStep()` - Valider l'authentification + vérifier le bus
- `nextStep()` - Passer à l'étape suivante
- `syncBusAffecteForTeam()` - Synchroniser le bus
- `saveDriverSession()` - Sauvegarder la session
- `logout()` - Déconnexion
- `reset()` - Réinitialiser

---

### 2. **TicketValidationProvider**
**Fichier**: `lib/providers/ticket_validation_provider.dart`

**Responsabilités**:
- ✅ Chargement des informations du bus actuel
- ✅ Récupération des détails d'un billet
- ✅ Validation de la concordance de ligne (billet vs bus)
- ✅ Validation du format QR code
- ✅ Confirmation de la validation du billet

**État géré**:
```dart
String? _currentBusLigneAffectee;    // Ligne du bus actuel
String? _currentBusLigneName;        // Nom de la ligne du bus
String? _currentBusNumber;           // Numéro du bus
bool _isLoadingTicketDetails;        // Chargement des détails
Map<String, dynamic>? _currentTicketData; // Données du billet
String? _errorMessage;               // Message d'erreur
```

**Méthodes principales**:
- `loadCurrentBusInfo()` - Charger les infos du bus actuel
- `getTicketDetails()` - Récupérer les détails d'un billet
- `validateTicketLine()` - Valider la concordance de ligne
- `validateTicket()` - Validation complète d'un billet
- `confirmTicketValidation()` - Confirmer la validation
- `resetCurrentTicket()` - Réinitialiser le ticket actuel
- `reset()` - Réinitialiser

---

## 🏗️ Architecture Avant/Après

### **AVANT** ❌
```
┌─────────────────────────┐
│  auth_driver_screen     │
│                         │
│  ┌───────────────────┐  │
│  │ Logique métier    │  │
│  │ Validation bus    │  │
│  │ API calls         │  │
│  │ Gestion d'état    │  │
│  │ UI                │  │
│  └───────────────────┘  │
└─────────────────────────┘

Problèmes:
- Logique mélangée avec UI
- Difficile à tester
- Pas réutilisable
- Code dupliqué
```

### **APRÈS** ✅
```
┌─────────────────────────┐
│  auth_driver_screen     │
│                         │
│  ┌───────────────────┐  │
│  │ UI uniquement     │  │
│  │ + Écoute Provider │  │
│  └─────────┬─────────┘  │
└────────────┼────────────┘
             │
             ▼
┌─────────────────────────┐
│  EquipeBordProvider     │
│                         │
│  ┌───────────────────┐  │
│  │ Logique métier    │  │
│  │ Validation bus    │  │
│  │ API calls         │  │
│  │ Gestion d'état    │  │
│  └───────────────────┘  │
└─────────────────────────┘

Avantages:
✅ Séparation des responsabilités
✅ Facilement testable
✅ Réutilisable
✅ Maintenable
```

---

## 🔄 Utilisation des Providers

### **1. Enregistrement dans main.dart**

```dart
import 'providers/equipe_bord_provider.dart';
import 'providers/ticket_validation_provider.dart';

return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => EquipeBordProvider()),
    ChangeNotifierProvider(create: (_) => TicketValidationProvider()),
  ],
  child: MaterialApp.router(...),
);
```

---

### **2. Utilisation dans un Screen**

#### **Exemple: auth_driver_screen.dart**

**AVANT**:
```dart
class _AuthDriverScreenState extends State<AuthDriverScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _chauffeurData;
  
  Future<void> _validateStep() async {
    setState(() => _isLoading = true);
    
    // API call
    final result = await _apiService.authenticateEquipeBord(...);
    
    // Validation du bus
    if (_currentStep > 0) {
      final chauffeurBus = _chauffeurData?['bus_affecte'];
      final membreBus = memberData['bus_affecte'];
      if (chauffeurBus != membreBus) {
        // Afficher erreur
      }
    }
    
    setState(() => _isLoading = false);
  }
}
```

**APRÈS**:
```dart
class _AuthDriverScreenState extends State<AuthDriverScreen> {
  @override
  Widget build(BuildContext context) {
    // Écouter le provider
    final equipeBordProvider = context.watch<EquipeBordProvider>();
    
    return Scaffold(
      body: Column(
        children: [
          // Afficher l'état de chargement
          if (equipeBordProvider.isLoading)
            CircularProgressIndicator(),
            
          // Afficher l'erreur
          if (equipeBordProvider.errorMessage != null)
            Text(equipeBordProvider.errorMessage!),
            
          // Formulaire
          ElevatedButton(
            onPressed: () => _submitForm(equipeBordProvider),
            child: Text('Valider'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _submitForm(EquipeBordProvider provider) async {
    final result = await provider.validateAuthenticationStep(
      matricule: _matriculeController.text,
      pin: _pinController.text,
      poste: 'chauffeur',
      stepIndex: 0,
    );
    
    if (result['success'] == true) {
      provider.nextStep();
    }
  }
}
```

---

### **3. Accéder au Provider**

#### **context.watch** - Écouter les changements
```dart
final provider = context.watch<EquipeBordProvider>();
// Le widget se reconstruit quand le provider change
```

#### **context.read** - Lire sans écouter
```dart
final provider = context.read<EquipeBordProvider>();
// Utiliser dans des callbacks, pas de reconstruction
```

#### **Provider.of**
```dart
final provider = Provider.of<EquipeBordProvider>(context, listen: false);
// Équivalent à context.read
```

---

## 📊 Flux de Données

### **Authentification de l'Équipe**

```
1. UI (Screen)
   └─> Formulaire rempli
   └─> Bouton "Valider" cliqué
       │
       ▼
2. Provider (EquipeBordProvider)
   └─> validateAuthenticationStep()
       ├─> API call (authenticateEquipeBord)
       ├─> Validation bus_affecte
       └─> Stockage des données
       └─> notifyListeners()
       │
       ▼
3. UI (Screen)
   └─> Reconstruit automatiquement
   └─> Affiche le résultat (succès/erreur)
```

### **Validation de Billet**

```
1. UI (Scanner Screen)
   └─> QR Code scanné
       │
       ▼
2. Provider (TicketValidationProvider)
   └─> validateTicket(qrCode)
       ├─> Valider format
       ├─> Récupérer détails (API)
       ├─> Valider ligne
       └─> notifyListeners()
       │
       ▼
3. UI (Modal)
   └─> Affiche les détails
   └─> Affiche erreur si ligne incorrecte
   └─> Active/Désactive bouton "Valider"
```

---

## 🧪 Testabilité

### **Tester un Provider**

```dart
void main() {
  group('EquipeBordProvider', () {
    late EquipeBordProvider provider;

    setUp(() {
      provider = EquipeBordProvider();
    });

    test('validateAuthenticationStep - bus incompatible', () async {
      // Authentifier chauffeur
      await provider.validateAuthenticationStep(
        matricule: 'EMP-001',
        pin: '123456',
        poste: 'chauffeur',
        stepIndex: 0,
      );
      
      // Essayer d'authentifier receveur avec bus différent
      final result = await provider.validateAuthenticationStep(
        matricule: 'EMP-008',
        pin: '123456',
        poste: 'receveur',
        stepIndex: 1,
      );
      
      expect(result['success'], false);
      expect(result['busError'], true);
    });
  });
}
```

---

## 📂 Structure des Fichiers

```
lib/
├── providers/
│   ├── auth_provider.dart                  (Existant)
│   ├── equipe_bord_provider.dart          (NOUVEAU)
│   └── ticket_validation_provider.dart    (NOUVEAU)
│
├── screens/
│   ├── driver/
│   │   ├── auth_driver_screen.dart        (À MIGRER)
│   │   └── home_driver_screen.dart
│   │
│   └── scanner/
│       └── qr_scanner_screen.dart         (À MIGRER)
│
├── core/
│   └── services/
│       ├── api_service.dart
│       ├── database_service.dart
│       └── qr_service.dart
│
└── main.dart                              (MODIFIÉ)
```

---

## 🔄 Migration des Screens

### **Écrans à migrer**:

1. ✅ **auth_driver_screen.dart**
   - Utiliser `EquipeBordProvider`
   - Supprimer la logique de validation locale
   - Simplifier le code

2. ✅ **qr_scanner_screen.dart**
   - Utiliser `TicketValidationProvider`
   - Supprimer `_loadCurrentBusLine()`
   - Simplifier la modal

---

## 🎯 Avantages de cette Architecture

1. **Séparation des Responsabilités**
   - UI = Affichage uniquement
   - Provider = Logique métier
   - Service = Communication API/DB

2. **Testabilité**
   - Tester les providers indépendamment
   - Mocker facilement les dépendances

3. **Réutilisabilité**
   - Utiliser le même provider dans plusieurs écrans
   - Partager l'état entre écrans

4. **Maintenabilité**
   - Code plus lisible
   - Modifications centralisées
   - Moins de duplication

5. **Performance**
   - Reconstructions optimisées
   - État partagé efficacement

---

## 📝 Prochaines Étapes

1. ✅ Créer les providers
2. ✅ Enregistrer dans main.dart
3. ⏳ Migrer auth_driver_screen.dart
4. ⏳ Migrer qr_scanner_screen.dart
5. ⏳ Tester l'ensemble
6. ⏳ Supprimer le code obsolète

---

## 🎉 Résultat Final

✅ **Architecture propre et scalable**  
✅ **Code maintenable et testable**  
✅ **Logique centralisée dans les providers**  
✅ **UI simplifiée et déclarative**  
✅ **Meilleure séparation des responsabilités**

L'architecture est maintenant prête à être utilisée ! 🚀
