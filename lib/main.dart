import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safari_smart_mobility/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/services/database_service.dart';
import 'providers/auth_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/gamified_register_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/tickets/ticket_purchase_screen.dart';
import 'screens/tickets/ticket_confirmation_screen.dart';
import 'screens/scanner/qr_scanner_screen.dart';
import 'screens/map/nearby_buses_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize database
  await DatabaseService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Créer le routeur une seule fois
    _router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const GamifiedRegisterScreen(),
        ),
        GoRoute(
          path: '/otp-verification',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final phone =
                extra?['phone'] ?? state.uri.queryParameters['phone'] ?? '';
            final verificationId = extra?['verificationId'];
            final userData = extra?['userData'] as Map<String, dynamic>?;
            final initialError = extra?['initialError'] as String?;
            final isLogin = extra?['isLogin'] as bool? ?? false;
            return OtpVerificationScreen(
              phone: phone,
              verificationId: verificationId,
              userData: userData,
              initialError: initialError,
              isLogin: isLogin,
            );
          },
        ),
        GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'nearby-buses',
                name: 'nearby-buses',
                builder: (context, state) => const NearbyBusesScreen(),
              ),
            ]),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/buy-ticket',
          builder: (context, state) => const TicketPurchaseScreen(),
        ),
        GoRoute(
          path: '/ticket-confirmation',
          builder: (context, state) {
            final ticketData = state.extra as Map<String, dynamic>;
            return TicketConfirmationScreen(ticketData: ticketData);
          },
        ),
        GoRoute(
          path: '/scanner',
          builder: (context, state) => const QRScannerScreen(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here as needed
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
