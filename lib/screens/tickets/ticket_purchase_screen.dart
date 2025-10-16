import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_helper.dart';
import '../../core/services/database_service.dart';
import '../../core/services/api_service.dart';
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
  Map<String, dynamic>? _selectedRoute;
  bool _isLoading = false;
  DateTime? _lastBackPressTime;
  List<Map<String, dynamic>> _lignesFromApi = [];
  bool _isLoadingLignes = true;
  final ApiService _apiService = ApiService();

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
  void initState() {
    super.initState();
    _loadLignes();
  }

  Future<void> _loadLignes() async {
    try {
      final lignes = await _apiService.getLignes();
      setState(() {
        _lignesFromApi = lignes;
        _isLoadingLignes = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des lignes: $e');
      setState(() {
        _isLoadingLignes = false;
      });
    }
  }

  List<Map<String, dynamic>> get _routesToDisplay {
    if (_lignesFromApi.isNotEmpty) {
      return _lignesFromApi;
    }
    // Convertir les routes en dur en format Map
    return _availableRoutes.map((route) => {
      'nom': route,
      'distance_totale': null,
    }).toList();
  }

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
          context.pop();
        }
      },
      child: Scaffold(
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
                    child: DropdownButton<Map<String, dynamic>>(
                      value: _selectedRoute,
                      hint: const Text('Choisir une ligne',
                          style: TextStyle(color: AppColors.black)),
                      isExpanded: true,
                      dropdownColor: AppColors.white,
                      style:
                          const TextStyle(color: AppColors.black, fontSize: 14),
                      items: _isLoadingLignes
                          ? []
                          : _routesToDisplay.map((route) {
                              final distance = route['distance_totale'];
                              final distanceText = distance != null 
                                  ? ' (${double.parse(distance.toString()).toStringAsFixed(0)} km)'
                                  : '';
                              return DropdownMenuItem(
                                value: route,
                                child: Text(
                                  '${route['nom']}$distanceText',
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                          _selectedRoute != null 
                              ? '${_selectedRoute!['nom']}${_selectedRoute!['distance_totale'] != null ? ' (${double.parse(_selectedRoute!['distance_totale'].toString()).toStringAsFixed(0)} km)' : ''}'
                              : 'Non sélectionnée', 
                          user?.currency),
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
      final routeName = _selectedRoute?['nom'] as String?;
      final routeParts = routeName?.split(' - ');
      final origin = routeParts?.first;
      final destination = routeParts?.length == 2 ? routeParts?.last : null;
      
      // Get distance from route
      final distance = _selectedRoute?['distance_totale'];

      // Create Ticket object
      final ticket = Ticket(
        ticketId: ticketNumber,
        userId: user.userId,
        qrCode: qrCode,
        status: TicketStatus.active,
        type: _selectedTicketType,
        price: ticketPrice,
        currency: user.currency,
        routeName: routeName,
        origin: origin,
        destination: destination,
        distance: distance != null ? double.tryParse(distance.toString()) : null,
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
        description: 'Achat de billet ${_ticketPrices[_selectedTicketType]!['name']} - $routeName',
        isSynced: false,
      );

      // Save to database
      await dbService.saveTicket(ticket);
      await dbService.saveTransaction(transaction);

      // ============================================
      // INSERTION DANS MYSQL (BASE DE DONNÉES EN LIGNE)
      // ============================================
      print('🔵 ========================================');
      print('🔵 DÉBUT INSERTION BILLET DANS MYSQL');
      print('🔵 ========================================');
      
      try {
        // Étape 1: Récupération du client_id depuis MySQL via UID Firebase
        print('🔵 Étape 1: Récupération du client_id pour UID: ${user.userId}');
        final clientResponse = await _apiService.getClientByUid(user.userId);
        print('🔵 Réponse getClientByUid: $clientResponse');
        
        int? clientId;
        if (clientResponse['success'] == true && clientResponse['data'] != null) {
          clientId = clientResponse['data']['id'];
          print('✅ client_id trouvé: $clientId');
        } else {
          print('⚠️ Client non trouvé dans MySQL - clientId sera null');
          clientId = null;
        }

        // Étape 2: Récupération du trajet_id depuis la route sélectionnée
        print('🔵 Étape 2: Extraction du trajet_id depuis _selectedRoute');
        int trajetId = 7; // Valeur par défaut: KAPELA - CLINIC NGALIEMA
        
        if (_selectedRoute != null && _selectedRoute!['id'] != null) {
          final routeIdString = _selectedRoute!['id'].toString();
          trajetId = int.tryParse(routeIdString) ?? 7;
          print('✅ trajet_id extrait: $trajetId (depuis route ID: $routeIdString)');
        } else {
          print('⚠️ Aucun ID de route trouvé, utilisation du trajet par défaut: $trajetId');
        }

        // Étape 3: Préparation des données du billet pour MySQL
        print('🔵 Étape 3: Préparation des données du billet');
        
        // Conversion du mode de paiement
        String modePaiement;
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
          case PaymentMethod.prepaidCard:
          case PaymentMethod.wallet:
            modePaiement = 'autre';
            break;
        }
        
        // Conversion de la devise
        final devise = user.currency == 'FC' ? 'CDF' : user.currency;
        
        print('🔵 Données du billet à insérer:');
        print('  - numeroBillet: $ticketNumber');
        print('  - qrCode: $qrCode');
        print('  - trajetId: $trajetId');
        print('  - clientId: $clientId');
        print('  - arretDepart: ${origin ?? "Non défini"}');
        print('  - arretArrivee: ${destination ?? "Non défini"}');
        print('  - dateVoyage: ${now.toString().substring(0, 10)}');
        print('  - prixPaye: $ticketPrice');
        print('  - devise: $devise');
        print('  - modePaiement: $modePaiement');
        print('  - statutBillet: reserve');

        // Étape 4: Appel API pour créer le billet dans MySQL
        print('🔵 Étape 4: Appel API createBillet()...');
        final billetResponse = await _apiService.createBillet(
          numeroBillet: ticketNumber,
          qrCode: qrCode,
          trajetId: trajetId,
          busId: null, // Pas de bus_id pour achat depuis écran principal
          clientId: clientId,
          arretDepart: origin ?? 'Non défini',
          arretArrivee: destination ?? 'Non défini',
          dateVoyage: now.toString().substring(0, 10), // Format: YYYY-MM-DD
          heureDepart: null,
          siegeNumero: null, // Sera mis à jour après sélection du siège
          prixPaye: ticketPrice,
          devise: devise,
          statutBillet: 'reserve',
          modePaiement: modePaiement,
          referencePaiement: transactionId,
        );
        
        print('🔵 Réponse createBillet: $billetResponse');
        
        // Étape 5: Vérification du résultat
        if (billetResponse['success'] == true) {
          final billetId = billetResponse['data']?['id'];
          print('✅ ========================================');
          print('✅ Billet enregistré dans MySQL avec succès !');
          print('✅ ID MySQL: $billetId');
          print('✅ Numéro: $ticketNumber');
          print('✅ ========================================');
        } else {
          print('⚠️ ========================================');
          print('⚠️ Échec de l\'insertion MySQL (non-bloquant)');
          print('⚠️ Message: ${billetResponse['message']}');
          print('⚠️ Le billet reste valide en local');
          print('⚠️ ========================================');
        }
      } catch (mysqlError) {
        // Erreur non-bloquante : le billet local reste valide
        print('❌ ========================================');
        print('❌ ERREUR lors de l\'insertion MySQL (non-bloquante)');
        print('❌ Erreur: $mysqlError');
        print('❌ Stack trace: ${StackTrace.current}');
        print('❌ Le billet reste valide en local (Isar)');
        print('❌ ========================================');
      }

      // Prepare ticket data for seat selection screen
      final ticketData = {
        'ticketNumber': ticketNumber,
        'route': routeName,
        'distance': distance != null ? double.tryParse(distance.toString()) : null,
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
        'origin': origin,
        'destination': destination,
        'price': ticketPrice,
        'currency': user.currency,
        'ticketTypeEnum': _selectedTicketType.name,
        'expiresAt': expiresAt?.toIso8601String(),
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
