import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/location_service.dart';
import '../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Paramètres'),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Settings Section
                const Text(
                  'Paramètres de l\'application',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 16),

                _buildSettingCard(
                  context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle:
                      user.notificationsEnabled ? 'Activées' : 'Désactivées',
                  trailing: Switch(
                    value: user.notificationsEnabled,
                    onChanged: (value) async {
                      final updatedUser =
                          user.copyWith(notificationsEnabled: value);
                      await authProvider.updateUser(updatedUser);
                    },
                    activeColor: AppColors.primaryPurple,
                  ),
                ),

                const SizedBox(height: 12),

                _buildSettingCard(
                  context,
                  icon: Icons.location_on,
                  title: 'Localisation',
                  subtitle: user.locationEnabled ? 'Activée' : 'Désactivée',
                  trailing: Switch(
                    value: user.locationEnabled,
                    onChanged: (value) async {
                      if (value) {
                        // Si on active, demander la permission
                        final locationService = LocationService();
                        final hasPermission = await locationService.requestLocationPermission();
                        
                        if (hasPermission) {
                          // Permission accordée
                          final updatedUser = user.copyWith(locationEnabled: true);
                          await authProvider.updateUser(updatedUser);
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Localisation activée avec succès',
                                  style: TextStyle(color: AppColors.white),
                                ),
                                backgroundColor: AppColors.success,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          // Permission refusée
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Permission de localisation refusée',
                                  style: TextStyle(color: AppColors.white),
                                ),
                                backgroundColor: AppColors.error,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      } else {
                        // Si on désactive, pas besoin de permission
                        final updatedUser = user.copyWith(locationEnabled: false);
                        await authProvider.updateUser(updatedUser);
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Localisation désactivée'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    activeColor: AppColors.primaryPurple,
                  ),
                ),

                const SizedBox(height: 12),

                _buildSettingCard(
                  context,
                  icon: Icons.language,
                  title: 'Langue',
                  subtitle: user.language == 'fr' ? 'Français' : 'English',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    //  _showLanguageDialog(context, authProvider, user);
                  },
                ),

                const SizedBox(height: 16),

                // Location info
                if (user.locationEnabled)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'La localisation est utilisée pour trouver les bus à proximité',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                if (!user.locationEnabled)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Activez la localisation pour voir les bus à proximité',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // Payment Settings Section
                const Text(
                  'Paramètres de paiement',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                // const SizedBox(height: 16),

                // _buildSettingCard(
                //   context,
                //   icon: Icons.credit_card,
                //   title: 'Rechargement automatique',
                //   subtitle: user.autoRecharge ? 'Activé' : 'Désactivé',
                //   trailing: Switch(
                //     value: user.autoRecharge,
                //     onChanged: (value) async {
                //       final updatedUser =
                //           user.copyWith(autoRecharge: value);
                //       await authProvider.updateUser(updatedUser);
                //     },
                //     activeColor: AppColors.primaryPurple,
                //   ),
                // ),

                const SizedBox(height: 12),

                _buildSettingCard(
                  context,
                  icon: Icons.monetization_on,
                  title: 'Devise',
                  subtitle: user.currency == 'USD'
                      ? 'Dollar américain (USD)'
                      : 'Franc congolais (FC)',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showCurrencyDialog(context, authProvider, user),
                ),

                const SizedBox(height: 32),

                // Info Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryPurple,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Taux de change',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '1 USD = 2450 FC',
                              style: TextStyle(
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

                const SizedBox(height: 24),
              ],
            ),
          );
        },
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

  void _showLanguageDialog(
      BuildContext context, AuthProvider authProvider, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir la langue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Français'),
                trailing: user.language == 'fr'
                    ? Icon(Icons.check, color: AppColors.primaryPurple)
                    : null,
                onTap: () async {
                  final updatedUser = user.copyWith(language: 'fr');
                  await authProvider.updateUser(updatedUser);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                trailing: user.language == 'en'
                    ? Icon(Icons.check, color: AppColors.primaryPurple)
                    : null,
                onTap: () async {
                  final updatedUser = user.copyWith(language: 'en');
                  await authProvider.updateUser(updatedUser);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
