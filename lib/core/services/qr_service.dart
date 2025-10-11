import 'dart:async';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

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
  
  // Validate QR code format
  bool isValidTicketQR(String qrCode) {
    // Basic validation - should be customized based on your QR format
    if (qrCode.isEmpty) return false;
    
    // Example: Check if QR code starts with expected prefix
    // return qrCode.startsWith('SAFARI_TICKET_');
    
    // For now, accept any non-empty string
    return qrCode.length >= 10;
  }
  
  // Parse ticket information from QR code
  Map<String, dynamic>? parseTicketQR(String qrCode) {
    try {
      if (!isValidTicketQR(qrCode)) {
        return null;
      }
      
      // Example parsing logic - customize based on your QR format
      // This is a simple example assuming JSON format
      
      // For demonstration, return basic info
      return {
        'ticketId': qrCode,
        'scannedAt': DateTime.now().toIso8601String(),
        'isValid': true,
      };
      
      // In real implementation, you might:
      // 1. Decode base64 if needed
      // 2. Parse JSON
      // 3. Validate signature/checksum
      // 4. Extract ticket details
      
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
  Future<Map<String, dynamic>?> validateQRWithServer(String qrCode) async {
    try {
      // This would typically make an API call to validate the QR code
      // For now, return mock validation result
      
      final ticketInfo = parseTicketQR(qrCode);
      if (ticketInfo == null) {
        return {
          'isValid': false,
          'error': 'Format de QR code invalide',
        };
      }
      
      // Mock validation logic
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
      
      return {
        'isValid': true,
        'ticketId': ticketInfo['ticketId'],
        'message': 'Billet valide',
        'validatedAt': DateTime.now().toIso8601String(),
      };
      
    } catch (e) {
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
