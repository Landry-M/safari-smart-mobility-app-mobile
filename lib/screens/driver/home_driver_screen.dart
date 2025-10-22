import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/driver_session_service.dart';
import '../../core/services/database_service.dart';
import '../../core/services/api_service.dart';
import '../../core/services/equipe_bord_service.dart';
import '../../data/models/equipe_bord_model.dart';
import '../../data/models/ticket_model.dart';
import '../../data/models/bus_model.dart';
import '../../providers/equipe_bord_provider.dart';
import '../scanner/qr_scanner_screen.dart';
import 'scanned_tickets_screen.dart';

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({super.key});

  @override
  State<HomeDriverScreen> createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final _sessionService = DriverSessionService();
  final _dbService = DatabaseService();
  final _apiService = ApiService();
  final _equipeBordService = EquipeBordService();

  // Informations de l'équipe (chargées depuis la session)
  Map<String, String> _teamInfo = {
    'chauffeur': '',
    'receveur': '',
    'collecteur': '',
    'busNumber': '',
    'route': '',
  };

  // Membres de l'équipe avec détails complets
  EquipeBord? _chauffeur;
  EquipeBord? _receveur;
  EquipeBord? _controleur;

  // Informations du bus
  Bus? _bus;

  // Statistiques du jour (initialisées à 0)
  final Map<String, dynamic> _todayStats = {
    'trips': 0,
    'passengers': 0,
    'revenue': '0',
    'ticketsSold': 0,
    'ticketsScanned': 0,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Charger les données via le provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EquipeBordProvider>(context, listen: false);
      provider.loadActiveSession();
      provider.loadTodayStats();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Rafraîchir les stats quand l'app revient au premier plan
    if (state == AppLifecycleState.resumed) {
      final provider = Provider.of<EquipeBordProvider>(context, listen: false);
      provider.loadTodayStats();
    }
  }

  void _showMemberDetails(EquipeBord membre) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Avatar et nom
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForPoste(membre.poste),
                        size: 40,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      membre.nom,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            _getColorForStatut(membre.statut).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        membre.poste.toUpperCase(),
                        style: TextStyle(
                          color: _getColorForStatut(membre.statut),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Informations détaillées
              _buildDetailRow(
                icon: Icons.badge,
                label: 'Matricule',
                value: membre.matricule,
              ),
              const Divider(height: 32),

              if (membre.telephone != null)
                _buildDetailRow(
                  icon: Icons.phone,
                  label: 'Téléphone',
                  value: membre.telephone!,
                ),
              if (membre.telephone != null) const Divider(height: 32),

              if (membre.email != null)
                _buildDetailRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: membre.email!,
                ),
              if (membre.email != null) const Divider(height: 32),

              if (membre.busAffecte != null)
                _buildDetailRow(
                  icon: Icons.directions_bus,
                  label: 'Bus affecté',
                  value: membre.busAffecte!,
                ),
              if (membre.busAffecte != null) const Divider(height: 32),

              _buildDetailRow(
                icon: Icons.check_circle,
                label: 'Statut',
                value: membre.statut.toUpperCase(),
                valueColor: _getColorForStatut(membre.statut),
              ),

              const SizedBox(height: 24),

              // Bouton fermer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForPoste(String poste) {
    switch (poste.toLowerCase()) {
      case 'chauffeur':
        return Icons.person;
      case 'receveur':
        return Icons.account_circle;
      case 'controleur':
        return Icons.badge;
      default:
        return Icons.person;
    }
  }

  Future<void> _refreshBusData() async {
    try {
      final provider = Provider.of<EquipeBordProvider>(context, listen: false);
      await provider.loadActiveSession();
      await provider.loadTodayStats();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du rafraîchissement: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Color _getColorForStatut(String statut) {
    switch (statut.toLowerCase()) {
      case 'actif':
        return AppColors.success;
      case 'conge':
        return AppColors.warning;
      case 'suspendu':
        return AppColors.error;
      case 'inactif':
        return AppColors.grey;
      default:
        return AppColors.grey;
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Déconnexion'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voulez-vous vraiment déconnecter toute l\'équipe ?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Toutes les données stockées localement seront supprimées.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text(
              'Déconnexion',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _equipeBordService.logout();
      await _sessionService.logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  /// Scanner le QR code d'un billet client
  Future<void> _scanClientQRCode() async {
    try {
      final qrCode = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QRScannerScreen(),
        ),
      );

      if (qrCode != null && mounted) {
        // Rechercher le ticket dans la base locale
        final ticket = await _dbService.getTicketByQRCode(qrCode.toString());

        if (ticket != null) {
          // Afficher le dialog avec les infos du ticket
          _showTicketInfoDialog(ticket);
        } else {
          // Ticket non trouvé
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Billet non trouvé dans la base locale'),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur lors du scan: $e',
              style: const TextStyle(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Afficher le dialog avec les informations du ticket
  void _showTicketInfoDialog(Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.confirmation_number,
                        color: _getStatusColor(ticket.status),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Informations Billet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Badge de statut
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(ticket.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(ticket.status),
                      size: 16,
                      color: _getStatusColor(ticket.status),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusText(ticket.status),
                      style: TextStyle(
                        color: _getStatusColor(ticket.status),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Informations du trajet
              _buildInfoRow(
                  Icons.route, 'Trajet', ticket.routeName ?? 'Non défini'),
              const SizedBox(height: 12),
              _buildInfoRow(
                  Icons.location_on, 'Départ', ticket.origin ?? 'Non défini'),
              const SizedBox(height: 12),
              _buildInfoRow(
                  Icons.flag, 'Arrivée', ticket.destination ?? 'Non défini'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.event_seat, 'Siège',
                  ticket.seatNumber ?? 'Non assigné'),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Informations financières et type
              _buildInfoRow(
                Icons.attach_money,
                'Prix',
                '${ticket.price.toStringAsFixed(0)} ${ticket.currency}',
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.card_membership,
                'Type',
                _getTicketTypeText(ticket.type),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Informations de validation
              if (ticket.validatedAt != null) ...[
                _buildInfoRow(
                  Icons.check_circle,
                  'Validé le',
                  DateFormat('dd/MM/yyyy à HH:mm').format(ticket.validatedAt!),
                ),
                const SizedBox(height: 12),
              ],

              // Date d'expiration
              if (ticket.expiresAt != null) ...[
                _buildInfoRow(
                  Icons.access_time,
                  'Expire le',
                  DateFormat('dd/MM/yyyy à HH:mm').format(ticket.expiresAt!),
                  valueColor: ticket.isExpired
                      ? AppColors.error
                      : AppColors.textPrimary,
                ),
                const SizedBox(height: 12),
              ],

              _buildInfoRow(
                Icons.calendar_today,
                'Créé le',
                DateFormat('dd/MM/yyyy à HH:mm').format(ticket.createdAt),
              ),

              const SizedBox(height: 24),

              // Bouton de validation (si le ticket est actif)
              if (ticket.status == TicketStatus.active && !ticket.isExpired)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _validateTicket(ticket);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon:
                        const Icon(Icons.check_circle, color: AppColors.white),
                    label: const Text(
                      'Valider ce billet',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget pour afficher une ligne d'information
  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Obtenir la couleur selon le statut
  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.active:
        return AppColors.success;
      case TicketStatus.validated:
        return AppColors.info;
      case TicketStatus.expired:
        return AppColors.error;
      case TicketStatus.cancelled:
        return AppColors.error;
      case TicketStatus.pending:
        return AppColors.warning;
      case TicketStatus.refunded:
        return AppColors.grey;
    }
  }

  /// Obtenir l'icône selon le statut
  IconData _getStatusIcon(TicketStatus status) {
    switch (status) {
      case TicketStatus.active:
        return Icons.check_circle;
      case TicketStatus.validated:
        return Icons.verified;
      case TicketStatus.expired:
        return Icons.error;
      case TicketStatus.cancelled:
        return Icons.cancel;
      case TicketStatus.pending:
        return Icons.pending;
      case TicketStatus.refunded:
        return Icons.money_off;
    }
  }

  /// Obtenir le texte selon le statut
  String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.active:
        return 'Actif';
      case TicketStatus.validated:
        return 'Validé';
      case TicketStatus.expired:
        return 'Expiré';
      case TicketStatus.cancelled:
        return 'Annulé';
      case TicketStatus.pending:
        return 'En attente';
      case TicketStatus.refunded:
        return 'Remboursé';
    }
  }

  /// Obtenir le texte selon le type de billet
  String _getTicketTypeText(TicketType type) {
    switch (type) {
      case TicketType.single:
        return 'Billet simple';
      case TicketType.roundTrip:
        return 'Aller-retour';
      case TicketType.daily:
        return 'Pass journalier';
      case TicketType.weekly:
        return 'Pass hebdomadaire';
      case TicketType.monthly:
        return 'Pass mensuel';
    }
  }

  /// Valider un billet
  Future<void> _validateTicket(Ticket ticket) async {
    try {
      // TODO: Implémenter la logique de validation
      // - Mettre à jour le statut du ticket à 'validated'
      // - Enregistrer l'ID du chauffeur/contrôleur
      // - Enregistrer la date/heure de validation

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Billet validé avec succès',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la validation: $e',
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Afficher les arrêts de la ligne
  Future<void> _showArrets() async {
    if (_bus?.trajetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune ligne affectée au bus'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.primaryPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Arrêts de la ligne',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          _bus!.nomLigne ?? 'Ligne ${_bus!.trajetId}',
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
            ),

            const Divider(height: 1),

            // Liste des arrêts
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: () async {
                  // Debug: afficher les informations du bus
                  print('🔍 DEBUG - Bus: ${_bus!.numero}');
                  print('🔍 DEBUG - trajetId: ${_bus!.trajetId}');
                  print('🔍 DEBUG - nomLigne: ${_bus!.nomLigne}');

                  // Utiliser trajetId
                  int? trajetId = _bus!.trajetId;

                  if (trajetId == null) {
                    print('❌ Erreur: Aucun trajetId valide trouvé');
                    return {
                      'success': false,
                      'message':
                          'Aucun identifiant de trajet trouvé pour ce bus',
                      'data': [],
                    };
                  }

                  print('📡 Appel API getArretsLigne avec trajetId=$trajetId');
                  final result = await _apiService.getArretsLigne(trajetId);
                  print('📥 Réponse API: $result');
                  return result;
                }(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryPurple,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erreur de chargement',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final data = snapshot.data!;

                  // Vérifier le succès et la présence de données
                  if (data['success'] != true || data['data'] == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 64,
                            color: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun arrêt trouvé',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Vérifier que data['data'] est bien une List
                  final arretsData = data['data'];
                  if (arretsData is! List) {
                    print(
                        '❌ Erreur: data["data"] n\'est pas une List: ${arretsData.runtimeType}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Format de données invalide',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final arrets = arretsData;

                  // Vérifier que la liste n'est pas vide
                  if (arrets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 64,
                            color: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun arrêt trouvé pour cette ligne',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 16 + MediaQuery.of(context).padding.bottom,
                    ),
                    itemCount: arrets.length,
                    itemBuilder: (context, index) {
                      final arret = arrets[index];
                      final isFirst = index == 0;
                      final isLast = index == arrets.length - 1;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline
                          Column(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isFirst || isLast
                                      ? AppColors.primaryPurple
                                      : AppColors.white,
                                  border: Border.all(
                                    color: AppColors.primaryPurple,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: isFirst
                                    ? const Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: AppColors.white,
                                      )
                                    : isLast
                                        ? const Icon(
                                            Icons.flag,
                                            size: 14,
                                            color: AppColors.white,
                                          )
                                        : null,
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: 50,
                                  color:
                                      AppColors.primaryPurple.withOpacity(0.3),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          // Arrêt info
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: isLast ? 0 : 16,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isFirst || isLast
                                    ? AppColors.primaryPurple.withOpacity(0.1)
                                    : AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isFirst || isLast
                                      ? AppColors.primaryPurple.withOpacity(0.3)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          arret['nom'] ?? 'Arrêt ${index + 1}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (isFirst)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.success,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'Départ',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      if (isLast)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.error,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'Arrivée',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (arret['temps_arret'] != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer_outlined,
                                          size: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Temps d\'arrêt: ${arret['temps_arret']} min',
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
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isClickable = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              if (isClickable)
                Icon(
                  Icons.touch_app,
                  size: 16,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (isClickable)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
            ],
          ),
          if (isClickable) ...[
            const SizedBox(height: 2),
            Text(
              'Appuyez pour consulter',
              style: TextStyle(
                fontSize: 9,
                color: color.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard({
    required String role,
    required String matricule,
    required IconData icon,
    required EquipeBord? membre,
  }) {
    return InkWell(
      onTap: membre != null ? () => _showMemberDetails(membre) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryPurple.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryPurple, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    matricule.isEmpty ? 'Non chargé' : matricule,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (membre != null)
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getColorForStatut(membre.statut).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      membre.statut.toUpperCase(),
                      style: TextStyle(
                        color: _getColorForStatut(membre.statut),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showBusDetailsBottomSheet() {
    if (_bus == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // En-tête avec icône du bus
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        size: 40,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _bus!.immatriculation,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'N° ${_bus!.numero}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            _getBusStatusColor(_bus!.statut).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getBusStatusText(_bus!.statut),
                        style: TextStyle(
                          color: _getBusStatusColor(_bus!.statut),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Informations détaillées
              _buildDetailRow(
                icon: Icons.confirmation_number,
                label: 'Numéro',
                value: _bus!.numero,
              ),
              const Divider(height: 32),

              _buildDetailRow(
                icon: Icons.badge,
                label: 'Immatriculation',
                value: _bus!.immatriculation,
              ),
              const Divider(height: 32),

              if (_bus!.marque != null || _bus!.modele != null)
                _buildDetailRow(
                  icon: Icons.build,
                  label: 'Marque & Modèle',
                  value: '${_bus!.marque ?? 'N/A'} ${_bus!.modele ?? ''}',
                ),
              if (_bus!.marque != null || _bus!.modele != null)
                const Divider(height: 32),

              if (_bus!.annee != null)
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  label: 'Année',
                  value: _bus!.annee.toString(),
                ),
              if (_bus!.annee != null) const Divider(height: 32),

              if (_bus!.capacite != null)
                _buildDetailRow(
                  icon: Icons.event_seat,
                  label: 'Capacité',
                  value: '${_bus!.capacite} places',
                ),
              if (_bus!.capacite != null) const Divider(height: 32),

              if (_bus!.kilometrage != null)
                _buildDetailRow(
                  icon: Icons.speed,
                  label: 'Kilométrage',
                  value: '${_bus!.kilometrage} km',
                ),
              if (_bus!.kilometrage != null) const Divider(height: 32),

              if (_bus!.nomLigne != null || _bus!.trajetId != null)
                _buildDetailRow(
                  icon: Icons.route,
                  label: 'Ligne affectée',
                  value: _bus!.nomLigne ?? 'Ligne ${_bus!.trajetId}',
                ),
              if (_bus!.nomLigne != null || _bus!.trajetId != null)
                const Divider(height: 32),

              // Modules installés
              if (_bus!.modules != null && _bus!.modules!.isNotEmpty) ...[
                const Text(
                  'Modules installés',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _bus!.modules!.split(',').map((module) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryOrange.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        module.trim().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Divider(height: 32),
              ],

              // Notes
              if (_bus!.notes != null && _bus!.notes!.isNotEmpty) ...[
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppColors.info, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _bus!.notes!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 8),

              // Bouton fermer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusInfoCard() {
    if (_bus == null) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryPurple.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: _showBusDetailsBottomSheet,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec icône
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        color: AppColors.primaryPurple,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _bus!.immatriculation,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'N° ${_bus!.numero}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Badge de statut
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            _getBusStatusColor(_bus!.statut).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getBusStatusText(_bus!.statut),
                        style: TextStyle(
                          color: _getBusStatusColor(_bus!.statut),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Informations du véhicule
                Row(
                  children: [
                    Expanded(
                      child: _buildBusInfoItem(
                        icon: Icons.build,
                        label: 'Marque',
                        value: '${_bus!.marque ?? 'N/A'} ${_bus!.modele ?? ''}',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBusInfoItem(
                        icon: Icons.calendar_today,
                        label: 'Année',
                        value: _bus!.annee?.toString() ?? 'N/A',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildBusInfoItem(
                        icon: Icons.event_seat,
                        label: 'Capacité',
                        value: '${_bus!.capacite ?? 0} places',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBusInfoItem(
                        icon: Icons.speed,
                        label: 'Kilométrage',
                        value: '${_bus!.kilometrage ?? 0} km',
                      ),
                    ),
                  ],
                ),

                if (_bus!.modules != null && _bus!.modules!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Modules installés
                  const Text(
                    'Modules installés',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _bus!.modules!.split(',').map((module) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryOrange.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          module.trim().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                if (_bus!.notes != null && _bus!.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.info, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _bus!.notes!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Color _getBusStatusColor(BusStatut statut) {
    switch (statut) {
      case BusStatut.actif:
        return AppColors.success;
      case BusStatut.maintenance:
        return AppColors.warning;
      case BusStatut.panne:
        return AppColors.error;
      case BusStatut.inactif:
        return AppColors.grey;
    }
  }

  String _getBusStatusText(BusStatut statut) {
    switch (statut) {
      case BusStatut.actif:
        return 'ACTIF';
      case BusStatut.maintenance:
        return 'MAINTENANCE';
      case BusStatut.panne:
        return 'PANNE';
      case BusStatut.inactif:
        return 'INACTIF';
    }
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _refreshBusData,
      color: AppColors.primaryPurple,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec info du bus
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryPurple, AppColors.primaryOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_bus,
                      color: AppColors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bus en service',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _bus?.immatriculation ?? _teamInfo['busNumber']!,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_bus != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'N° ${_bus!.numero}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        // Text(
                        //   _teamInfo['route']!,
                        //   style: const TextStyle(
                        //     color: AppColors.white,
                        //     fontSize: 14,
                        //   ),
                        // ),
                        if (_bus?.nomLigne != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            _bus!.nomLigne!,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Titre statistiques
            const Text(
              'Statistiques du jour',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            // Grille de statistiques
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  icon: Icons.route,
                  label: 'Voyages',
                  value: _todayStats['trips'].toString(),
                  color: AppColors.primaryPurple,
                ),
                _buildStatCard(
                  icon: Icons.people,
                  label: 'Passagers',
                  value: _todayStats['passengers'].toString(),
                  color: AppColors.primaryOrange,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScannedTicketsScreen(),
                      ),
                    );
                  },
                  child: _buildStatCard(
                    icon: Icons.qr_code_scanner,
                    label: 'Billets scannés',
                    value: _todayStats['ticketsScanned'].toString(),
                    color: AppColors.success,
                    isClickable: true,
                  ),
                ),
                _buildStatCard(
                  icon: Icons.attach_money,
                  label: 'Recettes (FC)',
                  value: _todayStats['revenue'],
                  color: AppColors.info,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Carte pour consulter les arrêts de la ligne
            if (_bus != null)
              GestureDetector(
                onTap: _showArrets,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryPurple.withOpacity(0.8),
                        AppColors.primaryPurple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Consulter les arrêts',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _bus!.nomLigne ??
                                  (_bus!.trajetId != null
                                      ? 'Ligne ${_bus!.trajetId}'
                                      : 'Voir les arrêts du trajet'),
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

            if (_bus != null) const SizedBox(height: 24),

            // Actions rapides
            // const Text(
            //   'Actions rapides',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: AppColors.textPrimary,
            //   ),
            // ),

            // const SizedBox(height: 16),

            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         onPressed: () {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             const SnackBar(
            //               content: Text('Fonction en cours de développement'),
            //               backgroundColor: AppColors.info,
            //             ),
            //           );
            //         },
            //         icon: const Icon(Icons.play_arrow),
            //         label: const Text('Commencer trajet'),
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: AppColors.success,
            //           foregroundColor: AppColors.white,
            //           padding: const EdgeInsets.all(16),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         onPressed: () {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             const SnackBar(
            //               content: Text('Fonction en cours de développement'),
            //               backgroundColor: AppColors.info,
            //             ),
            //           );
            //         },
            //         icon: const Icon(Icons.stop),
            //         label: const Text('Terminer trajet'),
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: AppColors.error,
            //           foregroundColor: AppColors.white,
            //           padding: const EdgeInsets.all(16),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamTab() {
    return RefreshIndicator(
      onRefresh: _refreshBusData,
      color: AppColors.primaryPurple,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Équipe connectée',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMemberCard(
              role: 'Chauffeur',
              matricule: _teamInfo['chauffeur']!,
              icon: Icons.person,
              membre: _chauffeur,
            ),
            const SizedBox(height: 12),
            _buildTeamMemberCard(
              role: 'Receveur',
              matricule: _teamInfo['receveur']!,
              icon: Icons.account_circle,
              membre: _receveur,
            ),
            const SizedBox(height: 12),
            _buildTeamMemberCard(
              role: 'Contrôleur',
              matricule: _teamInfo['collecteur']!,
              icon: Icons.badge,
              membre: _controleur,
            ),
            const SizedBox(height: 24),

            // Card du Bus
            const Text(
              'Véhicule affecté',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            if (_bus != null)
              _buildBusInfoCard()
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_bus_outlined,
                      size: 48,
                      color: AppColors.warning,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aucun véhicule affecté',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aucun bus n\'est associé à cette session',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryOrange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'L\'équipe complète est connectée et prête à travailler.',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipeBordProvider>(
      builder: (context, provider, child) {
        // Mettre à jour les variables locales avec les données du Provider
        _chauffeur = provider.chauffeur;
        _receveur = provider.receveur;
        _controleur = provider.controleur;
        _bus = provider.bus;
        _todayStats.addAll(provider.todayStats);

        // Mettre à jour _teamInfo
        _teamInfo['chauffeur'] = _chauffeur?.matricule ?? '';
        _teamInfo['receveur'] = _receveur?.matricule ?? '';
        _teamInfo['collecteur'] = _controleur?.matricule ?? '';
        _teamInfo['busNumber'] = _bus?.numero ?? '';
        _teamInfo['route'] = _bus?.nomLigne ?? '';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Espace de bord',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.error),
                onPressed: _handleLogout,
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeTab(),
              _buildTeamTab(),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _scanClientQRCode,
            backgroundColor: AppColors.primaryPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: AppColors.white,
                width: 1,
              ),
            ),
            icon: const Icon(Icons.qr_code_scanner, color: AppColors.white),
            label: const Text(
              'Scanner un Billet',
              style: TextStyle(
                  color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primaryPurple,
            unselectedItemColor: AppColors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Équipe',
              ),
            ],
          ),
        );
      },
    );
  }
}
