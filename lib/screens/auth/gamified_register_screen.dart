import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

enum FieldType { name, phone, email, location, terms }

class RegistrationStep {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String encouragement;
  final FieldType field;

  RegistrationStep({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.encouragement,
    required this.field,
  });
}

class GamifiedRegisterScreen extends StatefulWidget {
  const GamifiedRegisterScreen({super.key});

  @override
  State<GamifiedRegisterScreen> createState() => _GamifiedRegisterScreenState();
}

class _GamifiedRegisterScreenState extends State<GamifiedRegisterScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _locationGranted = false;
  bool _acceptTerms = false;

  // Gamification data
  final List<RegistrationStep> _steps = [
    RegistrationStep(
      title: "Bienvenue dans l'aventure Safari !",
      subtitle: "Commençons par faire connaissance",
      description:
          "Votre nom nous aide à personnaliser votre expérience et à vous identifier lors de vos voyages.",
      icon: Icons.person_add,
      encouragement: "C'est parti pour un tour !",
      field: FieldType.name,
    ),
    RegistrationStep(
      title: "Votre numéro 📱",
      subtitle: "Restons connectés !",
      description:
          "Votre numéro de téléphone nous permet de vous envoyer des notifications importantes et de sécuriser votre compte.",
      icon: Icons.phone,
      encouragement: "Parfait ! Vous progressez bien !",
      field: FieldType.phone,
    ),
    RegistrationStep(
      title: "Votre adresse email ✉️",
      subtitle: "Pour ne rien manquer ! (Optionnel)",
      description:
          "Votre email nous permet de vous tenir informé des nouveautés et de récupérer votre compte si besoin. Cette étape est optionnelle.",
      icon: Icons.email,
      encouragement: "Excellent ! Plus que quelques étapes !",
      field: FieldType.email,
    ),
    RegistrationStep(
      title: "Activez la localisation 📍",
      subtitle: "Pour une expérience optimale",
      description:
          "La localisation nous permet de vous montrer les bus les plus proches, d'estimer vos temps de trajet et de vous guider vers votre destination. Vos données restent privées et sécurisées.",
      icon: Icons.location_on,
      encouragement: "Parfait ! Vous êtes prêt à découvrir les bus autour de vous !",
      field: FieldType.location,
    ),
    RegistrationStep(
      title: "Dernière étape ! 🏁",
      subtitle: "Acceptez nos conditions",
      description:
          "En acceptant nos conditions, vous rejoignez officiellement la communauté Safari Smart Mobility !",
      icon: Icons.check_circle,
      encouragement: "Félicitations ! Vous êtes prêt à voyager !",
      field: FieldType.terms,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _progressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _animateProgress();
        _playStepAnimation();
      } else {
        _handleRegister();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animateProgress();
      _playStepAnimation();
    }
  }

  void _playStepAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  void _animateProgress() {
    _progressController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _progressController.reset();
    });
  }

  bool _validateCurrentStep() {
    switch (_steps[_currentStep].field) {
      case FieldType.name:
        if (_nameController.text.trim().isEmpty) {
          _showErrorMessage("Veuillez entrer votre nom");
          return false;
        }
        break;
      case FieldType.phone:
        if (_phoneController.text.trim().isEmpty) {
          _showErrorMessage("Veuillez entrer votre numéro de téléphone");
          return false;
        }
        break;
      case FieldType.email:
        // Email is optional, but if provided, it must be valid
        if (_emailController.text.trim().isNotEmpty &&
            !_emailController.text.contains('@')) {
          _showErrorMessage("Veuillez entrer une adresse email valide");
          return false;
        }
        break;
      case FieldType.location:
        if (!_locationGranted) {
          _showErrorMessage("Veuillez autoriser l'accès à la localisation");
          return false;
        }
        break;
      case FieldType.terms:
        if (!_acceptTerms) {
          _showErrorMessage("Veuillez accepter les conditions d'utilisation");
          return false;
        }
        break;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleRegister() async {
    final authProvider = context.read<AuthProvider>();

    // Store user data temporarily for later registration after OTP verification
    final userData = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      'locationEnabled': _locationGranted,
    };

    String? receivedVerificationId;
    String? errorMessage;

    // Use a Completer to wait for the callback to be called
    final completer = Completer<void>();

    // Send Firebase OTP for phone verification
    await authProvider.sendFirebaseOTP(
      phoneNumber: _phoneController.text.trim(),
      onCodeSent: (verificationId) {
        print('🟢 Code sent callback - verificationId: $verificationId');
        receivedVerificationId = verificationId;
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      onError: (error) {
        print('🔴 Error callback - error: $error');
        errorMessage = error;
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    print('⏳ Waiting for callback...');
    
    // Wait for the callback to be called or timeout after 30 seconds
    try {
      await completer.future.timeout(const Duration(seconds: 30));
      print('✅ Callback received!');
    } catch (e) {
      print('⏰ Timeout error: $e');
      errorMessage = 'Timeout lors de l\'envoi du code OTP';
    }

    print('📋 receivedVerificationId: $receivedVerificationId');
    print('📋 errorMessage: $errorMessage');

    // Check if mounted before navigation
    if (!mounted) return;

    // Navigate to OTP screen with the result
    context.go('/otp-verification', extra: {
      'phone': _phoneController.text.trim(),
      'verificationId': receivedVerificationId,
      'userData': userData,
      'initialError': errorMessage, // Pass error to display
    });
  }

  Future<void> _requestLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        final result = await Geolocator.requestPermission();
        
        if (result == LocationPermission.whileInUse ||
            result == LocationPermission.always) {
          setState(() {
            _locationGranted = true;
          });
          
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '✅ Localisation activée avec succès !',
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          _showErrorMessage(
            'Permission refusée. Vous pouvez l\'activer plus tard dans les paramètres.',
          );
        }
      } else if (permission == LocationPermission.deniedForever) {
        _showErrorMessage(
          'Veuillez activer la localisation dans les paramètres de votre appareil.',
        );
      } else {
        setState(() {
          _locationGranted = true;
        });
      }
    } catch (e) {
      _showErrorMessage('Erreur lors de la demande de permission: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryPurple,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () =>
              _currentStep > 0 ? _previousStep() : context.go('/login'),
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/login'),
            child: Text(
              'Connexion',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          _buildProgressBar(),

          // Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _totalSteps,
              itemBuilder: (context, index) {
                return _buildStepContent(_steps[index]);
              },
            ),
          ),

          // Bottom navigation
          _buildBottomNavigation(),
        ],
      ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Étape ${_currentStep + 1} sur $_totalSteps',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: AppColors.lightGrey,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(RegistrationStep step) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.bottom -
                  200, // Space for progress bar and bottom navigation
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and title
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        step.icon,
                        size: 40,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    step.subtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    step.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),

                  const SizedBox(height: 32),

                  // Form field based on step
                  _buildStepField(step.field),

                  const SizedBox(height: 24),

                  // Encouragement message
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
                          Icons.lightbulb,
                          color: AppColors.primaryPurple,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            step.encouragement,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepField(FieldType fieldType) {
    switch (fieldType) {
      case FieldType.name:
        return CustomTextField(
          controller: _nameController,
          label: 'Votre nom complet',
          hintText: 'Ex: Jean Dupont',
          prefixIcon: Icons.person,
        );

      case FieldType.phone:
        return CustomTextField(
          controller: _phoneController,
          label: 'Numéro de téléphone',
          hintText: 'Ex: +243 81 02 03 045',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
        );

      case FieldType.email:
        return CustomTextField(
          controller: _emailController,
          label: 'Adresse email (optionnel)',
          hintText: 'Ex: jean.dupont@email.com',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        );

      case FieldType.location:
        return _buildLocationPermissionCard();

      case FieldType.terms:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.security,
                    size: 48,
                    color: AppColors.primaryPurple,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Vos données sont protégées',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nous respectons votre vie privée et sécurisons toutes vos informations personnelles.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CheckboxListTile(
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
              title: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'J\'accepte les '),
                    TextSpan(
                      text: 'conditions d\'utilisation',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' et la '),
                    TextSpan(
                      text: 'politique de confidentialité',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              activeColor: AppColors.primaryPurple,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        );
    }
  }

  Widget _buildLocationPermissionCard() {
    return Column(
      children: [
        // Illustration card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryPurple.withOpacity(0.1),
                AppColors.info.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryPurple.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // Icon avec animation
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  size: 50,
                  color: AppColors.primaryPurple,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Pourquoi avons-nous besoin de votre position ?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Features list
              _buildFeatureItem(
                icon: Icons.directions_bus,
                title: 'Bus à proximité',
                description: 'Trouvez les bus les plus proches de vous en temps réel',
              ),
              
              const SizedBox(height: 12),
              
              _buildFeatureItem(
                icon: Icons.navigation,
                title: 'Navigation intelligente',
                description: 'Recevez des itinéraires optimisés pour vos trajets',
              ),
              
              const SizedBox(height: 12),
              
              _buildFeatureItem(
                icon: Icons.access_time,
                title: 'Temps de trajet',
                description: 'Connaissez la durée estimée de vos déplacements',
              ),
              
              const SizedBox(height: 20),
              
              // Privacy note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Vos données de localisation sont cryptées et ne sont jamais partagées avec des tiers',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Permission button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _locationGranted 
                ? AppColors.success.withOpacity(0.1)
                : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _locationGranted 
                  ? AppColors.success
                  : AppColors.grey,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              if (_locationGranted)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Localisation activée !',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: _requestLocationPermission,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Autoriser la localisation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: CustomButton(
                  text: 'Précédent',
                  onPressed: _previousStep,
                  isOutlined: true,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.primaryPurple,
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: _currentStep == 0 ? 1 : 2,
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return CustomButton(
                    text: _currentStep == _totalSteps - 1
                        ? 'Créer mon compte'
                        : 'Continuer',
                    onPressed: authProvider.isLoading ? null : _nextStep,
                    isLoading: authProvider.isLoading,
                    backgroundColor: AppColors.primaryPurple,
                    textColor: AppColors.white,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
