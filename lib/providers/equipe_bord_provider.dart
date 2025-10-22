import 'package:flutter/foundation.dart';
import '../core/services/api_service.dart';
import '../core/services/database_service.dart';
import '../core/services/equipe_bord_service.dart';
import '../core/services/driver_session_service.dart';
import '../data/models/equipe_bord_model.dart';
import '../data/models/driver_session_model.dart';
import '../data/models/bus_model.dart';

/// Provider pour gérer l'authentification et la validation de l'équipe de bord
class EquipeBordProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();
  final EquipeBordService _equipeBordService = EquipeBordService();
  final DriverSessionService _sessionService = DriverSessionService();

  // État de l'authentification
  bool _isLoading = false;
  int _currentStep = 0;
  String? _errorMessage;

  // Données des membres
  Map<String, dynamic>? _chauffeurData;
  Map<String, dynamic>? _receveurData;
  Map<String, dynamic>? _controleurData;

  // Session active
  EquipeBord? _chauffeur;
  EquipeBord? _receveur;
  EquipeBord? _controleur;
  Bus? _bus;

  // Statistiques du jour
  Map<String, dynamic> _todayStats = {
    'trips': 0,
    'passengers': 0,
    'revenue': '0',
    'ticketsSold': 0,
    'ticketsScanned': 0,
  };

  // Getters
  bool get isLoading => _isLoading;
  int get currentStep => _currentStep;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get chauffeurData => _chauffeurData;
  Map<String, dynamic>? get receveurData => _receveurData;
  Map<String, dynamic>? get controleurData => _controleurData;
  
  // Session active getters
  EquipeBord? get chauffeur => _chauffeur;
  EquipeBord? get receveur => _receveur;
  EquipeBord? get controleur => _controleur;
  Bus? get bus => _bus;
  Map<String, dynamic> get todayStats => _todayStats;

  /// Valider l'étape d'authentification
  Future<Map<String, dynamic>> validateAuthenticationStep({
    required String matricule,
    required String pin,
    required String poste,
    required int stepIndex,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Authentifier via l'API
      final result = await _apiService.authenticateEquipeBord(
        matricule: matricule,
        pin: pin,
        poste: poste,
      );

      if (result['success'] == true) {
        final memberData = result['data'];

        // Vérifier la concordance du bus_affecte (sauf pour le chauffeur)
        if (stepIndex > 0) {
          final validationResult = _validateBusAffectation(memberData, poste);
          if (!validationResult['isValid']) {
            _isLoading = false;
            _errorMessage = validationResult['message'];
            notifyListeners();
            return {
              'success': false,
              'message': validationResult['message'],
              'busError': true,
            };
          }
        }

        // Stocker les données du membre
        _storeMemberData(stepIndex, memberData);

        _isLoading = false;
        notifyListeners();

        return {
          'success': true,
          'data': memberData,
        };
      } else {
        _isLoading = false;
        _errorMessage = result['message'] ?? 'Identifiants incorrects';
        notifyListeners();

        return {
          'success': false,
          'message': _errorMessage,
        };
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur de connexion: $e';
      notifyListeners();

      return {
        'success': false,
        'message': _errorMessage,
      };
    }
  }

  /// Valider que le membre est affecté au même bus que le chauffeur
  Map<String, dynamic> _validateBusAffectation(
    Map<String, dynamic> memberData,
    String poste,
  ) {
    final chauffeurBus = _chauffeurData?['bus_affecte'];
    final membreBus = memberData['bus_affecte'];

    if (chauffeurBus != null &&
        membreBus != null &&
        chauffeurBus != membreBus) {
      return {
        'isValid': false,
        'message':
            'Ce $poste est affecté au bus $membreBus alors que le chauffeur est affecté au bus $chauffeurBus. Tous les membres de l\'équipe doivent être affectés au même bus.',
        'chauffeurBus': chauffeurBus,
        'membreBus': membreBus,
      };
    }

    return {'isValid': true};
  }

  /// Stocker les données d'un membre
  void _storeMemberData(int stepIndex, Map<String, dynamic> memberData) {
    switch (stepIndex) {
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
  }

  /// Passer à l'étape suivante
  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Synchroniser le bus_affecte pour toute l'équipe
  Future<Map<String, dynamic>> syncBusAffecteForTeam({
    required String chauffeurMatricule,
    required String receveurMatricule,
    required String controleurMatricule,
  }) async {
    try {
      final busNumber = _chauffeurData?['bus_affecte'];
      if (busNumber == null || busNumber.isEmpty) {
        print('⚠️ Aucun bus affecté au chauffeur');
        return {'success': false, 'message': 'Aucun bus affecté au chauffeur'};
      }

      print('🔄 Synchronisation du bus $busNumber pour toute l\'équipe...');

      final result = await _apiService.syncBusAffecteEquipe(
        chauffeurMatricule: chauffeurMatricule,
        receveurMatricule: receveurMatricule,
        controleurMatricule: controleurMatricule,
        busNumero: busNumber,
      );

      if (result['success'] == true) {
        print('✅ Bus synchronisé avec succès pour tous les membres');
        
        // Mettre à jour les données locales
        if (_receveurData != null) {
          _receveurData!['bus_affecte'] = busNumber;
        }
        if (_controleurData != null) {
          _controleurData!['bus_affecte'] = busNumber;
        }
        notifyListeners();
      }

      return result;
    } catch (e) {
      print('❌ Erreur lors de la synchronisation du bus: $e');
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }

  /// Sauvegarder la session complète localement
  Future<bool> saveDriverSession() async {
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

      // Récupérer et sauvegarder le bus
      final busNumber = _chauffeurData?['bus_affecte'];
      if (busNumber != null && busNumber.isNotEmpty) {
        try {
          final busResult = await _apiService.getBusInfo(busNumber);
          if (busResult['success'] == true && busResult['data'] != null) {
            final bus = Bus.fromApi(busResult['data']);
            await _dbService.saveBus(bus);
            print('✅ Bus sauvegardé: ${bus.immatriculation}');
          }
        } catch (e) {
          print('❌ Erreur lors de la récupération du bus: $e');
        }
      }

      // Créer la session driver
      final driverSession = DriverSession(
        chauffeurMatricule: _chauffeurData?['matricule'] ?? '',
        receveurMatricule: _receveurData?['matricule'] ?? '',
        controleurMatricule: _controleurData?['matricule'] ?? '',
        busNumber: busNumber,
        route: null,
        isActive: true,
      );

      // Sauvegarder dans Isar
      await _dbService.saveCompleteDriverSession(
        chauffeur: chauffeur,
        receveur: receveur,
        controleur: controleur,
        session: driverSession,
      );

      // Sauvegarder dans SharedPreferences
      await _sessionService.saveDriverSession(
        chauffeurMatricule: _chauffeurData?['matricule'] ?? '',
        receveurMatricule: _receveurData?['matricule'] ?? '',
        collecteurMatricule: _controleurData?['matricule'] ?? '',
        busNumber: busNumber ?? '',
      );

      print('✅ Session complète sauvegardée avec succès');
      return true;
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde de la session: $e');
      return false;
    }
  }

  /// Réinitialiser le provider
  void reset() {
    _currentStep = 0;
    _isLoading = false;
    _errorMessage = null;
    _chauffeurData = null;
    _receveurData = null;
    _controleurData = null;
    notifyListeners();
  }

  /// Déconnexion
  Future<void> logout() async {
    await _equipeBordService.logout();
    await _sessionService.logout();
    reset();
  }

  /// Charger la session active
  Future<void> loadActiveSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final sessionData = await _equipeBordService.getActiveSessionWithMembers();

      if (sessionData != null) {
        _chauffeur = sessionData['chauffeur'] as EquipeBord?;
        _receveur = sessionData['receveur'] as EquipeBord?;
        _controleur = sessionData['controleur'] as EquipeBord?;
        _bus = sessionData['bus'] as Bus?;

        print('✅ Session active chargée');
        if (_bus != null) {
          print('🚌 Bus: ${_bus!.numero} - ${_bus!.immatriculation}');
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Erreur chargement session: $e');
      _isLoading = false;
      _errorMessage = 'Erreur lors du chargement de la session';
      notifyListeners();
    }
  }

  /// Charger les statistiques du jour
  Future<void> loadTodayStats() async {
    try {
      final count = await _dbService.getTodayScannedTicketsCount();
      _todayStats['ticketsScanned'] = count;
      notifyListeners();
    } catch (e) {
      print('❌ Erreur chargement statistiques: $e');
    }
  }

  /// Récupérer les arrêts d'une ligne
  Future<Map<String, dynamic>> getArretsLigne(int trajetId) async {
    try {
      return await _apiService.getArretsLigne(trajetId);
    } catch (e) {
      print('❌ Erreur récupération arrêts: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
        'data': [],
      };
    }
  }

  /// Récupérer les billets scannés par date et bus
  Future<Map<String, dynamic>> getScannedTicketsByDateAndBus({
    required DateTime date,
    required int busId,
  }) async {
    try {
      return await _apiService.getScannedTicketsByDateAndBus(
        date: date,
        busId: busId,
      );
    } catch (e) {
      print('❌ Erreur récupération billets: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
        'data': [],
      };
    }
  }
}
