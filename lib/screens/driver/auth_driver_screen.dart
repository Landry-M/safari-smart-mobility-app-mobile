import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/driver_session_service.dart';
import '../../core/services/api_service.dart';
import '../../core/services/database_service.dart';
import '../../data/models/equipe_bord_model.dart';
import '../../data/models/driver_session_model.dart';
import '../../data/models/bus_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AuthDriverScreen extends StatefulWidget {
  const AuthDriverScreen({super.key});

  @override
  State<AuthDriverScreen> createState() => _AuthDriverScreenState();
}

class _AuthDriverScreenState extends State<AuthDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Contrôleurs pour chaque étape
  final _chauffeurMatriculeController = TextEditingController();
  final _chauffeurPinController = TextEditingController();
  final _receveurMatriculeController = TextEditingController();
  final _receveurPinController = TextEditingController();
  final _controleurMatriculeController = TextEditingController();
  final _controleurPinController = TextEditingController();

  final _apiService = ApiService();
  final _dbService = DatabaseService();

  // Stocker les données des membres authentifiés
  Map<String, dynamic>? _chauffeurData;
  Map<String, dynamic>? _receveurData;
  Map<String, dynamic>? _controleurData;

  bool _isLoading = false;

  @override
  void dispose() {
    _chauffeurMatriculeController.dispose();
    _chauffeurPinController.dispose();
    _receveurMatriculeController.dispose();
    _receveurPinController.dispose();
    _controleurMatriculeController.dispose();
    _controleurPinController.dispose();
    super.dispose();
  }

  Future<void> _validateStep() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String matricule = '';
    String pin = '';
    String poste = '';

    // Déterminer quelle étape nous sommes
    switch (_currentStep) {
      case 0:
        matricule = _chauffeurMatriculeController.text.trim();
        pin = _chauffeurPinController.text.trim();
        poste = 'chauffeur';
        break;
      case 1:
        matricule = _receveurMatriculeController.text.trim();
        pin = _receveurPinController.text.trim();
        poste = 'receveur';
        break;
      case 2:
        matricule = _controleurMatriculeController.text.trim();
        pin = _controleurPinController.text.trim();
        poste = 'controleur';
        break;
    }

    try {
      // Authentifier via l'API
      final result = await _apiService.authenticateEquipeBord(
        matricule: matricule,
        pin: pin,
        poste: poste,
      );

      setState(() => _isLoading = false);

      if (result['success'] == true) {
        // Stocker les données du membre authentifié
        final memberData = result['data'];

        // Vérifier la concordance du bus_affecte
        if (_currentStep > 0) {
          final chauffeurBus = _chauffeurData?['bus_affecte'];
          final membreBus = memberData['bus_affecte'];
          final posteNom = _currentStep == 1 ? 'receveur' : 'contrôleur';

          // Si les bus ne correspondent pas, afficher une erreur
          if (chauffeurBus != null &&
              membreBus != null &&
              chauffeurBus != membreBus) {
            setState(() => _isLoading = false);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: AppColors.white, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Bus incompatible',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ce $posteNom est affecté au bus $membreBus alors que le chauffeur est affecté au bus $chauffeurBus.',
                        style: const TextStyle(color: AppColors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tous les membres de l\'équipe doivent être affectés au même bus.',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 6),
                  action: SnackBarAction(
                    label: 'OK',
                    textColor: AppColors.white,
                    onPressed: () {},
                  ),
                ),
              );
            }
            return;
          }
        }

        switch (_currentStep) {
          case 0:
            _chauffeurData = memberData;
            break;
          case 1:
            _receveurData = memberData;
            break;
          case 2:
            _controleurData = memberData;
            break;
        }

        // Si c'est la dernière étape, synchroniser le bus et sauvegarder en local
        if (_currentStep == 2) {
          // Synchroniser le bus_affecte pour tous les membres de l'équipe
          await _syncBusAffecteForTeam();

          await _saveDriverSessionLocally();

          if (mounted) {
            context.go('/driver-home');
          }
        } else {
          // Sinon, passer à l'étape suivante
          setState(() {
            _currentStep++;
            _formKey.currentState!.reset();
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ?? 'Identifiants incorrects',
                style: const TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur de connexion: $e',
              style: const TextStyle(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Synchroniser le bus_affecte pour tous les membres de l'équipe
  /// S'assure que tous les membres ont le même bus_affecte que le chauffeur
  Future<void> _syncBusAffecteForTeam() async {
    try {
      final busNumber = _chauffeurData?['bus_affecte'];
      if (busNumber == null || busNumber.isEmpty) {
        print('⚠️ Aucun bus affecté au chauffeur');
        return;
      }

      print('🔄 Synchronisation du bus $busNumber pour toute l\'équipe...');

      final result = await _apiService.syncBusAffecteEquipe(
        chauffeurMatricule: _chauffeurMatriculeController.text.trim(),
        receveurMatricule: _receveurMatriculeController.text.trim(),
        controleurMatricule: _controleurMatriculeController.text.trim(),
        busNumero: busNumber,
      );

      if (result['success'] == true) {
        print('✅ Bus synchronisé avec succès pour tous les membres');
        // Mettre à jour les données locales avec le bus synchronisé
        if (_receveurData != null) {
          _receveurData!['bus_affecte'] = busNumber;
        }
        if (_controleurData != null) {
          _controleurData!['bus_affecte'] = busNumber;
        }
      } else {
        print('⚠️ Erreur lors de la synchronisation: ${result['message']}');
        // Continuer quand même, mais afficher un avertissement
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Avertissement: ${result['message']}',
                style: const TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Erreur lors de la synchronisation du bus: $e');
      // Ne pas bloquer la connexion même si la synchronisation échoue
    }
  }

  /// Sauvegarder la session complète de l'équipe en local
  Future<void> _saveDriverSessionLocally() async {
    try {
      // Préparer les membres de l'équipe
      EquipeBord? chauffeur;
      EquipeBord? receveur;
      EquipeBord? controleur;

      if (_chauffeurData != null) {
        chauffeur = EquipeBord.fromApi(_chauffeurData!)
          ..isCurrentSession = true
          ..loginTimestamp = DateTime.now();
      }

      if (_receveurData != null) {
        receveur = EquipeBord.fromApi(_receveurData!)
          ..isCurrentSession = true
          ..loginTimestamp = DateTime.now();
      }

      if (_controleurData != null) {
        controleur = EquipeBord.fromApi(_controleurData!)
          ..isCurrentSession = true
          ..loginTimestamp = DateTime.now();
      }

      // Récupérer et sauvegarder les infos du bus depuis l'API
      final busNumber = _chauffeurData?['bus_affecte'];
      print('🚌 Bus affecté au chauffeur: $busNumber');

      if (busNumber != null && busNumber.isNotEmpty) {
        try {
          // Récupérer les infos complètes du bus depuis l'API
          final busResult = await _apiService.getBusInfo(busNumber);
          print('🚌 Réponse API getBusInfo: $busResult');

          if (busResult['success'] == true && busResult['data'] != null) {
            // Créer et sauvegarder le bus dans Isar
            final busData = busResult['data'];
            print('📊 Données brutes du bus depuis l\'API:');
            print('  - trajet_id: ${busData['trajet_id']}');
            print('  - nom_ligne: ${busData['nom_ligne']}');

            final bus = Bus.fromApi(busData);
            print('📊 Bus créé depuis API:');
            print('  - trajetId: ${bus.trajetId}');
            print('  - nomLigne: ${bus.nomLigne}');

            await _dbService.saveBus(bus);
            print(
                '✅ Bus sauvegardé dans Isar: ${bus.immatriculation} (N° ${bus.numero})');
          } else {
            print('⚠️ Impossible de récupérer les infos du bus depuis l\'API');
          }
        } catch (e) {
          print('❌ Erreur lors de la récupération du bus: $e');
          // Continuer même si le bus n'est pas récupéré
        }
      }

      // Créer la session driver
      final driverSession = DriverSession(
        chauffeurMatricule: _chauffeurMatriculeController.text.trim(),
        receveurMatricule: _receveurMatriculeController.text.trim(),
        controleurMatricule: _controleurMatriculeController.text.trim(),
        busNumber: busNumber,
        route: null,
        isActive: true,
      );

      // Sauvegarder tout de manière atomique
      await _dbService.saveCompleteDriverSession(
        chauffeur: chauffeur,
        receveur: receveur,
        controleur: controleur,
        session: driverSession,
      );

      print('✅ Session complète sauvegardée avec succès');
      if (chauffeur != null) print('  - Chauffeur: ${chauffeur.nom}');
      if (receveur != null) print('  - Receveur: ${receveur.nom}');
      if (controleur != null) print('  - Contrôleur: ${controleur.nom}');

      // 4. Sauvegarder aussi dans SharedPreferences (pour compatibilité)
      final sessionService = DriverSessionService();
      await sessionService.saveDriverSession(
        chauffeurMatricule: _chauffeurMatriculeController.text.trim(),
        receveurMatricule: _receveurMatriculeController.text.trim(),
        collecteurMatricule: _controleurMatriculeController.text.trim(),
        busNumber: _chauffeurData?['bus_affecte'] ?? 'BUS-225',
      );
      print('✅ Session sauvegardée dans SharedPreferences');
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde de la session: $e');
      // Ne pas bloquer la navigation même si la sauvegarde échoue
    }
  }

  Widget _buildStepContent() {
    final stepData = [
      {
        'title': 'Authentification Chauffeur',
        'icon': Icons.person_outline,
        'matriculeController': _chauffeurMatriculeController,
        'pinController': _chauffeurPinController,
        'matriculeHint': 'Ex: EMP-2025-001',
      },
      {
        'title': 'Authentification Receveur',
        'icon': Icons.account_circle_outlined,
        'matriculeController': _receveurMatriculeController,
        'pinController': _receveurPinController,
        'matriculeHint': 'Ex: EMP-2025-008',
      },
      {
        'title': 'Authentification Contrôleur',
        'icon': Icons.badge_outlined,
        'matriculeController': _controleurMatriculeController,
        'pinController': _controleurPinController,
        'matriculeHint': 'Ex: EMP-2025-015',
      },
    ];

    final data = stepData[_currentStep];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icône et titre
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                data['icon'] as IconData,
                size: 64,
                color: AppColors.primaryPurple,
              ),
              const SizedBox(height: 16),
              Text(
                data['title'] as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Étape ${_currentStep + 1} sur 3',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Formulaire
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller:
                    data['matriculeController'] as TextEditingController,
                label: 'Matricule',
                hintText: data['matriculeHint'] as String,
                prefixIcon: Icons.badge,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le matricule';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: data['pinController'] as TextEditingController,
                label: 'Code PIN',
                hintText: '6 chiffres',
                prefixIcon: Icons.lock_outline,
                obscureText: false,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le code PIN';
                  }
                  if (value.length != 6) {
                    return 'Le code PIN doit contenir 6 chiffres';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Bouton de validation
        CustomButton(
          text: _currentStep == 2 ? 'Terminer' : 'Suivant',
          onPressed: _isLoading ? null : _validateStep,
          isLoading: _isLoading,
        ),

        if (_currentStep > 0) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    setState(() {
                      _currentStep--;
                      _formKey.currentState!.reset();
                    });
                  },
            child: const Text(
              'Retour',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Connexion Équipe',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Indicateur de progression
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < 2 ? 8 : 0,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? AppColors.primaryPurple
                            : AppColors.primaryPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Contenu de l'étape
              _buildStepContent(),
            ],
          ),
        ),
      ),
    );
  }
}
