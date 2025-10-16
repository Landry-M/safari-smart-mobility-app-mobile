import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/database_service.dart';
import '../../data/models/ticket_model.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> ticketData;

  const SeatSelectionScreen({
    super.key,
    required this.ticketData,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  String? _selectedSeat;
  
  // Configuration du bus : 4 colonnes (A, B, C, D) et 10 rangées
  final List<String> _columns = ['A', 'B', 'C', 'D'];
  final int _rows = 10;
  
  // Sièges occupés (simulés)
  final Set<String> _occupiedSeats = {
    'A3', 'B2', 'B3', 'B6',
    'C1', 'C3', 'C5', 'C7', 'C9',
    'D4', 'D5', 'D7', 'D8', 'D9',
    'A6', 'A10',
  };

  String _getSeatCode(String column, int row) {
    return '$column$row';
  }

  bool _isSeatOccupied(String seatCode) {
    return _occupiedSeats.contains(seatCode);
  }

  bool _isSeatSelected(String seatCode) {
    return _selectedSeat == seatCode;
  }

  void _onSeatTap(String seatCode) {
    if (_isSeatOccupied(seatCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ce siège est déjà occupé'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      if (_selectedSeat == seatCode) {
        _selectedSeat = null; // Déselectionner si on clique à nouveau
      } else {
        _selectedSeat = seatCode;
      }
    });
  }

  Future<void> _confirmSelection() async {
    if (_selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un siège'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      // Mettre à jour le ticket dans la base de données avec le numéro de siège
      final dbService = DatabaseService();
      final ticketNumber = widget.ticketData['ticketNumber'];
      
      // Récupérer le ticket existant
      final tickets = await dbService.getUserTickets(widget.ticketData['userId']);
      final ticket = tickets.firstWhere((t) => t.ticketId == ticketNumber);
      
      // Mettre à jour avec le numéro de siège
      final updatedTicket = ticket.copyWith(seatNumber: _selectedSeat);
      await dbService.saveTicket(updatedTicket);

      // Ajouter le siège aux données du ticket pour l'écran de confirmation
      final updatedTicketData = Map<String, dynamic>.from(widget.ticketData);
      updatedTicketData['seatNumber'] = _selectedSeat;

      // Naviguer vers l'écran de confirmation
      if (mounted) {
        context.go('/ticket-confirmation', extra: updatedTicketData);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection du siège: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildSeat(String column, int row) {
    final seatCode = _getSeatCode(column, row);
    final isOccupied = _isSeatOccupied(seatCode);
    final isSelected = _isSeatSelected(seatCode);

    Color backgroundColor;
    Widget? content;

    if (isSelected) {
      backgroundColor = AppColors.white;
    } else if (isOccupied) {
      backgroundColor = const Color(0xFFFFC7C7); // Rouge clair
      content = Icon(
        Icons.close,
        color: AppColors.error,
        size: 28,
      );
    } else {
      backgroundColor = AppColors.primaryPurple;
    }

    return GestureDetector(
      onTap: () => _onSeatTap(seatCode),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: content,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(
          color: AppColors.primaryPurple,
          label: 'Disponible',
        ),
        _buildLegendItem(
          color: AppColors.white,
          label: 'Choisi',
          hasBorder: true,
        ),
        _buildLegendItem(
          color: const Color(0xFFFFC7C7),
          label: 'Indisponible',
          icon: Icons.close,
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    bool hasBorder = false,
    IconData? icon,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: hasBorder
                ? Border.all(color: AppColors.primaryPurple, width: 2)
                : null,
          ),
          child: icon != null
              ? Icon(icon, color: AppColors.error, size: 20)
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showSeatDetails() {
    if (_selectedSeat == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                const Text(
                  'Détails du siège',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Siège', _selectedSeat!),
            const Divider(height: 24),
            _buildDetailRow('Prix', widget.ticketData['amount'] ?? ''),
            const Divider(height: 24),
            _buildDetailRow('Méthode de paiement', widget.ticketData['paymentMethod'] ?? ''),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmSelection();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirmer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
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
          'Sélectionnez un siège',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Légende
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.white,
              child: _buildLegend(),
            ),

            const SizedBox(height: 20),

            // Grille de sièges
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // En-têtes des colonnes
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _columns.map((column) {
                          return SizedBox(
                            width: 60,
                            child: Text(
                              column,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Rangées de sièges
                    ...List.generate(_rows, (rowIndex) {
                      final row = rowIndex + 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _columns.map((column) {
                            return SizedBox(
                              width: 60,
                              height: 60,
                              child: _buildSeat(column, row),
                            );
                          }).toList(),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bouton de confirmation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    if (_selectedSeat != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Siège sélectionné',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _selectedSeat!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedSeat != null ? _showSeatDetails : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          disabledBackgroundColor: AppColors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _selectedSeat != null
                              ? 'Continuer'
                              : 'Sélectionnez un siège',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
