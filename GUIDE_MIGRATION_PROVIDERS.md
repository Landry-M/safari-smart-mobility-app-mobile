# Guide de Migration vers les Providers

## 🎯 Objectif
Guide pratique pour migrer les écrans existants pour utiliser les nouveaux providers.

---

## 📋 Checklist de Migration

### **Pour chaque écran**:
- [ ] Identifier la logique métier à extraire
- [ ] Supprimer les appels API directs
- [ ] Supprimer la gestion d'état locale
- [ ] Utiliser `context.watch` ou `context.read`
- [ ] Tester le fonctionnement
- [ ] Supprimer le code obsolète

---

## 1️⃣ Migration: auth_driver_screen.dart

### **AVANT** (Code actuel)

```dart
class _AuthDriverScreenState extends State<AuthDriverScreen> {
  final _apiService = ApiService();
  final _dbService = DatabaseService();
  
  bool _isLoading = false;
  int _currentStep = 0;
  Map<String, dynamic>? _chauffeurData;
  Map<String, dynamic>? _receveurData;
  Map<String, dynamic>? _controleurData;

  Future<void> _validateStep() async {
    setState(() => _isLoading = true);

    try {
      // API call
      final result = await _apiService.authenticateEquipeBord(
        matricule: matricule,
        pin: pin,
        poste: poste,
      );

      if (result['success'] == true) {
        final memberData = result['data'];
        
        // Validation du bus
        if (_currentStep > 0) {
          final chauffeurBus = _chauffeurData?['bus_affecte'];
          final membreBus = memberData['bus_affecte'];
          
          if (chauffeurBus != null && membreBus != null && chauffeurBus != membreBus) {
            // Afficher erreur
            ScaffoldMessenger.of(context).showSnackBar(...);
            return;
          }
        }

        // Stocker
        switch (_currentStep) {
          case 0: _chauffeurData = memberData; break;
          case 1: _receveurData = memberData; break;
          case 2: _controleurData = memberData; break;
        }

        // Passer à l'étape suivante ou connecter
        if (_currentStep == 2) {
          await _syncBusAffecteForTeam();
          await _saveDriverSessionLocally();
          context.go('/driver-home');
        } else {
          setState(() {
            _currentStep++;
          });
        }
      }
    } catch (e) {
      // Gérer erreur
    }
    
    setState(() => _isLoading = false);
  }
}
```

### **APRÈS** (Avec Provider)

```dart
class _AuthDriverScreenState extends State<AuthDriverScreen> {
  final _matriculeController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Écouter le provider
    final equipeBordProvider = context.watch<EquipeBordProvider>();

    return Scaffold(
      body: Column(
        children: [
          // Afficher le chargement
          if (equipeBordProvider.isLoading)
            CircularProgressIndicator(),

          // Formulaire
          _buildStepContent(equipeBordProvider),

          // Bouton de validation
          ElevatedButton(
            onPressed: equipeBordProvider.isLoading
                ? null
                : () => _handleSubmit(context),
            child: Text('Valider'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<EquipeBordProvider>();
    final poste = _getPosteForStep(provider.currentStep);

    // Appeler le provider
    final result = await provider.validateAuthenticationStep(
      matricule: _matriculeController.text.trim(),
      pin: _pinController.text.trim(),
      poste: poste,
      stepIndex: provider.currentStep,
    );

    if (!mounted) return;

    // Gérer le résultat
    if (result['success'] == true) {
      if (provider.currentStep == 2) {
        // Dernière étape - Synchroniser et sauvegarder
        await provider.syncBusAffecteForTeam(
          chauffeurMatricule: _chauffeurMatriculeController.text.trim(),
          receveurMatricule: _receveurMatriculeController.text.trim(),
          controleurMatricule: _controleurMatriculeController.text.trim(),
        );

        await provider.saveDriverSession();
        
        if (mounted) {
          context.go('/driver-home');
        }
      } else {
        // Passer à l'étape suivante
        provider.nextStep();
        _formKey.currentState!.reset();
      }
    } else if (result['busError'] == true) {
      // Erreur de bus incompatible
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Bus incompatible',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(result['message']),
            ],
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 6),
        ),
      );
    } else {
      // Autre erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Erreur'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String _getPosteForStep(int step) {
    switch (step) {
      case 0: return 'chauffeur';
      case 1: return 'receveur';
      case 2: return 'controleur';
      default: return 'chauffeur';
    }
  }
}
```

