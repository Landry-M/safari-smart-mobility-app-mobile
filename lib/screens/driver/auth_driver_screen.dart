import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/driver_session_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AuthDriverScreen extends StatefulWidget {
  const AuthDriverScreen({super.key});

  @override
  State<AuthDriverScreen> createState() => _AuthDriverScreenState();
}

class _AuthDriverScreenState extends State<AuthDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Contrôleurs pour chaque étape
  final _chauffeurMatriculeController = TextEditingController();
  final _chauffeurPasswordController = TextEditingController();
  final _receveurMatriculeController = TextEditingController();
  final _receveurPasswordController = TextEditingController();
  final _collecteurMatriculeController = TextEditingController();
  final _collecteurPasswordController = TextEditingController();

  bool _isLoading = false;

  // Identifiants fictifs pour les tests
  final Map<String, Map<String, String>> _credentials = {
    'chauffeur': {
      'matricule': 'CH001',
      'password': '123456',
    },
    'receveur': {
      'matricule': 'RC001',
      'password': '654321',
    },
    'collecteur': {
      'matricule': 'CL001',
      'password': '111111',
    },
  };

  @override
  void dispose() {
    _chauffeurMatriculeController.dispose();
    _chauffeurPasswordController.dispose();
    _receveurMatriculeController.dispose();
    _receveurPasswordController.dispose();
    _collecteurMatriculeController.dispose();
    _collecteurPasswordController.dispose();
    super.dispose();
  }

  Future<void> _validateStep() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simuler un délai de validation
    await Future.delayed(const Duration(seconds: 1));

    String matricule = '';
    String password = '';
    String role = '';

    // Déterminer quel étape nous sommes
    switch (_currentStep) {
      case 0:
        matricule = _chauffeurMatriculeController.text.trim();
        password = _chauffeurPasswordController.text.trim();
        role = 'chauffeur';
        break;
      case 1:
        matricule = _receveurMatriculeController.text.trim();
        password = _receveurPasswordController.text.trim();
        role = 'receveur';
        break;
      case 2:
        matricule = _collecteurMatriculeController.text.trim();
        password = _collecteurPasswordController.text.trim();
        role = 'collecteur';
        break;
    }

    // Valider les identifiants
    if (matricule == _credentials[role]!['matricule'] &&
        password == _credentials[role]!['password']) {
      setState(() => _isLoading = false);

      // Si c'est la dernière étape, sauvegarder la session et naviguer vers home_driver
      if (_currentStep == 2) {
        // Sauvegarder la session chauffeur
        final sessionService = DriverSessionService();
        await sessionService.saveDriverSession(
          chauffeurMatricule: _chauffeurMatriculeController.text.trim(),
          receveurMatricule: _receveurMatriculeController.text.trim(),
          collecteurMatricule: _collecteurMatriculeController.text.trim(),
        );

        if (mounted) {
          context.go('/driver-home');
        }
      } else {
        // Sinon, passer à l'étape suivante
        setState(() {
          _currentStep++;
          _formKey.currentState!.reset();
        });
      }
    } else {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Identifiants incorrects pour le $role'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildStepContent() {
    final stepData = [
      {
        'title': 'Authentification Chauffeur',
        'icon': Icons.person_outline,
        'matriculeController': _chauffeurMatriculeController,
        'passwordController': _chauffeurPasswordController,
        'matriculeHint': 'Ex: CH001',
      },
      {
        'title': 'Authentification Receveur',
        'icon': Icons.account_circle_outlined,
        'matriculeController': _receveurMatriculeController,
        'passwordController': _receveurPasswordController,
        'matriculeHint': 'Ex: RC001',
      },
      {
        'title': 'Authentification Collecteur',
        'icon': Icons.badge_outlined,
        'matriculeController': _collecteurMatriculeController,
        'passwordController': _collecteurPasswordController,
        'matriculeHint': 'Ex: CL001',
      },
    ];

    final data = stepData[_currentStep];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icône et titre
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                data['icon'] as IconData,
                size: 64,
                color: AppColors.primaryPurple,
              ),
              const SizedBox(height: 16),
              Text(
                data['title'] as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Étape ${_currentStep + 1} sur 3',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Formulaire
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller:
                    data['matriculeController'] as TextEditingController,
                label: 'Matricule',
                hintText: data['matriculeHint'] as String,
                prefixIcon: Icons.badge,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le matricule';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: data['passwordController'] as TextEditingController,
                label: 'Mot de passe',
                hintText: '6 chiffres',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le mot de passe';
                  }
                  if (value.length != 6) {
                    return 'Le mot de passe doit contenir 6 chiffres';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Bouton de validation
        CustomButton(
          text: _currentStep == 2 ? 'Terminer' : 'Suivant',
          onPressed: _isLoading ? null : _validateStep,
          isLoading: _isLoading,
        ),

        if (_currentStep > 0) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    setState(() {
                      _currentStep--;
                      _formKey.currentState!.reset();
                    });
                  },
            child: const Text(
              'Retour',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Connexion Équipe',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Indicateur de progression
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < 2 ? 8 : 0,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? AppColors.primaryPurple
                            : AppColors.primaryPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Contenu de l'étape
              _buildStepContent(),
            ],
          ),
        ),
      ),
    );
  }
}
