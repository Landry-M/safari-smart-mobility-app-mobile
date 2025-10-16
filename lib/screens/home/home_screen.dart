import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_helper.dart';
import '../../core/services/database_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/ticket_model.dart';
import '../../data/models/transaction_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  DateTime? _lastBackPressTime;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    final maxDuration = const Duration(seconds: 2);
    final isWarning = _lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > maxDuration;

    if (isWarning) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appuyez encore une fois pour quitter'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryPurple,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _HomeTab(
                onNavigateToTab: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              const _TicketsTab(),
              const _ProfileTab(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primaryPurple,
            unselectedItemColor: AppColors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppStrings.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number),
                label: 'Billets',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: AppStrings.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const _HomeTab({required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryPurple,
                      child: user?.avatar != null
                          ? ClipOval(
                              child: Image.network(
                                user!.avatar!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(
                              user?.name.isNotEmpty == true
                                  ? user!.name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour,',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          Text(
                            user?.displayName ?? user?.name ?? 'Utilisateur',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Notifications en cours de développement'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryPurple, AppColors.darkPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.balance,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.white.withOpacity(0.9),
                                ),
                          ),
                          Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CurrencyHelper.convertAndFormat(
                          user?.balance ?? 0.0,
                          user?.currency ?? 'FC',
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (user?.currency == 'USD') ...[
                        const SizedBox(height: 4),
                        Text(
                          '(≈ ${(user?.balance ?? 0.0).toStringAsFixed(0)} FC)',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.white.withOpacity(0.8),
                                  ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        CurrencyHelper.getExchangeRateText(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: AppStrings.rechargeCard,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Rechargement de carte en cours de développement'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        backgroundColor: AppColors.white,
                        textColor: AppColors.primaryPurple,
                        height: 40,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Actions rapides',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        context,
                        icon: Icons.confirmation_number,
                        title: AppStrings.buyTicket,
                        subtitle: 'Acheter un billet',
                        color: AppColors.primaryOrange,
                        onTap: () => context.go('/buy-ticket'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Expanded(
                    //   child: _buildQuickActionCard(
                    //     context,
                    //     icon: Icons.qr_code_scanner,
                    //     title: AppStrings.scanQr,
                    //     subtitle: 'Scanner un QR code',
                    //     color: AppColors.primaryPurple,
                    //     onTap: () => context.go('/scanner'),
                    //   ),
                    // ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        context,
                        icon: Icons.location_on,
                        title: AppStrings.nearbyBuses,
                        subtitle: 'Bus à proximité',
                        color: AppColors.info,
                        onTap: () => context.go('/home/nearby-buses'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        context,
                        icon: Icons.history,
                        title: AppStrings.history,
                        subtitle: 'Voir l\'historique',
                        color: AppColors.darkGrey,
                        onTap: () {
                          onNavigateToTab(1); // Navigate to Tickets tab
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // User Role Specific Actions
                if (user?.role == UserRole.driver) ...[
                  Text(
                    'Actions chauffeur',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildDriverActions(context),
                ] else if (user?.role == UserRole.controller) ...[
                  Text(
                    'Actions contrôleur',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildControllerActions(context),
                ] else if (user?.role == UserRole.collector) ...[
                  Text(
                    'Actions receveur',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildCollectorActions(context),
                ],

                const SizedBox(height: 24),

                // Badges Section
                if (user?.badges.isNotEmpty == true) ...[
                  Text(
                    'Mes badges',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user!.badges.map((badge) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryPurple.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 16,
                              color: AppColors.primaryPurple,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              badge,
                              style: TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverActions(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Mettre à jour ma position',
          icon: Icons.my_location,
          onPressed: () {
            // TODO: Implement location update
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Rapport de fin de service',
          icon: Icons.assignment,
          isOutlined: true,
          onPressed: () {
            // TODO: Implement end of service report
          },
        ),
      ],
    );
  }

  Widget _buildControllerActions(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Scanner les billets',
          icon: Icons.qr_code_scanner,
          onPressed: () => context.go('/scanner'),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Rapport de contrôle',
          icon: Icons.assignment_turned_in,
          isOutlined: true,
          onPressed: () {
            // TODO: Implement control report
          },
        ),
      ],
    );
  }

  Widget _buildCollectorActions(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Enregistrer encaissement',
          icon: Icons.monetization_on,
          onPressed: () {
            // TODO: Implement cash collection
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Rapport journalier',
          icon: Icons.assessment,
          isOutlined: true,
          onPressed: () {
            // TODO: Implement daily report
          },
        ),
      ],
    );
  }
}

class _TicketsTab extends StatefulWidget {
  const _TicketsTab();

  @override
  State<_TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends State<_TicketsTab> {
  List<Ticket> _tickets = [];
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0; // 0 = Tickets, 1 = Transactions

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;

      if (user != null) {
        final dbService = DatabaseService();
        final tickets = await dbService.getUserTickets(user.userId);
        final transactions = await dbService.getUserTransactions(user.userId);

        // Sort by date descending (most recent first)
        tickets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        setState(() {
          _tickets = tickets;
          _transactions = transactions;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de chargement: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Historique',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                // Tab selector
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Billets (${_tickets.length})',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _selectedTabIndex == 0
                                  ? AppColors.primaryPurple
                                  : AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Transactions (${_transactions.length})',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _selectedTabIndex == 1
                                  ? AppColors.primaryPurple
                                  : AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryPurple,
                    ),
                  )
                : _selectedTabIndex == 0
                    ? _buildTicketsList()
                    : _buildTransactionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsList() {
    if (_tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 64,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun billet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vos billets achetés apparaîtront ici',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tickets.length,
        itemBuilder: (context, index) {
          final ticket = _tickets[index];
          return _buildTicketCard(ticket);
        },
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    final isExpired = ticket.isExpired;
    final isActive = ticket.status == TicketStatus.active && !isExpired;

    return GestureDetector(
      onTap: () => _showTicketQRCode(ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.success
                : isExpired
                    ? AppColors.error
                    : AppColors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.routeName ?? 'Route non définie',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticket.ticketId,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.success
                          : isExpired
                              ? AppColors.error
                              : AppColors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive
                          ? 'Actif'
                          : isExpired
                              ? 'Expiré'
                              : _getStatusText(ticket.status),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: AppColors.grey.withOpacity(0.3)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTicketInfo(Icons.category, _getTypeText(ticket.type)),
                  _buildTicketInfo(Icons.monetization_on,
                      '${ticket.price.toInt()} ${ticket.currency}'),
                  _buildTicketInfo(
                    Icons.calendar_today,
                    '${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}',
                  ),
                ],
              ),
              if (ticket.expiresAt != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color:
                          isExpired ? AppColors.error : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Expire le ${ticket.expiresAt!.day}/${ticket.expiresAt!.month}/${ticket.expiresAt!.year} à ${ticket.expiresAt!.hour}:${ticket.expiresAt!.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isExpired
                            ? AppColors.error
                            : AppColors.textSecondary,
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

  void _showTicketQRCode(Ticket ticket) {
    final isExpired = ticket.isExpired;
    final isActive = ticket.status == TicketStatus.active && !isExpired;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
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

            const SizedBox(height: 24),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Votre billet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.success
                            : isExpired
                                ? AppColors.error
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isActive
                                ? Icons.check_circle
                                : isExpired
                                    ? Icons.error
                                    : Icons.info,
                            color: AppColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isActive
                                ? 'Billet actif'
                                : isExpired
                                    ? 'Billet expiré'
                                    : _getStatusText(ticket.status),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: ticket.qrCode,
                            version: QrVersions.auto,
                            size: 250.0,
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.black,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            ticket.ticketId,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Ticket information
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informations du billet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            icon: Icons.route,
                            label: 'Ligne',
                            value: ticket.routeName ?? 'Non définie',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.category,
                            label: 'Type',
                            value: _getTypeText(ticket.type),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.monetization_on,
                            label: 'Prix',
                            value: '${ticket.price.toInt()} ${ticket.currency}',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.directions_bus,
                            label: 'Bus',
                            value: ticket.busId ?? 'Non assigné',
                          ),
                          if (ticket.origin != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              icon: Icons.trip_origin,
                              label: 'Origine',
                              value: ticket.origin!,
                            ),
                          ],
                          if (ticket.destination != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              icon: Icons.location_on,
                              label: 'Destination',
                              value: ticket.destination!,
                            ),
                          ],
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.calendar_today,
                            label: 'Date d\'achat',
                            value:
                                '${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year} à ${ticket.createdAt.hour}:${ticket.createdAt.minute.toString().padLeft(2, '0')}',
                          ),
                          if (ticket.expiresAt != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              icon: Icons.access_time,
                              label: 'Expire le',
                              value:
                                  '${ticket.expiresAt!.day}/${ticket.expiresAt!.month}/${ticket.expiresAt!.year} à ${ticket.expiresAt!.hour}:${ticket.expiresAt!.minute.toString().padLeft(2, '0')}',
                              isWarning: isExpired,
                            ),
                          ],
                          if (ticket.validatedAt != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              icon: Icons.check_circle,
                              label: 'Validé le',
                              value:
                                  '${ticket.validatedAt!.day}/${ticket.validatedAt!.month}/${ticket.validatedAt!.year} à ${ticket.validatedAt!.hour}:${ticket.validatedAt!.minute.toString().padLeft(2, '0')}',
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Instructions
                    if (isActive) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.info.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.info,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Présentez ce QR code au contrôleur lors de la montée dans le bus.',
                                style: TextStyle(
                                  color: AppColors.info,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isWarning = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isWarning ? AppColors.error : AppColors.primaryPurple,
        ),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isWarning ? AppColors.error : AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primaryPurple),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList() {
    if (_transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune transaction',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vos transactions apparaîtront ici',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return _buildTransactionCard(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isCompleted = transaction.status == TransactionStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.transactionId,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${transaction.amount.toInt()} ${transaction.currency}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        isCompleted ? AppColors.success : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getTransactionIcon(transaction.type),
                      size: 14,
                      color: AppColors.primaryPurple,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getTransactionTypeText(transaction.type),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getTransactionStatusText(transaction.status),
                    style: TextStyle(
                      color: _getStatusColor(transaction.status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.pending:
        return 'En attente';
      case TicketStatus.active:
        return 'Actif';
      case TicketStatus.validated:
        return 'Validé';
      case TicketStatus.expired:
        return 'Expiré';
      case TicketStatus.cancelled:
        return 'Annulé';
      case TicketStatus.refunded:
        return 'Remboursé';
    }
  }

  String _getTypeText(TicketType type) {
    switch (type) {
      case TicketType.single:
        return 'Simple';
      case TicketType.roundTrip:
        return 'A/R';
      case TicketType.daily:
        return 'Journalier';
      case TicketType.weekly:
        return 'Hebdo';
      case TicketType.monthly:
        return 'Mensuel';
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return Icons.shopping_cart;
      case TransactionType.recharge:
        return Icons.add_circle;
      case TransactionType.refund:
        return Icons.money_off;
      case TransactionType.collection:
        return Icons.payments;
    }
  }

  String _getTransactionTypeText(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return 'Achat';
      case TransactionType.recharge:
        return 'Rechargement';
      case TransactionType.refund:
        return 'Remboursement';
      case TransactionType.collection:
        return 'Encaissement';
    }
  }

  String _getTransactionStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'En attente';
      case TransactionStatus.processing:
        return 'En cours';
      case TransactionStatus.completed:
        return 'Terminé';
      case TransactionStatus.failed:
        return 'Échoué';
      case TransactionStatus.cancelled:
        return 'Annulé';
      case TransactionStatus.refunded:
        return 'Remboursé';
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.processing:
        return AppColors.info;
      case TransactionStatus.completed:
        return AppColors.success;
      case TransactionStatus.failed:
        return AppColors.error;
      case TransactionStatus.cancelled:
        return AppColors.grey;
      case TransactionStatus.refunded:
        return AppColors.primaryOrange;
    }
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        if (user == null) {
          return const Center(
            child: Text('Utilisateur non connecté'),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.white,
                          child: user.avatar != null
                              ? ClipOval(
                                  child: Image.network(
                                    user.avatar!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    color: AppColors.primaryPurple,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Name
                        Text(
                          user.displayName ?? user.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 4),

                        // Role
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getRoleDisplayName(user.role),
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Phone
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: AppColors.white.withOpacity(0.8),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.phone,
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Profile sections
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Information
                      Text(
                        'Informations du compte',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 16),

                      _buildInfoCard(
                        context,
                        icon: Icons.person,
                        title: 'Nom complet',
                        value: user.name,
                      ),

                      const SizedBox(height: 12),

                      _buildInfoCard(
                        context,
                        icon: Icons.email,
                        title: 'Email',
                        value: user.email.isNotEmpty
                            ? user.email
                            : 'Non renseigné',
                      ),

                      const SizedBox(height: 12),

                      _buildInfoCard(
                        context,
                        icon: Icons.phone,
                        title: 'Téléphone',
                        value: user.phone,
                      ),

                      const SizedBox(height: 24),

                      // Actions
                      Text(
                        'Actions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 16),

                      _buildActionButton(
                        context,
                        icon: Icons.edit,
                        title: 'Modifier le profil',
                        onTap: () => context.push('/edit-profile'),
                      ),

                      const SizedBox(height: 12),

                      _buildActionButton(
                        context,
                        icon: Icons.history,
                        title: 'Historique des trajets',
                        onTap: () {
                          // TODO: Navigate to history
                        },
                      ),

                      const SizedBox(height: 12),

                      _buildActionButton(
                        context,
                        icon: Icons.settings,
                        title: 'Paramètres',
                        onTap: () => context.push('/settings'),
                      ),

                      const SizedBox(height: 24),

                      // Logout button
                      CustomButton(
                        text: 'Déconnexion',
                        onPressed: () async {
                          final confirmed = await _showLogoutDialog(context);
                          if (confirmed == true && context.mounted) {
                            await authProvider.logout();
                            if (context.mounted) {
                              context.go('/login');
                            }
                          }
                        },
                        backgroundColor: AppColors.error,
                        textColor: AppColors.white,
                        icon: Icons.logout,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.passenger:
        return 'Passager';
      case UserRole.driver:
        return 'Chauffeur';
      case UserRole.controller:
        return 'Contrôleur';
      case UserRole.collector:
        return 'Receveur';
      case UserRole.admin:
        return 'Administrateur';
    }
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryPurple,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}
