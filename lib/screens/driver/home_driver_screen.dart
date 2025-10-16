import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/driver_session_service.dart';
import '../../core/services/equipe_bord_service.dart';
import '../../core/services/database_service.dart';
import '../../core/services/api_service.dart';
import '../../data/models/equipe_bord_model.dart';
import '../../data/models/ticket_model.dart';
import '../../data/models/bus_model.dart';
import '../scanner/qr_scanner_screen.dart';

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({super.key});

  @override
  State<HomeDriverScreen> createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  int _currentIndex = 0;
  final _sessionService = DriverSessionService();
  final _equipeBordService = EquipeBordService();
  final _dbService = DatabaseService();
  final _apiService = ApiService();

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
  };

  @override
  void initState() {
    super.initState();
    _loadDriverSession();
  }

  Future<void> _loadDriverSession() async {
    try {
      final sessionData =
          await _equipeBordService.getActiveSessionWithMembers();

      if (sessionData != null) {
        print('✅ Session trouvée, chargement des données...');
        print('🚌 Bus dans sessionData: ${sessionData['bus']}');
        setState(() {
          _chauffeur = sessionData['chauffeur'] as EquipeBord?;
          _receveur = sessionData['receveur'] as EquipeBord?;
          _controleur = sessionData['controleur'] as EquipeBord?;
          _bus = sessionData['bus'] as Bus?;
          print('🚌 _bus après assignation: $_bus');

          final session = sessionData['session'];
          _teamInfo = {
            'chauffeur': _chauffeur?.matricule ?? '',
            'receveur': _receveur?.matricule ?? '',
            'collecteur': _controleur?.matricule ?? '',
            'busNumber': _bus?.immatriculation ?? session?.busNumber ?? 'N/A',
            'route': session?.route ?? '',
          };
        });
      } else {
        print('⚠️ Aucune session active trouvée');
        // Ne pas rediriger pour permettre de voir les statistiques à 0
        // Si pas de session, afficher des valeurs par défaut
        setState(() {
          _teamInfo = {
            'chauffeur': 'Non connecté',
            'receveur': 'Non connecté',
            'collecteur': 'Non connecté',
            'busNumber': 'N/A',
            'route': 'N/A',
          };
        });
      }
    } catch (e) {
      print('❌ Erreur lors du chargement de la session: $e');
      // Afficher un message d'erreur mais ne pas bloquer
      setState(() {
        _teamInfo = {
          'chauffeur': 'Erreur',
          'receveur': 'Erreur',
          'collecteur': 'Erreur',
          'busNumber': 'N/A',
          'route': 'N/A',
        };
      });
    }
  }

  /// Rafraîchir les données du bus depuis l'API
  Future<void> _refreshBusData() async {
    try {
      // Récupérer la session active
      final session = await _dbService.getActiveDriverSession();
      if (session == null ||
          session.busNumber == null ||
          session.busNumber!.isEmpty) {
        print('⚠️ Aucun bus dans la session active');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aucun véhicule affecté à cette session'),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      print('🔄 Rafraîchissement des données du bus: ${session.busNumber}');

      // Récupérer les infos à jour depuis l'API
      final busResult = await _apiService.getBusInfo(session.busNumber!);

      if (busResult['success'] == true && busResult['data'] != null) {
        // Créer et sauvegarder le bus dans Isar
        final busData = busResult['data'];
        final bus = Bus.fromApi(busData);
        await _dbService.saveBus(bus);

        print(
            '✅ Bus mis à jour dans Isar: ${bus.immatriculation} (N° ${bus.numero})');

        // Recharger la session pour mettre à jour l'affichage
        await _loadDriverSession();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Véhicule ${bus.immatriculation} mis à jour'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        print('⚠️ Impossible de récupérer les infos du bus depuis l\'API');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de récupérer les données du véhicule'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Erreur lors du rafraîchissement du bus: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
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
          padding: const EdgeInsets.all(24),
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
        title: const Text('Déconnexion'),
        content:
            const Text('Voulez-vous vraiment déconnecter toute l\'équipe ?'),
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
            content: Text('Erreur lors du scan: $e'),
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
          content: Text('Billet validé avec succès'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la validation: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
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
          padding: const EdgeInsets.all(24),
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

              if (_bus!.ligneAffectee != null)
                _buildDetailRow(
                  icon: Icons.route,
                  label: 'Ligne affectée',
                  value: _bus!.ligneAffectee!,
                ),
              if (_bus!.ligneAffectee != null) const Divider(height: 32),

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
                        Text(
                          _teamInfo['route']!,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
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
                _buildStatCard(
                  icon: Icons.confirmation_number,
                  label: 'Billets vendus',
                  value: _todayStats['ticketsSold'].toString(),
                  color: AppColors.success,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Espace Chauffeur',
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
        icon: const Icon(Icons.qr_code_scanner, color: AppColors.white),
        label: const Text(
          'Scanner Billet',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
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
  }
}
