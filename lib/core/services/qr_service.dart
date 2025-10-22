import 'dart:async';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api_service.dart';
import 'database_service.dart';
import '../../data/models/scanned_ticket_model.dart';

class QRService {
  static final QRService _instance = QRService._internal();
  factory QRService() => _instance;
  QRService._internal();
  
  MobileScannerController? _controller;
  StreamController<String>? _scanController;
  
  // Initialize QR scanner
  Future<MobileScannerController> initializeScanner() async {
    // Check and request camera permission
    final hasPermission = await _checkAndRequestCameraPermission();
    if (!hasPermission) {
      throw QRServiceException('Permission de caméra refusée');
    }
    
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    
    return _controller!;
  }
  
  // Start QR scanning
  Stream<String> startScanning() {
    if (_scanController != null && !_scanController!.isClosed) {
      return _scanController!.stream;
    }
    
    _scanController = StreamController<String>.broadcast();
    return _scanController!.stream;
  }
  
  // Handle barcode detection
  void onBarcodeDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        _scanController?.add(code);
        break; // Only process the first valid code
      }
    }
  }
  
  // Stop QR scanning
  void stopScanning() {
    if (_scanController != null && !_scanController!.isClosed) {
      _scanController!.close();
    }
    _scanController = null;
  }
  
  // Toggle flashlight
  Future<void> toggleFlashlight() async {
    if (_controller != null) {
      await _controller!.toggleTorch();
    }
  }
  
  // Switch camera
  Future<void> switchCamera() async {
    if (_controller != null) {
      await _controller!.switchCamera();
    }
  }
  
  // Check if flashlight is available
  Future<bool> isFlashlightAvailable() async {
    if (_controller != null) {
      try {
        // Try to get torch state - if it throws, torch is not available
        await _controller!.toggleTorch();
        await _controller!.toggleTorch(); // Toggle back
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
  
  // Validate QR code format: QR-numero_du_billet-XXXX
  bool isValidTicketQR(String qrCode) {
    if (qrCode.isEmpty) return false;
    
    // Vérifier le format: QR-numero_du_billet-XXXX
    // Exemple: QR-BT-2025-001234-ABC123
    if (qrCode.startsWith('QR-')) {
      final parts = qrCode.split('-');
      // Doit avoir au moins 3 parties: QR, numero_billet, et code
      return parts.length >= 3;
    }
    
    // Accepter aussi les codes sans préfixe QR- pour rétrocompatibilité
    return qrCode.length >= 10;
  }
  
  // Extraire le numéro de billet du QR code
  String extractTicketNumber(String qrCode) {
    // Format attendu: QR-numero_du_billet-XXXX
    // Exemple: QR-BT-2025-001234-ABC123
    
    if (qrCode.startsWith('QR-')) {
      final parts = qrCode.split('-');
      if (parts.length >= 3) {
        // Retirer le premier élément "QR" et le dernier code
        // Reconstituer le numéro de billet (peut contenir des tirets)
        parts.removeAt(0); // Enlever "QR"
        parts.removeLast(); // Enlever le dernier code
        return parts.join('-'); // BT-2025-001234
      }
    }
    
    // Si le format n'est pas reconnu, retourner le code tel quel
    return qrCode;
  }
  
  // Parse ticket information from QR code
  Map<String, dynamic>? parseTicketQR(String qrCode) {
    try {
      if (!isValidTicketQR(qrCode)) {
        return null;
      }
      
      // Extraire le numéro de billet
      final ticketNumber = extractTicketNumber(qrCode);
      
      return {
        'qrCode': qrCode,
        'ticketNumber': ticketNumber,
        'scannedAt': DateTime.now().toIso8601String(),
        'isValid': true,
      };
      
    } catch (e) {
      return null;
    }
  }
  
  // Generate QR code data for ticket
  String generateTicketQR({
    required String ticketId,
    required String userId,
    required DateTime expiresAt,
    Map<String, dynamic>? additionalData,
  }) {
    final data = {
      'ticketId': ticketId,
      'userId': userId,
      'expiresAt': expiresAt.toIso8601String(),
      'generatedAt': DateTime.now().toIso8601String(),
      ...?additionalData,
    };
    
    // In real implementation, you might:
    // 1. Convert to JSON
    // 2. Add signature/checksum for security
    // 3. Encode to base64 if needed
    // 4. Add prefix for identification
    
    // For now, return the ticket ID (simplified)
    return 'SAFARI_TICKET_$ticketId';
  }
  
  // Check camera permission
  Future<bool> _checkAndRequestCameraPermission() async {
    var permission = await Permission.camera.status;
    
    if (permission.isDenied) {
      permission = await Permission.camera.request();
    }
    
    if (permission.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    
    return permission.isGranted;
  }
  
  // Check if camera permission is granted
  Future<bool> hasCameraPermission() async {
    final permission = await Permission.camera.status;
    return permission.isGranted;
  }
  
  // Request camera permission
  Future<bool> requestCameraPermission() async {
    final permission = await Permission.camera.request();
    return permission.isGranted;
  }
  
  // Validate scanned QR against server
  Future<Map<String, dynamic>?> validateQRWithServer(String qrCode, {String? scannedBy}) async {
    try {
      final apiService = ApiService();
      final dbService = DatabaseService();
      
      // Extraire le numéro de billet du QR code
      final ticketNumber = extractTicketNumber(qrCode);
      print('🎫 QR Code: $qrCode');
      print('🎫 Numéro de billet extrait: $ticketNumber');
      
      // Valider le billet via l'API en utilisant le numéro de billet
      final result = await apiService.validateTicketByQR(ticketNumber, scannedBy: scannedBy);
      
      if (result['success'] == true && result['data'] != null) {
        // Le billet est valide, sauvegarder dans Isar
        final ticketData = result['data'];
        final scannedTicket = ScannedTicket.fromApi(ticketData);
        
        // Ajouter les informations de scan
        scannedTicket.scannedAt = DateTime.now();
        scannedTicket.scannedBy = scannedBy;
        scannedTicket.statutBillet = 'utilise';
        
        await dbService.saveScannedTicket(scannedTicket);
        
        print('✅ Billet scanné et sauvegardé: ${scannedTicket.numeroBillet}');
        
        return {
          'isValid': true,
          'ticketId': scannedTicket.numeroBillet,
          'message': 'Billet validé avec succès',
          'data': ticketData,
        };
      } else {
        return {
          'isValid': false,
          'error': result['message'] ?? 'Billet non valide',
        };
      }
    } catch (e) {
      print('❌ Erreur lors de la validation du billet: $e');
      return {
        'isValid': false,
        'error': 'Erreur de validation: $e',
      };
    }
  }
  
  // Get scanner state
  bool get isScanning => _scanController != null && !_scanController!.isClosed;
  
  // Dispose resources
  void dispose() {
    stopScanning();
    _controller?.dispose();
    _controller = null;
  }
}

// Custom exception for QR service errors
class QRServiceException implements Exception {
  final String message;
  
  QRServiceException(this.message);
  
  @override
  String toString() => 'QRServiceException: $message';
}
