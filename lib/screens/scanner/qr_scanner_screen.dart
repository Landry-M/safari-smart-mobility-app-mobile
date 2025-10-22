import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/qr_service.dart';
import '../../core/services/api_service.dart';
import '../../core/services/database_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/equipe_bord_provider.dart';
import '../../data/models/user_model.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController? _controller;
  final QRService _qrService = QRService();
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();
  bool _isProcessing = false;
  bool _flashEnabled = false;
  String? _lastScannedCode;
  int? _currentBusTrajetId;
  String? _currentBusLigneName;
  String? _scannedBy; // Matricule de la personne qui scanne

  @override
  void initState() {
    super.initState();
    _initializeScanner();
    _loadCurrentBusLine();
    _loadScannedBy();
  }

  /// Charger la ligne du bus de l'équipe actuelle
  Future<void> _loadCurrentBusLine() async {
    try {
      final session = await _dbService.getActiveDriverSession();
      if (session != null && session.busNumber != null) {
        final bus = await _dbService.getBusByNumero(session.busNumber!);
        if (bus != null) {
          setState(() {
            _currentBusTrajetId = bus.trajetId;
            _currentBusLigneName = bus.nomLigne ?? 'Ligne ${bus.trajetId}';
          });
          print(
              '🚌 Ligne du bus actuel: $_currentBusTrajetId ($_currentBusLigneName)');
        }
      }
    } catch (e) {
      print('❌ Erreur lors du chargement de la ligne du bus: $e');
    }
  }

  /// Charger le matricule de la personne qui scanne (chauffeur ou receveur ou contrôleur)
  Future<void> _loadScannedBy() async {
    try {
      final provider = Provider.of<EquipeBordProvider>(context, listen: false);
      
      // Priorité: receveur > contrôleur > chauffeur
      if (provider.receveur != null) {
        _scannedBy = provider.receveur!.matricule;
        print('👤 Scanné par (receveur): $_scannedBy');
      } else if (provider.controleur != null) {
        _scannedBy = provider.controleur!.matricule;
        print('👤 Scanné par (contrôleur): $_scannedBy');
      } else if (provider.chauffeur != null) {
        _scannedBy = provider.chauffeur!.matricule;
        print('👤 Scanné par (chauffeur): $_scannedBy');
      }
    } catch (e) {
      print('❌ Erreur lors du chargement du scanneur: $e');
    }
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
            content: Text(
              'Erreur d\'initialisation: $e',
              style: const TextStyle(color: AppColors.white),
            ),
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

      // Récupérer les détails du billet AVANT validation
      await _showTicketConfirmationModal(code);
    } catch (e) {
      _showResultDialog(
        'Erreur',
        'Impossible de récupérer les informations du billet: $e',
        false,
      );
    } finally {
      // Reset processing state after a delay
      Future.delayed(const Duration(seconds: 2), () {
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
          backgroundColor: isValid ? null : AppColors.error,
          title: Row(
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.error,
                color: isValid ? AppColors.success : AppColors.white,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isValid ? null : AppColors.white,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: isValid ? null : AppColors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: isValid ? null : AppColors.white,
                ),
              ),
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
                          onPressed:
                              _isProcessing ? null : _showManualEntryDialog,
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
    return CustomPaint(
      painter: QRScannerOverlayPainter(
        borderColor: AppColors.primaryPurple,
        borderRadius: 16,
        borderLength: 30,
        cutOutSize: 250,
      ),
    );
  }

  void _showManualEntryDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.keyboard,
                        color: AppColors.primaryPurple,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Saisie manuelle',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Description
                Text(
                  'Entrez le numéro du billet manuellement',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                // Champ de saisie avec style personnalisé
                TextField(
                  controller: controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Ex: BT-2025-001234',
                    prefixIcon: const Icon(
                      Icons.confirmation_number,
                      color: AppColors.primaryPurple,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryPurple,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: BorderSide(
                            color: AppColors.grey.withOpacity(0.3),
                            width: 0.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Annuler',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            Navigator.of(context).pop();
                            _handleManualEntry(controller.text.trim());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Valider',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleManualEntry(String code) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Valider le format du code
      if (!_qrService.isValidTicketQR(code)) {
        _showResultDialog(
          'Code invalide',
          'Le code saisi n\'est pas valide.',
          false,
        );
        setState(() => _isProcessing = false);
        return;
      }

      // Afficher le modal de confirmation avec les détails du billet
      // Utilise la même logique que le scan QR
      await _showTicketConfirmationModal(code);
    } catch (e) {
      _showResultDialog(
        'Erreur',
        'Impossible de récupérer les informations du billet: $e',
        false,
      );
    } finally {
      // Reset processing state after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isProcessing = false;
            _lastScannedCode = null;
          });
        }
      });
    }
  }

  Future<void> _showTicketConfirmationModal(String qrCode) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTicketDetailsModal(qrCode),
    );
  }

  Widget _buildTicketDetailsModal(String qrCode) {
    // Extraire le numéro de billet du QR code
    final ticketNumber = _qrService.extractTicketNumber(qrCode);
    print('🎫 QR Code scanné: $qrCode');
    print('🎫 Numéro de billet extrait: $ticketNumber');

    return FutureBuilder<Map<String, dynamic>>(
      future: _apiService.getTicketDetailsByQR(ticketNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                ),
                const SizedBox(height: 24),
                Text(
                  'Récupération des informations...',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!['success'] != true) {
          final error =
              snapshot.data?['message'] ?? 'Erreur lors de la récupération';
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final ticketData = snapshot.data!['data'];
        final canValidate = snapshot.data!['can_validate'] ?? false;

        // Vérifier la concordance des lignes
        final ligneBillet = ticketData['ligne_billet']?.toString();
        final ligneBus = _currentBusTrajetId?.toString();
        final bool lignesCorrespondent =
            ligneBillet == null || ligneBus == null || ligneBillet == ligneBus;

        // Récupérer les noms des trajets pour affichage
        final String nomLigneBillet =
            ticketData['trajet_nom'] ?? 'Ligne inconnue';

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (canValidate && lignesCorrespondent)
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        (canValidate && lignesCorrespondent)
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: (canValidate && lignesCorrespondent)
                            ? AppColors.success
                            : AppColors.error,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            !lignesCorrespondent
                                ? 'Ligne incorrecte'
                                : canValidate
                                    ? 'Billet valide'
                                    : 'Billet déjà utilisé',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: (canValidate && lignesCorrespondent)
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          Text(
                            ticketData['numero_billet'] ?? 'N/A',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Avertissement si le billet est déjà utilisé
                if (!canValidate && lignesCorrespondent) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Billet déjà utilisé',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ce billet a déjà été scanné et validé. Il ne peut pas être utilisé à nouveau.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (ticketData['date_scan'] != null ||
                            ticketData['heure_scan'] != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Détails de la validation précédente:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (ticketData['date_scan'] != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Date: ${ticketData['date_scan']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (ticketData['heure_scan'] != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Heure: ${ticketData['heure_scan']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (ticketData['scanned_by'] != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Par: ${ticketData['scanned_by']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Avertissement si les lignes ne correspondent pas
                if (!lignesCorrespondent) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.error,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Ce billet ne peut pas être validé',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ce billet appartient à une ligne différente de celle de votre bus.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.confirmation_number,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ligne du billet:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      nomLigneBillet,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.directions_bus,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ligne de votre bus:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _currentBusLigneName ?? 'Ligne inconnue',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryPurple,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                const Divider(),
                const SizedBox(height: 16),

                // Informations du client
                if (ticketData['client_nom'] != null) ...[
                  Text(
                    'Informations du passager',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.person,
                    'Nom',
                    '${ticketData['client_prenom'] ?? ''} ${ticketData['client_nom']}'
                        .trim(),
                  ),
                  if (ticketData['client_telephone'] != null)
                    _buildDetailRow(
                      Icons.phone,
                      'Téléphone',
                      ticketData['client_telephone'],
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                ],

                // Informations du trajet
                Text(
                  'Informations du trajet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (ticketData['trajet_nom'] != null)
                  _buildDetailRow(
                    Icons.route,
                    'Ligne',
                    ticketData['trajet_nom'],
                  ),
                _buildDetailRow(
                  Icons.location_on,
                  'Départ',
                  ticketData['arret_depart'] ?? 'N/A',
                ),
                _buildDetailRow(
                  Icons.location_on,
                  'Destination',
                  ticketData['arret_arrivee'] ?? 'N/A',
                ),
                _buildDetailRow(
                  Icons.calendar_today,
                  'Date',
                  ticketData['date_voyage'] ?? 'N/A',
                ),
                if (ticketData['heure_depart'] != null)
                  _buildDetailRow(
                    Icons.schedule,
                    'Heure',
                    ticketData['heure_depart'],
                  ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Informations de paiement
                Text(
                  'Informations de paiement',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.attach_money,
                  'Prix',
                  '${ticketData['prix_paye']} ${ticketData['devise'] ?? 'CDF'}',
                ),
                _buildDetailRow(
                  Icons.payment,
                  'Mode',
                  ticketData['mode_paiement'] ?? 'N/A',
                ),
                if (ticketData['reference_paiement'] != null)
                  _buildDetailRow(
                    Icons.receipt,
                    'Référence',
                    ticketData['reference_paiement'],
                  ),

                const SizedBox(height: 24),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          side:
                              const BorderSide(color: AppColors.textSecondary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Annuler',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // N'afficher le bouton Valider que si le billet peut être validé ET que les lignes correspondent
                    if (canValidate && lignesCorrespondent) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => _validateTicket(qrCode, ticketData),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Valider le billet',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateTicket(
      String qrCode, Map<String, dynamic> ticketData) async {
    Navigator.pop(context); // Fermer la modal

    setState(() => _isProcessing = true);

    try {
      // Valider le billet via le service avec le matricule du scanneur
      final validationResult = await _qrService.validateQRWithServer(
        qrCode,
        scannedBy: _scannedBy,
      );

      if (validationResult != null && validationResult['isValid'] == true) {
        // Rafraîchir les statistiques du jour dans le provider
        final equipeBordProvider =
            Provider.of<EquipeBordProvider>(context, listen: false);
        await equipeBordProvider.loadTodayStats();

        _showResultDialog(
          'Billet validé',
          'Le billet a été validé avec succès.',
          true,
        );
      } else {
        _showResultDialog(
          'Erreur',
          validationResult?['error'] ?? 'Impossible de valider le billet.',
          false,
        );
      }
    } catch (e) {
      _showResultDialog(
        'Erreur',
        'Une erreur est survenue lors de la validation: $e',
        false,
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }
}

// Custom overlay painter for QR scanner
class QRScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  QRScannerOverlayPainter({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