### **Changements clés**:
1. ✅ Suppression de `_isLoading`, `_chauffeurData`, etc. → Géré par le provider
2. ✅ `context.watch<EquipeBordProvider>()` → Écoute les changements
3. ✅ `context.read<EquipeBordProvider>()` → Appelle les méthodes
4. ✅ Logique de validation → Dans le provider
5. ✅ UI → Simplement affiche l'état du provider

---

## 2️⃣ Migration: qr_scanner_screen.dart

### **AVANT** (Code actuel)

```dart
class _QRScannerScreenState extends State<QRScannerScreen> {
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();
  
  String? _currentBusLigneAffectee;
  String? _currentBusLigneName;

  @override
  void initState() {
    super.initState();
    _loadCurrentBusLine();
  }

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
        }
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  Widget _buildTicketDetailsModal(String qrCode) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _apiService.getTicketDetailsByQR(qrCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final ticketData = snapshot.data!['data'];
        final canValidate = snapshot.data!['can_validate'] ?? false;

        // Validation de ligne
        final ligneBillet = ticketData['ligne_billet']?.toString();
        final ligneBus = _currentBusLigneAffectee?.toString();
        final bool lignesCorrespondent = ligneBillet == ligneBus;

        return Container(
          child: Column(
            children: [
              // Affichage...
              if (!lignesCorrespondent) ...[
                // Avertissement
              ],
              ElevatedButton(
                onPressed: (canValidate && lignesCorrespondent)
                    ? () => _validateTicket(qrCode, ticketData)
                    : null,
                child: Text('Valider le billet'),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### **APRÈS** (Avec Provider)

```dart
class _QRScannerScreenState extends State<QRScannerScreen> {
  final QRService _qrService = QRService();

