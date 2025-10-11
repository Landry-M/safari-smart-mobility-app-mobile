import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: AppColors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryPurple,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(
              child: Text('Utilisateur non connecté'),
            );
          }

          return SingleChildScrollView(
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
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
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
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Profile Information
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations personnelles',
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
                        icon: Icons.phone,
                        title: 'Téléphone',
                        value: user.phone,
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

                      if (user.travelPurpose != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          context,
                          icon: Icons.commute,
                          title: 'Motif de voyage',
                          value:
                              _getTravelPurposeDisplayName(user.travelPurpose!),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Account Settings
                      Text(
                        'Paramètres du compte',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 16),

                      _buildSettingCard(
                        context,
                        icon: Icons.credit_card,
                        title: 'Rechargement automatique',
                        subtitle: user.autoRecharge ? 'Activé' : 'Désactivé',
                        trailing: Switch(
                          value: user.autoRecharge,
                          onChanged: (value) {
                            // TODO: Update auto recharge setting
                          },
                          activeColor: AppColors.primaryPurple,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildSettingCard(
                        context,
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: user.notificationsEnabled
                            ? 'Activées'
                            : 'Désactivées',
                        trailing: Switch(
                          value: user.notificationsEnabled,
                          onChanged: (value) {
                            // TODO: Update notifications setting
                          },
                          activeColor: AppColors.primaryPurple,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildSettingCard(
                        context,
                        icon: Icons.language,
                        title: 'Langue',
                        subtitle:
                            user.language == 'fr' ? 'Français' : 'English',
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Show language selection
                        },
                      ),

                      const SizedBox(height: 12),

                      _buildSettingCard(
                        context,
                        icon: Icons.location_on,
                        title: 'Localisation',
                        subtitle:
                            user.locationEnabled ? 'Activée' : 'Désactivée',
                        trailing: Switch(
                          value: user.locationEnabled,
                          onChanged: (value) async {
                            final updatedUser =
                                user.copyWith(locationEnabled: value);
                            await authProvider.updateUser(updatedUser);
                          },
                          activeColor: AppColors.primaryPurple,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildSettingCard(
                        context,
                        icon: Icons.monetization_on,
                        title: 'Devise',
                        subtitle: user.currency == 'USD'
                            ? 'Dollar américain (USD)'
                            : 'Franc congolais (FC)',
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            _showCurrencyDialog(context, authProvider, user),
                      ),

                      const SizedBox(height: 24),

                      // Statistics
                      if (user.badges.isNotEmpty) ...[
                        Text(
                          'Mes badges (${user.badges.length})',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
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
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: user.badges.map((badge) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primaryPurple
                                        .withOpacity(0.3),
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
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Modifier le profil',
                              icon: Icons.edit,
                              isOutlined: true,
                              onPressed: () => context.push('/edit-profile'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: AppStrings.logout,
                              icon: Icons.logout,
                              backgroundColor: AppColors.error,
                              onPressed: () =>
                                  _showLogoutDialog(context, authProvider),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
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

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
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
                    fontSize: 12,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
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
                  const SizedBox(height: 2),
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
            if (trailing != null) trailing,
          ],
        ),
      ),
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

  String _getTravelPurposeDisplayName(TravelPurpose purpose) {
    switch (purpose) {
      case TravelPurpose.work:
        return 'Travail';
      case TravelPurpose.studies:
        return 'Études';
      case TravelPurpose.tourism:
        return 'Tourisme';
    }
  }

  void _showCurrencyDialog(
      BuildContext context, AuthProvider authProvider, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir la devise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Dollar américain (USD)'),
                trailing: user.currency == 'USD'
                    ? Icon(Icons.check, color: AppColors.primaryPurple)
                    : null,
                onTap: () async {
                  final updatedUser = user.copyWith(currency: 'USD');
                  await authProvider.updateUser(updatedUser);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text('Franc congolais (FC)'),
                trailing: user.currency == 'FC'
                    ? Icon(Icons.check, color: AppColors.primaryPurple)
                    : null,
                onTap: () async {
                  final updatedUser = user.copyWith(currency: 'FC');
                  await authProvider.updateUser(updatedUser);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Taux de change: 1 USD = 2450 FC',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await authProvider.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: Text(
                AppStrings.logout,
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
