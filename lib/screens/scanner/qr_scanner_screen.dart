import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/qr_service.dart';
import '../../providers/auth_provider.dart';
import '../../data/models/user_model.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController? _controller;
  final QRService _qrService = QRService();
  bool _isProcessing = false;
  bool _flashEnabled = false;
  String? _lastScannedCode;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _qrService.dispose();
    super.dispose();
  }

  Future<void> _initializeScanner() async {
    try {
      _controller = await _qrService.initializeScanner();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur d\'initialisation: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleBarcodeDetection(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty || code == _lastScannedCode) return;

    setState(() {
      _isProcessing = true;
      _lastScannedCode = code;
    });

    try {
      // Validate QR code format
      if (!_qrService.isValidTicketQR(code)) {
        _showResultDialog(
          'QR Code invalide',
          'Le code scanné n\'est pas un billet valide.',
          false,
        );
        return;
      }

      // Validate with server
      final validationResult = await _qrService.validateQRWithServer(code);
      
      if (validationResult != null && validationResult['isValid'] == true) {
        _showResultDialog(
          AppStrings.validTicket,
          'Billet validé avec succès.\nID: ${validationResult['ticketId']}',
          true,
        );
      } else {
        _showResultDialog(
          AppStrings.invalidTicket,
          validationResult?['error'] ?? 'Billet non valide ou expiré.',
          false,
        );
      }
    } catch (e) {
      _showResultDialog(
        'Erreur de validation',
        'Impossible de valider le billet: $e',
        false,
      );
    } finally {
      // Reset processing state after a delay
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isProcessing = false;
            _lastScannedCode = null;
          });
        }
      });
    }
  }

  void _showResultDialog(String title, String message, bool isValid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.error,
                color: isValid ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleFlash() async {
    if (_controller != null) {
      await _controller!.toggleTorch();
      setState(() {
        _flashEnabled = !_flashEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text(AppStrings.scanQr),
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryPurple,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              _flashEnabled ? Icons.flash_on : Icons.flash_off,
              color: _flashEnabled ? AppColors.primaryOrange : AppColors.white,
            ),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          return Stack(
            children: [
              // Camera Preview
              if (_controller != null)
                MobileScanner(
                  controller: _controller!,
                  onDetect: _handleBarcodeDetection,
                ),
              
              // Overlay
              _buildScannerOverlay(),
              
              // Bottom Info Panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      // User Role Info
                      if (user?.role == UserRole.controller) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              color: AppColors.primaryPurple,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Mode Contrôleur',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      
                      // Instructions
                      Text(
                        _isProcessing
                            ? 'Validation en cours...'
                            : 'Pointez la caméra vers le QR code du billet',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Processing Indicator
                      if (_isProcessing)
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryPurple,
                          ),
                        ),
                      
                      const SizedBox(height: 16),
                      
                      // Manual Entry Button
                      TextButton.icon(
                        onPressed: _isProcessing ? null : _showManualEntryDialog,
                        icon: const Icon(Icons.keyboard),
                        label: const Text('Saisie manuelle'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Container(
      decoration: ShapeDecoration(
        shape: QRScannerOverlayShape(
          borderColor: AppColors.primaryPurple,
          borderRadius: 16,
          borderLength: 30,
          borderWidth: 4,
          cutOutSize: 250,
        ),
      ),
    );
  }

  void _showManualEntryDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Saisie manuelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Entrez le code du billet manuellement :'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Code du billet',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (controller.text.isNotEmpty) {
                  _handleManualEntry(controller.text);
                }
              },
              child: Text(
                AppStrings.confirm,
                style: TextStyle(color: AppColors.primaryPurple),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleManualEntry(String code) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      if (!_qrService.isValidTicketQR(code)) {
        _showResultDialog(
          'Code invalide',
          'Le code saisi n\'est pas valide.',
          false,
        );
        return;
      }

      final validationResult = await _qrService.validateQRWithServer(code);
      
      if (validationResult != null && validationResult['isValid'] == true) {
        _showResultDialog(
          AppStrings.validTicket,
          'Billet validé avec succès.\nID: ${validationResult['ticketId']}',
          true,
        );
      } else {
        _showResultDialog(
          AppStrings.invalidTicket,
          validationResult?['error'] ?? 'Billet non valide ou expiré.',
          false,
        );
      }
    } catch (e) {
      _showResultDialog(
        'Erreur de validation',
        'Impossible de valider le billet: $e',
        false,
      );
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      });
    }
  }
}

// Custom overlay shape for QR scanner
class QRScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QRScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);
    Path cutOut = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutSize,
            height: cutOutSize,
          ),
          Radius.circular(borderRadius),
        ),
      );
    return Path.combine(PathOperation.difference, path, cutOut);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderHeightSize = height / 2;
    final cutOutWidth = cutOutSize;
    final cutOutHeight = cutOutSize;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final cutOutRect = Rect.fromLTWH(
      rect.left + borderWidthSize - cutOutWidth / 2,
      rect.top + borderHeightSize - cutOutHeight / 2,
      cutOutWidth,
      cutOutHeight,
    );

    canvas.saveLayer(
      rect,
      backgroundPaint,
    );
    canvas.drawRect(rect, backgroundPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();

    // Draw corner borders
    final borderLength = this.borderLength;
    final radius = borderRadius;

    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left, cutOutRect.top + radius + borderLength)
        ..lineTo(cutOutRect.left, cutOutRect.top + radius)
        ..arcToPoint(
          Offset(cutOutRect.left + radius, cutOutRect.top),
          radius: Radius.circular(radius),
        )
        ..lineTo(cutOutRect.left + radius + borderLength, cutOutRect.top),
      borderPaint,
    );

    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.right - radius - borderLength, cutOutRect.top)
        ..lineTo(cutOutRect.right - radius, cutOutRect.top)
        ..arcToPoint(
          Offset(cutOutRect.right, cutOutRect.top + radius),
          radius: Radius.circular(radius),
        )
        ..lineTo(cutOutRect.right, cutOutRect.top + radius + borderLength),
      borderPaint,
    );

    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.right, cutOutRect.bottom - radius - borderLength)
        ..lineTo(cutOutRect.right, cutOutRect.bottom - radius)
        ..arcToPoint(
          Offset(cutOutRect.right - radius, cutOutRect.bottom),
          radius: Radius.circular(radius),
        )
        ..lineTo(cutOutRect.right - radius - borderLength, cutOutRect.bottom),
      borderPaint,
    );

    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left + radius + borderLength, cutOutRect.bottom)
        ..lineTo(cutOutRect.left + radius, cutOutRect.bottom)
        ..arcToPoint(
          Offset(cutOutRect.left, cutOutRect.bottom - radius),
          radius: Radius.circular(radius),
        )
        ..lineTo(cutOutRect.left, cutOutRect.bottom - radius - borderLength),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return QRScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
