import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_helper.dart';
import '../../core/services/database_service.dart';
import '../../core/services/api_service.dart';
import '../../data/models/ticket_model.dart';
import '../../data/models/bus_position_model.dart';
import '../../data/models/transaction_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class BusTicketOrderScreen extends StatefulWidget {
  final BusPosition bus;
  final double distance;

  const BusTicketOrderScreen({
    super.key,
    required this.bus,
    required this.distance,
  });

  @override
  State<BusTicketOrderScreen> createState() => _BusTicketOrderScreenState();
}

class _BusTicketOrderScreenState extends State<BusTicketOrderScreen> {
  TicketType _selectedTicketType = TicketType.single;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.prepaidCard;
  bool _isLoading = false;
  DateTime? _lastBackPressTime;

  final Map<TicketType, Map<String, dynamic>> _ticketPrices = {
    TicketType.single: {'price': 200, 'name': 'Billet simple'},
    TicketType.roundTrip: {'price': 350, 'name': 'Aller-retour'},
    TicketType.daily: {'price': 800, 'name': 'Pass journalier'},
    TicketType.weekly: {'price': 4500, 'name': 'Pass hebdomadaire'},
    TicketType.monthly: {'price': 15000, 'name': 'Pass mensuel'},
  };

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
            _lastBackPressTime == null ||
                now.difference(_lastBackPressTime!) > const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
          _lastBackPressTime = now;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appuyez à nouveau pour quitter'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Récapitulatif de commande'),
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryPurple,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              24 + MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bus Information Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryPurple, AppColors.darkPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.directions_bus,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.bus.busId,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.bus.routeName ?? 'Non définie',
                                  style: TextStyle(
                                    color: AppColors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: widget.bus.isFull
                                  ? AppColors.error
                                  : AppColors.success,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.bus.isFull
                                  ? 'Complet'
                                  : '${widget.bus.occupancy}/${widget.bus.capacity}',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: AppColors.white.withOpacity(0.3)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBusInfoItem(
                            Icons.navigation,
                            'Direction',
                            widget.bus.direction ?? 'Non définie',
                          ),
                          _buildBusInfoItem(
                            Icons.location_on,
                            'Distance',
                            '${widget.distance.toStringAsFixed(1)} km',
                          ),
                          _buildBusInfoItem(
                            Icons.speed,
                            'Vitesse',
                            '${widget.bus.speed?.toStringAsFixed(0) ?? '0'} km/h',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        color: AppColors.primaryPurple,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Solde disponible',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            CurrencyHelper.convertAndFormat(
                              user?.balance ?? 0.0,
                              user?.currency ?? 'FC',
                            ),
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Ticket Type Selection
                const Text(
                  'Type de billet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 12),

                Column(
                  children: _ticketPrices.entries.map((entry) {
                    final ticketType = entry.key;
                    final ticketData = entry.value;
                    final isSelected = _selectedTicketType == ticketType;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTicketType = ticketType;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryPurple.withOpacity(0.1)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryPurple
                                  : AppColors.grey.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Radio<TicketType>(
                                value: ticketType,
                                groupValue: _selectedTicketType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTicketType = value!;
                                  });
                                },
                                activeColor: AppColors.primaryPurple,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ticketData['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    Text(
                                      _getTicketDescription(ticketType),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyHelper.convertAndFormat(
                                      ticketData['price'].toDouble(),
                                      user?.currency ?? 'FC',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (user?.currency == 'USD')
                                    Text(
                                      '(≈ ${ticketData['price']} FC)',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Payment Method Selection
                const Text(
                  'Méthode de paiement',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 12),

                Column(
                  children: [
                    _buildPaymentMethodTile(
                      PaymentMethod.prepaidCard,
                      'Carte prépayée',
                      'Utiliser le solde de votre carte',
                      Icons.credit_card,
                    ),
                    _buildPaymentMethodTile(
                      PaymentMethod.cash,
                      'Espèces',
                      'Paiement en liquide au receveur',
                      Icons.money,
                    ),
                    _buildPaymentMethodTile(
                      PaymentMethod.mobileMoney,
                      'Mobile Money',
                      'Orange Money, Wave, Free Money',
                      Icons.phone_android,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Purchase Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Résumé de l\'achat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Bus', widget.bus.busId),
                      _buildSummaryRow(
                          'Ligne', widget.bus.routeName ?? 'Non définie'),
                      _buildSummaryRow(
                          'Type', _ticketPrices[_selectedTicketType]!['name']),
                      _buildSummaryRow('Paiement',
                          _getPaymentMethodName(_selectedPaymentMethod)),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        'Total',
                        CurrencyHelper.convertAndFormat(
                          _ticketPrices[_selectedTicketType]!['price']
                              .toDouble(),
                          user?.currency ?? 'FC',
                        ),
                        isTotal: true,
                      ),
                      if (user?.currency == 'USD') ...[
                        const SizedBox(height: 4),
                        Text(
                          'Taux: ${CurrencyHelper.getExchangeRateText()}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Purchase Button
                CustomButton(
                  text: 'Confirmer l\'achat',
                  onPressed: !_isLoading ? _handlePurchase : null,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 16),

                // Info Message
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
                          'Votre billet sera généré avec un QR code unique pour la validation dans ce bus.',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    );
  }

  Widget _buildBusInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(
    PaymentMethod method,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = _selectedPaymentMethod == method;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryPurple.withOpacity(0.1)
                : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryPurple
                  : AppColors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Radio<PaymentMethod>(
                value: method,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                activeColor: AppColors.primaryPurple,
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: AppColors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppColors.primaryPurple : AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _getTicketDescription(TicketType type) {
    switch (type) {
      case TicketType.single:
        return 'Valable pour un trajet simple';
      case TicketType.roundTrip:
        return 'Aller-retour sur la même ligne';
      case TicketType.daily:
        return 'Trajets illimités pendant 24h';
      case TicketType.weekly:
        return 'Trajets illimités pendant 7 jours';
      case TicketType.monthly:
        return 'Trajets illimités pendant 30 jours';
    }
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Espèces';
      case PaymentMethod.card:
        return 'Carte bancaire';
      case PaymentMethod.mobileMoney:
        return 'Mobile Money';
      case PaymentMethod.prepaidCard:
        return 'Carte prépayée';
      case PaymentMethod.wallet:
        return 'Portefeuille électronique';
    }
  }

  Future<void> _handlePurchase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user before async gap
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;

      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Get database service
      final dbService = DatabaseService();

      // Generate unique IDs
      final ticketNumber = 'TKT${DateTime.now().millisecondsSinceEpoch}';
      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
      final qrCode = 'QR-$ticketNumber-${user.userId}';

      // Calculate validity period based on ticket type
      final now = DateTime.now();
      DateTime? expiresAt;
      String? validUntil;
      
      switch (_selectedTicketType) {
        case TicketType.single:
        case TicketType.roundTrip:
          expiresAt = now.add(const Duration(hours: 24));
          validUntil = expiresAt.toString().substring(0, 16);
          break;
        case TicketType.daily:
          expiresAt = now.add(const Duration(days: 1));
          validUntil = expiresAt.toString().substring(0, 16);
          break;
        case TicketType.weekly:
          expiresAt = now.add(const Duration(days: 7));
          validUntil = expiresAt.toString().substring(0, 16);
          break;
        case TicketType.monthly:
          expiresAt = now.add(const Duration(days: 30));
          validUntil = expiresAt.toString().substring(0, 16);
          break;
      }

      // Get ticket price
      final ticketPrice = _ticketPrices[_selectedTicketType]!['price'].toDouble();

      // Create Ticket object
      final ticket = Ticket(
        ticketId: ticketNumber,
        userId: user.userId,
        qrCode: qrCode,
        status: TicketStatus.active,
        type: _selectedTicketType,
        price: ticketPrice,
        currency: user.currency,
        routeName: widget.bus.routeName,
        origin: widget.bus.routeName?.split(' - ').first,
        destination: widget.bus.routeName?.split(' - ').last,
        busId: widget.bus.busId,
        expiresAt: expiresAt,
        isSynced: false,
      );

      // Create Transaction object
      final transaction = Transaction(
        transactionId: transactionId,
        userId: user.userId,
        type: TransactionType.purchase,
        status: TransactionStatus.completed,
        amount: ticketPrice,
        currency: user.currency,
        paymentMethod: _selectedPaymentMethod,
        ticketId: ticketNumber,
        busId: widget.bus.busId,
        description: 'Achat de billet ${_ticketPrices[_selectedTicketType]!['name']} - ${widget.bus.routeName}',
        isSynced: false,
      );

      // Save to database
      await dbService.saveTicket(ticket);
      await dbService.saveTransaction(transaction);

      // Insérer le billet dans MySQL
      try {
        print('🔵 Début de l\'insertion du billet dans MySQL...');
        final apiService = ApiService();
        
        // Récupérer le client_id depuis MySQL via l'UID Firebase
        int? clientId;
        try {
          print('🔵 Récupération du client_id pour UID: ${user.userId}');
          final clientResponse = await apiService.getClientByUid(user.userId);
          print('🔵 Réponse getClientByUid: $clientResponse');
          
          if (clientResponse['success'] == true && clientResponse['data'] != null) {
            clientId = clientResponse['data']['id'];
            print('✅ client_id trouvé: $clientId');
          } else {
            print('⚠️ Client non trouvé dans MySQL pour UID: ${user.userId}');
          }
        } catch (e) {
          print('⚠️ Impossible de récupérer le client_id: $e');
        }

        // Mapper le mode de paiement
        String modePaiement = 'autre';
        switch (_selectedPaymentMethod) {
          case PaymentMethod.cash:
            modePaiement = 'especes';
            break;
          case PaymentMethod.mobileMoney:
            modePaiement = 'mobile_money';
            break;
          case PaymentMethod.card:
            modePaiement = 'carte_bancaire';
            break;
          default:
            modePaiement = 'autre';
        }

        // Convertir la devise
        String devise = 'CDF';
        if (user.currency == 'USD') {
          devise = 'USD';
        }

        // Récupérer le trajet_id depuis le bus
        // Si le bus a un routeId, on l'utilise, sinon on utilise 7 (KAPELA - CLINIC NGALIEMA par défaut)
        int trajetId = 7; // Valeur par défaut: premier trajet existant
        if (widget.bus.routeId != null && widget.bus.routeId!.isNotEmpty) {
          trajetId = int.tryParse(widget.bus.routeId!) ?? 7;
        }
        
        print('🔵 Données du billet à insérer:');
        print('  - numeroBillet: $ticketNumber');
        print('  - busId: ${widget.bus.busId}');
        print('  - clientId: $clientId');
        print('  - trajetId: $trajetId');
        print('  - arretDepart: ${widget.bus.routeName?.split(' - ').first ?? 'Départ'}');
        print('  - arretArrivee: ${widget.bus.routeName?.split(' - ').last ?? 'Arrivée'}');
        print('  - dateVoyage: ${now.toString().substring(0, 10)}');
        print('  - prixPaye: $ticketPrice');
        print('  - devise: $devise');
        print('  - modePaiement: $modePaiement');
        
        print('📝 Appel API createBillet en cours...');
        final billetResponse = await apiService.createBillet(
          numeroBillet: ticketNumber,
          qrCode: qrCode,
          trajetId: trajetId, // Utiliser le routeId du bus
          busId: widget.bus.busId,
          clientId: clientId,
          arretDepart: widget.bus.routeName?.split(' - ').first ?? 'Départ',
          arretArrivee: widget.bus.routeName?.split(' - ').last ?? 'Arrivée',
          dateVoyage: now.toString().substring(0, 10), // Format YYYY-MM-DD
          heureDepart: null,
          siegeNumero: null, // Sera mis à jour après sélection du siège
          prixPaye: ticketPrice,
          devise: devise,
          statutBillet: 'paye',
          modePaiement: modePaiement,
          referencePaiement: transactionId,
        );
        
        print('🔵 Réponse createBillet: $billetResponse');
        
        if (billetResponse['success'] == true) {
          print('✅ Billet enregistré dans MySQL avec succès - ID: ${billetResponse['data']?['id']}');
        } else {
          print('❌ Échec de l\'enregistrement du billet: ${billetResponse['message']}');
        }
      } catch (e, stackTrace) {
        // Erreur non-bloquante - le billet est déjà sauvegardé localement
        print('⚠️ Erreur lors de l\'enregistrement dans MySQL (non-bloquante): $e');
        print('Stack trace: $stackTrace');
      }

      // Prepare ticket data for seat selection screen
      final ticketData = {
        'ticketNumber': ticketNumber,
        'busId': widget.bus.busId,
        'route': widget.bus.routeName ?? 'Non définie',
        'direction': widget.bus.routeName?.split(' - ').last ?? 'Non définie',
        'ticketType': _ticketPrices[_selectedTicketType]!['name'],
        'paymentMethod': _getPaymentMethodName(_selectedPaymentMethod),
        'amount': CurrencyHelper.convertAndFormat(
          ticketPrice,
          user.currency,
        ),
        'purchaseDate': now.toString().substring(0, 16),
        'validUntil': validUntil,
        'userId': user.userId,
        'userName': user.name,
        'qrCode': qrCode,
        'origin': widget.bus.routeName?.split(' - ').first,
        'destination': widget.bus.routeName?.split(' - ').last,
        'price': ticketPrice,
        'currency': user.currency,
        'ticketTypeEnum': _selectedTicketType.name,
        'expiresAt': expiresAt.toIso8601String(),
      };

      if (mounted) {
        // Naviguer vers l'écran de sélection de siège
        context.push('/seat-selection', extra: ticketData);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'achat: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
