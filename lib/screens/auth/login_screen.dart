import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final phoneNumber = _phoneController.text.trim();

    try {
      print('🔍 [LOGIN] Numéro saisi: $phoneNumber');
      
      // Vérifier d'abord si le numéro existe dans Firestore
      final userExists = await authProvider.checkPhoneExists(phoneNumber);

      if (!mounted) return;

      print('🔍 [LOGIN] Résultat recherche: ${userExists != null ? "TROUVÉ" : "NON TROUVÉ"}');
      if (userExists != null) {
        print('🔍 [LOGIN] Données utilisateur: ${userExists['name']}, ${userExists['phone']}');
      }

      if (userExists == null) {
        // Le numéro n'existe pas, afficher une popup
        _showAccountNotFoundDialog();
        return;
      }

      // Le numéro existe dans Firestore, procéder à l'envoi de l'OTP
      print('✅ [LOGIN] Numéro trouvé dans Firestore, envoi OTP...');
      
      // Completer pour attendre le callback Firebase
      final completer = Completer<void>();
      String? verificationId;
      String? errorMessage;

      // Envoyer l'OTP Firebase
      authProvider.sendFirebaseOTP(
        phoneNumber: phoneNumber,
        onCodeSent: (verId) {
          print('✅ [LOGIN] OTP envoyé avec succès, verificationId: $verId');
          verificationId = verId;
          if (!completer.isCompleted) completer.complete();
        },
        onError: (error) {
          print('❌ [LOGIN] Erreur lors de l\'envoi OTP: $error');
          errorMessage = error;
          if (!completer.isCompleted) completer.complete();
        },
      );

      // Attendre que le callback soit appelé (avec un timeout de 30 secondes)
      try {
        await completer.future.timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            print('⏱️ [LOGIN] Timeout de 30s atteint sans réponse de Firebase');
            errorMessage = 'Délai d\'attente dépassé. Veuillez réessayer.';
          },
        );
      } catch (e) {
        print('⚠️ [LOGIN] Exception lors de l\'attente: $e');
        errorMessage = 'Erreur inattendue: $e';
      }

      if (!mounted) return;

      // Naviguer vers l'écran OTP seulement si on a le verificationId OU une erreur claire
      if (verificationId != null) {
        print('🚀 [LOGIN] Navigation vers OTP avec verificationId valide');
        context.push(
          '/otp-verification',
          extra: {
            'phone': phoneNumber,
            'verificationId': verificationId,
            'isLogin': true,
          },
        );
      } else {
        // Pas de verificationId, afficher l'erreur et rester sur login
        print('❌ [LOGIN] Pas de verificationId, affichage erreur');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? 'Impossible d\'envoyer le code. Vérifiez votre connexion internet.'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Réessayer',
              textColor: AppColors.white,
              onPressed: _handleLogin,
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ [LOGIN] Exception générale: $e');
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

  void _showAccountNotFoundDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.primaryPurple,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Compte introuvable'),
          ],
        ),
        content: const Text(
          'Ce numéro de téléphone n\'est associé à aucun compte. '
          'Veuillez créer un compte pour continuer.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/register');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Créer un compte',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Logo
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'lib/assets/images/logo.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Welcome Text
              Text(
                'Bienvenue !',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Entrez votre numéro de téléphone',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _phoneController,
                      label: AppStrings.phone,
                      hintText: '+243 XXX XXX XXX',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre numéro de téléphone';
                        }
                        if (value.length < 8) {
                          return 'Numéro de téléphone invalide';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return CustomButton(
                          text: 'Recevoir le code',
                          onPressed:
                              authProvider.isLoading ? null : _handleLogin,
                          isLoading: authProvider.isLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pas encore de compte ? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: Text(
                      AppStrings.createAccount,
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Skip Game Option
              TextButton(
                onPressed: () {
                  // TODO: Implement classic login option
                },
                child: Text(
                  "Connexion chaffeur",
                  style: TextStyle(
                    color: AppColors.textHint,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
