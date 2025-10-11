import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_button.dart';

class TicketConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> ticketData;

  const TicketConfirmationScreen({
    super.key,
    required this.ticketData,
  });

  @override
  Widget build(BuildContext context) {
    // Encoder les données du ticket en JSON pour le QR code
    final qrData = jsonEncode(ticketData);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirmation de commande'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryPurple,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Billet acheté avec succès !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              'Présentez ce QR code au contrôleur',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // QR Code
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250,
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.black,
              ),
            ),

            const SizedBox(height: 32),

            // Ticket Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Récapitulatif de la commande',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Numéro de billet',
                    ticketData['ticketNumber'] ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Ligne',
                    ticketData['route'] ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Type de billet',
                    ticketData['ticketType'] ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Méthode de paiement',
                    ticketData['paymentMethod'] ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Montant payé',
                    ticketData['amount'] ?? 'N/A',
                    isHighlighted: true,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Date d\'achat',
                    ticketData['purchaseDate'] ?? 'N/A',
                  ),
                  if (ticketData['validUntil'] != null) ...[
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Valable jusqu\'au',
                      ticketData['validUntil'] ?? 'N/A',
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Info message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.info.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Conservez ce QR code et présentez-le au contrôleur lors de votre trajet.',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Return to home button
            CustomButton(
              text: 'Retour à l\'accueil',
              icon: Icons.home,
              onPressed: () => context.go('/home'),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.black,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isHighlighted ? AppColors.primaryPurple : AppColors.black,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
