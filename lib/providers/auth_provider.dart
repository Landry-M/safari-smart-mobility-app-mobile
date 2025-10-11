import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../core/services/api_service.dart';
import '../core/services/database_service.dart';
import '../core/services/firebase_auth_service.dart';
import '../core/services/firestore_service.dart';
import '../data/models/user_model.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  AuthState _state = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated =>
      _state == AuthState.authenticated && _currentUser != null;

  // Simplified initialize method for testing
  Future<void> initialize() async {
    _isLoading = true;

    // Defer the initial notifyListeners to avoid build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      // Check if user is already logged in locally first
      final token = await _secureStorage.read(key: 'access_token');
      final refreshToken = await _secureStorage.read(key: 'refresh_token');

      if (token != null && refreshToken != null) {
        // Try to load user from local database first
        try {
          final localUser = await _databaseService.getCurrentUser();
          if (localUser != null) {
            _currentUser = localUser;
            _setState(AuthState.authenticated);
            return;
          }
        } catch (e) {
          // Continue if local fails
        }
      }

      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setState(AuthState.unauthenticated);
    }
  }

  // Simplified Firebase auth state check
  Future<bool> checkFirebaseAuthState() async {
    try {
      final isFirebaseSignedIn = _firebaseAuth.isSignedIn;

      if (isFirebaseSignedIn) {
        // Check if we have local user data
        final localUser = await _databaseService.getCurrentUser();
        if (localUser != null) {
          _currentUser = localUser;
          _setState(AuthState.authenticated);
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Login with phone and password
  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final response = await _apiService.login(
        phone: phone,
        password: password,
      );

      if (response['user'] != null) {
        final user = User.fromJson(response['user']);
        user.token = response['token'];
        user.refreshToken = response['refreshToken'];

        await _saveUserLocally(user);
        _currentUser = user;
        _setState(AuthState.authenticated);
        return true;
      } else {
        _setError('Données utilisateur manquantes');
        return false;
      }
    } catch (e) {
      _setError('Erreur de connexion: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String phone,
    String? email,
    required String password,
    TravelPurpose? travelPurpose,
    bool autoRecharge = false,
    Map<String, dynamic>? additionalData,
  }) async {
    _setLoading(true);

    try {
      final data = {
        'travelPurpose': travelPurpose?.name,
        'autoRecharge': autoRecharge,
        ...?additionalData,
      };

      final response = await _apiService.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
        additionalData: data,
      );

      if (response['success'] == true) {
        return true;
      } else {
        _setError(response['message'] ?? 'Erreur d\'inscription');
        return false;
      }
    } catch (e) {
      _setError('Erreur d\'inscription: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Send OTP
  Future<bool> sendOtp({required String phone}) async {
    _setLoading(true);

    try {
      final response = await _apiService.sendOtp(phone: phone);

      if (response['success'] == true) {
        return true;
      } else {
        _setError(response['message'] ?? 'Erreur d\'envoi OTP');
        return false;
      }
    } catch (e) {
      _setError('Erreur d\'envoi OTP: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP
  Future<bool> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    _setLoading(true);

    try {
      final response = await _apiService.verifyOtp(
        phone: phone,
        otp: otp,
      );

      if (response['user'] != null) {
        final user = User.fromJson(response['user']);
        user.token = response['token'];
        user.refreshToken = response['refreshToken'];

        await _saveUserLocally(user);
        _currentUser = user;
        _setState(AuthState.authenticated);
        return true;
      } else {
        _setError(response['message'] ?? 'Code OTP invalide');
        return false;
      }
    } catch (e) {
      _setError('Erreur de vérification OTP: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _apiService.logout();
    } catch (e) {
      // Continue with logout even if API call fails
    }

    try {
      await _databaseService.clearUsers();
    } catch (e) {
      // Continue with logout even if local clear fails
    }

    _currentUser = null;
    _setState(AuthState.unauthenticated);
    _setLoading(false);
  }

  // Firebase Phone Authentication Methods (simplified)

  /// Send OTP via Firebase
  Future<void> sendFirebaseOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    print('🔵 [AuthProvider] sendFirebaseOTP called with phone: $phoneNumber');
    _setLoading(true);

    try {
      final formattedPhone = _firebaseAuth.formatPhoneNumber(phoneNumber);
      print('🔵 [AuthProvider] Formatted phone: $formattedPhone');

      if (!_firebaseAuth.isValidPhoneNumber(formattedPhone)) {
        print('🔴 [AuthProvider] Invalid phone number');
        _setLoading(false);
        onError('Numéro de téléphone invalide');
        return;
      }

      print('🔵 [AuthProvider] Calling FirebaseAuthService.sendOTP...');
      await _firebaseAuth.sendOTP(
        phoneNumber: formattedPhone,
        onCodeSent: (verificationId) {
          print('🟢 [AuthProvider] onCodeSent callback - verificationId: $verificationId');
          _setLoading(false);
          onCodeSent(verificationId);
        },
        onError: (error) {
          print('🔴 [AuthProvider] onError callback - error: $error');
          _setLoading(false);
          onError(error);
        },
        onAutoVerification: (credential) async {
          print('🟡 [AuthProvider] onAutoVerification callback');
          // Auto verification completed - simplified
          _setLoading(false);
        },
      );
      print('🔵 [AuthProvider] sendOTP method completed');
    } catch (e) {
      print('🔴 [AuthProvider] Exception caught: $e');
      _setLoading(false);
      onError('Erreur lors de l\'envoi du code: $e');
    }
  }

  /// Verify OTP via Firebase and save user data to Firestore
  Future<bool> verifyFirebaseOTP({
    required String otpCode,
    String? verificationId,
    Map<String, dynamic>? userData,
  }) async {
    _setLoading(true);

    try {
      // Validate verificationId is not null or empty
      if (verificationId == null || verificationId.isEmpty) {
        _setError('ID de vérification manquant');
        return false;
      }

      final userCredential = await _firebaseAuth.verifyOTP(
        otpCode: otpCode,
        verificationId: verificationId,
      );

      // Handle both successful credential and fallback case (when userCredential is null but user is signed in)
      final firebaseUser = userCredential?.user ?? _firebaseAuth.currentUser;
      
      if (firebaseUser != null) {
        final uid = firebaseUser.uid;
        final firebasePhone = firebaseUser.phoneNumber ?? '';

        // Si c'est une nouvelle inscription avec userData
        if (userData != null) {
          // Ensure required fields are not null
          final userName = userData['name']?.toString() ?? '';
          // Use Firebase phone number (already formatted) instead of user input
          final userPhone = firebasePhone.isNotEmpty ? firebasePhone : userData['phone']?.toString() ?? '';
          final userEmail = userData['email']?.toString();
          
          if (userName.isEmpty) {
            _setError('Nom d\'utilisateur requis');
            return false;
          }
          
          if (userPhone.isEmpty) {
            _setError('Numéro de téléphone requis');
            return false;
          }

          // Créer l'utilisateur dans Firestore avec le numéro formaté
          await _firestoreService.createUser(
            uid: uid,
            name: userName,
            phone: userPhone,
            email: userEmail,
            role: UserRole.passenger,
            additionalData: {
              'firebaseUid': uid,
            },
          );

          // Créer l'utilisateur local avec les données Firestore
          final localUser = User(
            userId: uid,
            name: userName,
            phone: userPhone,
            email: userEmail ?? '',
            role: UserRole.passenger,
            balance: 0.0,
            badges: [],
          );

          await _saveUserLocally(localUser);
          _currentUser = localUser;
        } else {
          // Si c'est une connexion, récupérer les données depuis Firestore
          final firestoreData = await _firestoreService.getUser(uid);

          if (firestoreData != null) {
            final userName = firestoreData['name']?.toString() ?? '';
            final userPhone = firestoreData['phone']?.toString() ?? firebasePhone;
            final userEmail = firestoreData['email']?.toString() ?? '';
            final userRole = firestoreData['role']?.toString();
            final userBalance = firestoreData['balance'];
            final userBadges = firestoreData['badges'];
            
            final localUser = User(
              userId: uid,
              name: userName,
              phone: userPhone,
              email: userEmail,
              role: userRole != null 
                  ? UserRole.values.firstWhere(
                      (e) => e.name == userRole,
                      orElse: () => UserRole.passenger,
                    )
                  : UserRole.passenger,
              balance: userBalance != null ? userBalance.toDouble() : 0.0,
              badges: userBadges != null ? List<String>.from(userBadges) : [],
            );

            await _saveUserLocally(localUser);
            _currentUser = localUser;
          } else {
            _setError('Utilisateur non trouvé dans Firestore');
            return false;
          }
        }

        _setState(AuthState.authenticated);
        return true;
      } else {
        _setError('Échec de la vérification OTP');
        return false;
      }
    } catch (e) {
      _setError('Erreur lors de la vérification: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Check if user is signed in with Firebase
  bool get isFirebaseSignedIn => _firebaseAuth.isSignedIn;

  /// Get Firebase user phone number
  String? get firebasePhoneNumber => _firebaseAuth.getUserPhoneNumber();

  /// Get Firebase user UID
  String? get firebaseUID => _firebaseAuth.getUserUID();

  /// Check if phone number exists in Firestore
  Future<Map<String, dynamic>?> checkPhoneExists(String phone) async {
    try {
      print('🔵 [AuthProvider] checkPhoneExists - Numéro reçu: $phone');
      
      // Format the phone number before checking
      final formattedPhone = _firebaseAuth.formatPhoneNumber(phone);
      print('🔵 [AuthProvider] checkPhoneExists - Numéro formaté: $formattedPhone');
      
      final result = await _firestoreService.getUserByPhone(formattedPhone);
      print('🔵 [AuthProvider] checkPhoneExists - Résultat: ${result != null ? "Utilisateur trouvé" : "Aucun utilisateur"}');
      
      return result;
    } catch (e) {
      print('🔴 [AuthProvider] Error checking phone exists: $e');
      return null;
    }
  }

  /// Resend OTP via Firebase
  Future<void> resendFirebaseOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await sendFirebaseOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }

  // Add badge to user
  Future<void> addBadge(String badge) async {
    if (_currentUser == null) return;

    final updatedBadges = List<String>.from(_currentUser!.badges);
    if (!updatedBadges.contains(badge)) {
      updatedBadges.add(badge);

      final updatedUser = _currentUser!.copyWith(badges: updatedBadges);
      await _saveUserLocally(updatedUser);

      // Synchroniser avec Firestore
      try {
        final uid = _currentUser!.userId;
        await _firestoreService.addBadge(uid: uid, badge: badge);
      } catch (e) {
        // Continue même si la synchro Firestore échoue
      }

      _currentUser = updatedUser;
      notifyListeners();
    }
  }

  // Update balance
  Future<void> updateBalance(double newBalance) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(balance: newBalance);
    await _saveUserLocally(updatedUser);

    // Synchroniser avec Firestore
    try {
      final uid = _currentUser!.userId;
      await _firestoreService.updateBalance(uid: uid, newBalance: newBalance);
    } catch (e) {
      // Continue même si la synchro Firestore échoue
    }

    _currentUser = updatedUser;
    notifyListeners();
  }

  // Update user
  Future<void> updateUser(User updatedUser) async {
    await _saveUserLocally(updatedUser);

    // Synchroniser avec Firestore
    try {
      final uid = updatedUser.userId;
      await _firestoreService.updateUser(
        uid: uid,
        data: updatedUser.toJson(),
      );
    } catch (e) {
      // Continue même si la synchro Firestore échoue
      print('Error syncing user to Firestore: $e');
    }

    _currentUser = updatedUser;
    notifyListeners();
  }

  // Save user locally
  Future<void> _saveUserLocally(User user) async {
    await _databaseService.saveUser(user);
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String error) {
    _errorMessage = error;
    _state = AuthState.error;
    _isLoading = false;
    notifyListeners();
  }

  // Set auth state
  void _setState(AuthState newState) {
    _state = newState;
    _errorMessage = null;
    _isLoading = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = _currentUser != null
          ? AuthState.authenticated
          : AuthState.unauthenticated;
    }
    notifyListeners();
  }

  // Check if user has specific role
  bool hasRole(UserRole role) {
    return _currentUser?.role == role;
  }

  // Check if user has badge
  bool hasBadge(String badge) {
    return _currentUser?.badges.contains(badge) ?? false;
  }
}
