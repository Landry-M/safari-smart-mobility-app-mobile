import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/database_service.dart';
import '../../core/services/api_service.dart';
import '../../data/models/scanned_ticket_model.dart';
import '../../data/models/bus_model.dart';

class ScannedTicketsScreen extends StatefulWidget {
  const ScannedTicketsScreen({super.key});

  @override
  State<ScannedTicketsScreen> createState() => _ScannedTicketsScreenState();
}

class _ScannedTicketsScreenState extends State<ScannedTicketsScreen> {
  final DatabaseService _dbService = DatabaseService();
  final ApiService _apiService = ApiService();
  List<ScannedTicket> _scannedTickets = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  Bus? _currentBus;

  @override
  void initState() {
    super.initState();
    _loadBusAndTickets();
  }

  Future<void> _loadBusAndTickets() async {
    await _loadCurrentBus();
    await _loadScannedTickets();
  }

  Future<void> _loadCurrentBus() async {
    try {
      // Récupérer le bus actuel depuis la base de données locale
      final buses = await _dbService.getAllBus();
      if (buses.isNotEmpty) {
        _currentBus = buses.first;
        print('🚌 Bus actuel: ${_currentBus?.numero} (MySQL ID: ${_currentBus?.mysqlId})');
      } else {
        print('⚠️ Aucun bus trouvé dans la base locale');
      }
    } catch (e) {
      print('❌ Erreur lors du chargement du bus: $e');
    }
  }

  Future<void> _loadScannedTickets() async {
    setState(() => _isLoading = true);
    
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final isToday = selectedDay.isAtSameMomentAs(today);
      
      List<ScannedTicket> tickets = [];

      if (isToday) {
        // Pour aujourd'hui, charger depuis Isar (base locale)
        print('📊 Chargement des billets depuis Isar (jour courant)');
        tickets = await _dbService.getScannedTicketsByDate(_selectedDate);
      } else {
        // Pour les autres dates, charger depuis l'API
        if (_currentBus?.mysqlId != null) {
          print('🌐 Chargement des billets depuis l\'API (date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}, bus_id: ${_currentBus!.mysqlId})');
          
          final response = await _apiService.getScannedTicketsByDateAndBus(
            date: _selectedDate,
            busId: _currentBus!.mysqlId!,
          );

          if (response['success'] == true && response['data'] != null) {
            final List<dynamic> ticketsData = response['data'] is List 
                ? response['data'] 
                : [];
            
            tickets = ticketsData.map((json) => ScannedTicket.fromApi(json)).toList();
            print('✅ ${tickets.length} billets récupérés depuis l\'API');
          } else {
            print('⚠️ Aucun billet trouvé dans l\'API: ${response['message'] ?? 'Erreur inconnue'}');
          }
        } else {
          print('⚠️ Impossible de charger les billets: ID MySQL du bus non disponible');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Impossible de charger les billets historiques'),
                backgroundColor: AppColors.warning,
              ),
            );
          }
        }
      }

      setState(() {
        _scannedTickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des billets scannés: $e');
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPurple,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _loadScannedTickets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Billets Scannés',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: AppColors.textPrimary),
            onPressed: _selectDate,
            tooltip: 'Sélectionner une date',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _loadScannedTickets,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          // Date header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_selectedDate),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_scannedTickets.length} billet${_scannedTickets.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: AppColors.primaryPurple,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste des billets scannés
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _scannedTickets.isEmpty
                    ? _buildEmptyState()
                    : _buildTicketsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun billet scanné',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('d MMMM yyyy', 'fr_FR').format(_selectedDate),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scannedTickets.length,
      itemBuilder: (context, index) {
        final ticket = _scannedTickets[index];
        return _buildTicketCard(ticket);
      },
    );
  }

  Widget _buildTicketCard(ScannedTicket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 3,
      shadowColor: AppColors.black.withOpacity(0.08),
      child: InkWell(
        onTap: () => _showTicketDetails(ticket),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec numéro de billet et heure
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.numeroBillet,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm:ss').format(ticket.scannedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${ticket.prixPaye.toStringAsFixed(0)} ${ticket.devise}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Trajet
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${ticket.arretDepart} → ${ticket.arretArrivee}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              // Informations supplémentaires si disponibles
              if (ticket.clientNom != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ticket.clientNom!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],

              if (ticket.scannedBy != null) ... [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Scanné par: ${ticket.scannedBy}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showTicketDetails(ScannedTicket ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.confirmation_number,
                    color: AppColors.success,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Détails du billet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ticket.numeroBillet,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildDetailRow('Trajet', '${ticket.arretDepart} → ${ticket.arretArrivee}'),
            _buildDetailRow('Date de voyage', ticket.dateVoyage),
            if (ticket.heureDepart != null)
              _buildDetailRow('Heure de départ', ticket.heureDepart!),
            _buildDetailRow('Prix payé', '${ticket.prixPaye.toStringAsFixed(0)} ${ticket.devise}'),
            _buildDetailRow('Mode de paiement', ticket.modePaiement),
            if (ticket.clientNom != null)
              _buildDetailRow('Passager', ticket.clientNom!),
            if (ticket.clientTelephone != null)
              _buildDetailRow('Téléphone', ticket.clientTelephone!),
            if (ticket.busImmatriculation != null)
              _buildDetailRow('Bus', ticket.busImmatriculation!),
            _buildDetailRow('Scanné le', DateFormat('dd/MM/yyyy à HH:mm:ss').format(ticket.scannedAt)),
            if (ticket.scannedBy != null)
              _buildDetailRow('Scanné par', ticket.scannedBy!),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
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
}
