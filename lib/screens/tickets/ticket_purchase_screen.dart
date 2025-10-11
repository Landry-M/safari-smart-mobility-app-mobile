import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_helper.dart';
import '../../core/services/database_service.dart';
import '../../data/models/ticket_model.dart';
import '../../data/models/transaction_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class TicketPurchaseScreen extends StatefulWidget {
  const TicketPurchaseScreen({super.key});

  @override
  State<TicketPurchaseScreen> createState() => _TicketPurchaseScreenState();
}

class _TicketPurchaseScreenState extends State<TicketPurchaseScreen> {
  TicketType _selectedTicketType = TicketType.single;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  String? _selectedRoute;
  bool _isLoading = false;

  final Map<TicketType, Map<String, dynamic>> _ticketPrices = {
    TicketType.single: {'price': 200, 'name': 'Billet simple'},
    TicketType.roundTrip: {'price': 350, 'name': 'Aller-retour'},
    TicketType.daily: {'price': 800, 'name': 'Pass journalier'},
    TicketType.weekly: {'price': 4500, 'name': 'Pass hebdomadaire'},
    TicketType.monthly: {'price': 15000, 'name': 'Pass mensuel'},
  };

  final List<String> _availableRoutes = [
    'Centre ville - Gombe',
    'Centre ville - Lemba',
    'Centre ville - Ngaliema',
    'Gombe - Lemba',
    'Bandalungwa - Centre ville',
    'Masina - Centre ville',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.buyTicket),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
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
                // Balance Card
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
                          const Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Solde disponible',
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                CurrencyHelper.convertAndFormat(
                                  user?.balance ?? 0.0,
                                  user?.currency ?? 'FC',
                                ),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (user?.currency == 'USD') ...[
                        const SizedBox(height: 8),
                        Text(
                          '(≈ ${(user?.balance ?? 0.0).toStringAsFixed(0)} FC)',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Route Selection
                const Text(
                  'Sélectionner la ligne',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRoute,
                      hint: const Text('Choisir une ligne',
                          style: TextStyle(color: AppColors.black)),
                      isExpanded: true,
                      dropdownColor: AppColors.white,
                      style:
                          const TextStyle(color: AppColors.black, fontSize: 14),
                      items: _availableRoutes.map((route) {
                        return DropdownMenuItem(
                          value: route,
                          child: Text(route),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRoute = value;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Ticket Type Selection
                const Text(
                  'Type de billet',
                  style: TextStyle(
                    fontSize: 14,
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
                                  : AppColors.grey,
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
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    Text(
                                      _getTicketDescription(ticketType),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.black,
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
                                      fontSize: 14,
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (user?.currency == 'USD')
                                    Text(
                                      '(≈ ${ticketData['price']} FC)',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.black,
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
                    fontSize: 14,
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
                    border: Border.all(color: AppColors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Résumé de l\'achat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Ligne',
                          _selectedRoute ?? 'Non sélectionnée', user?.currency),
                      _buildSummaryRow(
                          'Type',
                          _ticketPrices[_selectedTicketType]!['name'],
                          user?.currency),
                      _buildSummaryRow(
                          'Paiement',
                          _getPaymentMethodName(_selectedPaymentMethod),
                          user?.currency),
                      const Divider(),
                      _buildSummaryRow(
                        'Total',
                        CurrencyHelper.convertAndFormat(
                          _ticketPrices[_selectedTicketType]!['price']
                              .toDouble(),
                          user?.currency ?? 'FC',
                        ),
                        user?.currency,
                        isTotal: true,
                      ),
                      if (user?.currency == 'USD') ...[
                        const SizedBox(height: 4),
                        Text(
                          'Taux: ${CurrencyHelper.getExchangeRateText()}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Purchase Button
                CustomButton(
                  text: 'Acheter le billet',
                  onPressed:
                      _canPurchase() && !_isLoading ? _handlePurchase : null,
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
                          'Votre billet sera généré avec un QR code unique pour la validation.',
                          style: const TextStyle(
                            color: AppColors.black,
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
              color: isSelected ? AppColors.primaryPurple : AppColors.grey,
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
                        color: AppColors.black,
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

  Widget _buildSummaryRow(String label, String value, String? currency,
      {bool isTotal = false}) {
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
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
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

  bool _canPurchase() {
    return _selectedRoute != null;
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

      // Parse route to get origin and destination
      final routeParts = _selectedRoute?.split(' - ');
      final origin = routeParts?.first;
      final destination = routeParts?.length == 2 ? routeParts?.last : null;

      // Create Ticket object
      final ticket = Ticket(
        ticketId: ticketNumber,
        userId: user.userId,
        qrCode: qrCode,
        status: TicketStatus.active,
        type: _selectedTicketType,
        price: ticketPrice,
        currency: user.currency,
        routeName: _selectedRoute,
        origin: origin,
        destination: destination,
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
        description: 'Achat de billet ${_ticketPrices[_selectedTicketType]!['name']} - $_selectedRoute',
        isSynced: false,
      );

      // Save to database
      await dbService.saveTicket(ticket);
      await dbService.saveTransaction(transaction);

      // Prepare ticket data for confirmation screen
      final ticketData = {
        'ticketNumber': ticketNumber,
        'route': _selectedRoute,
        'ticketType': _ticketPrices[_selectedTicketType]!['name'],
        'paymentMethod': _getPaymentMethodName(_selectedPaymentMethod),
        'amount': CurrencyHelper.convertAndFormat(
          ticketPrice,
          user.currency,
        ),
        'purchaseDate': now.toString().substring(0, 16),
        'validUntil': validUntil,
        'userId': user.id,
        'userName': user.name,
        'qrCode': qrCode,
      };

      if (mounted) {
        context.go('/ticket-confirmation', extra: ticketData);
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