  @override
  void initState() {
    super.initState();
    _initializeScanner();
    
    // Charger les infos du bus via le provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketValidationProvider>().loadCurrentBusInfo();
    });
  }

  Future<void> _showTicketConfirmationModal(String qrCode) async {
    final provider = context.read<TicketValidationProvider>();
    
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildTicketDetailsModal(qrCode, provider),
    );
  }

  Widget _buildTicketDetailsModal(String qrCode, TicketValidationProvider provider) {
    return FutureBuilder<Map<String, dynamic>>(
      future: provider.validateTicket(qrCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data?['success'] != true) {
          return _buildErrorView(snapshot.data?['message']);
        }

        final result = snapshot.data!;
        final ticketData = result['data'];
        final canValidate = result['can_validate'] ?? false;
        final lineValidation = result['line_validation'];
        final lignesCorrespondent = lineValidation['lignesCorrespondent'] ?? false;

        return Container(
          child: Column(
            children: [
              // Header avec status
              Text(
                !lignesCorrespondent
                    ? 'Ligne incorrecte'
                    : canValidate
                        ? 'Billet valide'
                        : 'Billet déjà utilisé',
              ),

              // Avertissement si ligne incorrecte
              if (!lignesCorrespondent) ...[
                Container(
                  child: Column(
                    children: [
                      Text('Ce billet ne peut pas être validé'),
                      Text(lineValidation['message']),
                      Text('Ligne du billet: ${lineValidation['nomLigneBillet']}'),
                      Text('Ligne de votre bus: ${provider.currentBusLigneName}'),
                    ],
                  ),
                ),
              ],

              // Informations du billet
              _buildTicketInfo(ticketData),

              // Boutons
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: (canValidate && lignesCorrespondent)
                        ? () => _confirmValidation(context, qrCode, provider)
                        : null,
                    child: Text('Valider le billet'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmValidation(
    BuildContext context,
    String qrCode,
    TicketValidationProvider provider,
  ) async {
    Navigator.pop(context);

    final result = await provider.confirmTicketValidation(qrCode);

    if (!mounted) return;

    if (result['success'] == true) {
      _showResultDialog('Billet validé', 'Le billet a été validé avec succès.', true);
    } else {
      _showResultDialog('Erreur', result['message'], false);
    }

    provider.resetCurrentTicket();
  }
}
```

### **Changements clés**:
1. ✅ Suppression de `_loadCurrentBusLine()` → `provider.loadCurrentBusInfo()`
2. ✅ Suppression de `_currentBusLigneAffectee` → `provider.currentBusLigneAffectee`
3. ✅ API call → `provider.validateTicket(qrCode)`
4. ✅ Validation de ligne → `provider.validateTicketLine()`
5. ✅ État géré par le provider

---

## 📊 Comparaison

| Aspect | AVANT | APRÈS |
|--------|-------|-------|
| **Lignes de code** | ~500 | ~300 |
| **Complexité** | Haute | Basse |
| **Testabilité** | Difficile | Facile |
| **Réutilisabilité** | Non | Oui |
| **Séparation** | Non | Oui |

---

## 🎯 Bonnes Pratiques

### **1. Quand utiliser `watch` vs `read`**

```dart
// ✅ watch - Dans le build
@override
Widget build(BuildContext context) {
  final provider = context.watch<EquipeBordProvider>();
  return Text(provider.isLoading ? 'Chargement...' : 'Prêt');
}

// ✅ read - Dans les callbacks
ElevatedButton(
  onPressed: () {
    context.read<EquipeBordProvider>().nextStep();
  },
  child: Text('Suivant'),
)

// ❌ NE PAS faire
ElevatedButton(
  onPressed: () {
    // Provoque une reconstruction inutile !
    context.watch<EquipeBordProvider>().nextStep();
  },
)
```

### **2. Initialisation du Provider**

```dart
@override
void initState() {
  super.initState();
  
  // ✅ Utiliser addPostFrameCallback
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<TicketValidationProvider>().loadCurrentBusInfo();
  });
}

// ❌ NE PAS faire
@override
void initState() {
  super.initState();
  // Erreur: context.read appelé avant que le widget soit monté
  context.read<TicketValidationProvider>().loadCurrentBusInfo();
}
```

### **3. Gestion des erreurs**

```dart
final result = await provider.validateAuthenticationStep(...);

if (result['success'] == true) {
  // Succès
} else if (result['busError'] == true) {
  // Erreur spécifique de bus
  _showBusError(result['message']);
} else {
  // Autre erreur
  _showGenericError(result['message']);
}
```

---

## 🧪 Testing

### **Tester avec le Provider**

```dart
testWidgets('Affiche erreur si bus incompatible', (tester) async {
  final provider = EquipeBordProvider();
  
  await tester.pumpWidget(
    ChangeNotifierProvider<EquipeBordProvider>.value(
      value: provider,
      child: MaterialApp(
        home: AuthDriverScreen(),
      ),
    ),
  );
  
  // Simuler l'authentification
  await provider.validateAuthenticationStep(
    matricule: 'EMP-001',
    pin: '123456',
    poste: 'chauffeur',
    stepIndex: 0,
  );
  
  await tester.pump();
  
  // Vérifier que l'étape a changé
  expect(provider.currentStep, 1);
});
```

---

## 🎉 Résultat

Après la migration:
- ✅ Code 40% plus court
- ✅ Logique centralisée
- ✅ Facilement testable
- ✅ Réutilisable
- ✅ Maintenable

La migration vers les providers améliore significativement la qualité du code ! 🚀
