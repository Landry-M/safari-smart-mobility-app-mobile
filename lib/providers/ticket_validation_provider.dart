import 'package:flutter/foundation.dart';
import '../core/services/api_service.dart';
import '../core/services/database_service.dart';
import '../core/services/qr_service.dart';

/// Provider pour gérer la validation des billets lors du scan
class TicketValidationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();
  final QRService _qrService = QRService();

  // Informations du bus actuel
  int? _currentBusTrajetId;
  String? _currentBusLigneName;
  String? _currentBusNumber;

  // État de la validation
  bool _isLoadingTicketDetails = false;
  Map<String, dynamic>? _currentTicketData;
  String? _errorMessage;

  // Getters
  int? get currentBusTrajetId => _currentBusTrajetId;
  String? get currentBusLigneName => _currentBusLigneName;
  String? get currentBusNumber => _currentBusNumber;
  bool get isLoadingTicketDetails => _isLoadingTicketDetails;
  Map<String, dynamic>? get currentTicketData => _currentTicketData;
  String? get errorMessage => _errorMessage;

  /// Charger les informations du bus de l'équipe actuelle
  Future<void> loadCurrentBusInfo() async {
    try {
      final session = await _dbService.getActiveDriverSession();
      if (session != null && session.busNumber != null) {
        final bus = await _dbService.getBusByNumero(session.busNumber!);
        if (bus != null) {
          _currentBusTrajetId = bus.trajetId;
          _currentBusLigneName = bus.nomLigne ?? 'Ligne ${bus.trajetId}';
          _currentBusNumber = bus.numero;
          
          print('🚌 Bus actuel chargé: $_currentBusNumber');
          print('   Ligne: $_currentBusTrajetId ($_currentBusLigneName)');
          
          notifyListeners();
        }
      }
    } catch (e) {
      print('❌ Erreur lors du chargement du bus: $e');
    }
  }

  /// Récupérer les détails d'un billet par QR code
  Future<Map<String, dynamic>> getTicketDetails(String qrCode) async {
    _isLoadingTicketDetails = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getTicketDetailsByQR(qrCode);
      
      _isLoadingTicketDetails = false;
      
      if (response['success'] == true) {
        _currentTicketData = response['data'];
        notifyListeners();
        return response;
      } else {
        _errorMessage = response['message'];
        notifyListeners();
        return response;
      }
    } catch (e) {
      _isLoadingTicketDetails = false;
      _errorMessage = 'Erreur: $e';
      notifyListeners();
      
      return {
        'success': false,
        'message': _errorMessage,
      };
    }
  }

  /// Valider la concordance de ligne entre le billet et le bus
  Map<String, dynamic> validateTicketLine(Map<String, dynamic> ticketData) {
    final ligneBillet = ticketData['ligne_billet']?.toString();
    final ligneBus = _currentBusTrajetId?.toString();
    
    // Si une des lignes est null, autoriser
    if (ligneBillet == null || ligneBus == null) {
      return {
        'isValid': true,
        'lignesCorrespondent': true,
      };
    }

    final bool lignesCorrespondent = ligneBillet == ligneBus;

    if (!lignesCorrespondent) {
      final String nomLigneBillet = ticketData['trajet_nom'] ?? 'Ligne inconnue';
      
      return {
        'isValid': false,
        'lignesCorrespondent': false,
        'message':
            'Ce billet appartient à une ligne différente de celle de votre bus.',
        'ligneBillet': ligneBillet,
        'nomLigneBillet': nomLigneBillet,
        'ligneBus': ligneBus,
        'nomLigneBus': _currentBusLigneName ?? 'Ligne inconnue',
      };
    }

    return {
      'isValid': true,
      'lignesCorrespondent': true,
    };
  }

  /// Valider un billet (format et API)
  Future<Map<String, dynamic>> validateTicket(String qrCode) async {
    // 1. Valider le format du QR code
    if (!_qrService.isValidTicketQR(qrCode)) {
      return {
        'success': false,
        'message': 'QR Code invalide',
      };
    }

    // 2. Récupérer les détails du billet
    final detailsResult = await getTicketDetails(qrCode);
    
    if (detailsResult['success'] != true) {
      return detailsResult;
    }

    final ticketData = detailsResult['data'];

    // 3. Vérifier le statut (peut être validé ?)
    final canValidate = detailsResult['can_validate'] ?? false;

    // 4. Vérifier la concordance de ligne
    final lineValidation = validateTicketLine(ticketData);

    return {
      'success': true,
      'data': ticketData,
      'can_validate': canValidate,
      'line_validation': lineValidation,
      'lignesCorrespondent': lineValidation['lignesCorrespondent'],
    };
  }

  /// Confirmer la validation d'un billet
  Future<Map<String, dynamic>> confirmTicketValidation(String qrCode) async {
    try {
      final validationResult = await _qrService.validateQRWithServer(qrCode);
      
      if (validationResult != null && validationResult['isValid'] == true) {
        return {
          'success': true,
          'message': 'Billet validé avec succès',
        };
      } else {
        return {
          'success': false,
          'message': validationResult?['error'] ?? 'Impossible de valider le billet',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Réinitialiser l'état du ticket actuel
  void resetCurrentTicket() {
    _currentTicketData = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Réinitialiser complètement le provider
  void reset() {
    _currentBusTrajetId = null;
    _currentBusLigneName = null;
    _currentBusNumber = null;
    _isLoadingTicketDetails = false;
    _currentTicketData = null;
    _errorMessage = null;
    notifyListeners();
  }
}
