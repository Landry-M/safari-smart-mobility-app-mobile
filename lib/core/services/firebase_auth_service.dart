import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Send OTP to phone number
  Future<bool> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    Function(PhoneAuthCredential credential)? onAutoVerification,
  }) async {
    try {
      print('🟦 [FirebaseAuthService] Starting verifyPhoneNumber for: $phoneNumber');
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('🟢 [FirebaseAuthService] verificationCompleted - smsCode: ${credential.smsCode}');
          if (onAutoVerification != null) {
            onAutoVerification(credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('🔴 [FirebaseAuthService] verificationFailed - code: ${e.code}, message: ${e.message}');
          String errorMessage = _getErrorMessage(e);
          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('🟢 [FirebaseAuthService] codeSent - verificationId: $verificationId, resendToken: $resendToken');
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('🟡 [FirebaseAuthService] codeAutoRetrievalTimeout - verificationId: $verificationId');
          _verificationId = verificationId;
        },
        forceResendingToken: _resendToken,
      );
      
      print('🟦 [FirebaseAuthService] verifyPhoneNumber method returned');
      return true;
    } catch (e) {
      print('🔴 [FirebaseAuthService] Exception in sendOTP: $e');
      onError('Erreur lors de l\'envoi du code: $e');
      return false;
    }
  }

  /// Verify OTP code
  Future<UserCredential?> verifyOTP({
    required String otpCode,
    String? verificationId,
  }) async {
    try {
      // Use provided verificationId first, then fallback to stored one
      String? vId = verificationId;
      if (vId == null || vId.isEmpty) {
        vId = _verificationId;
      }
      
      if (vId == null || vId.isEmpty) {
        throw Exception('ID de vérification manquant. Veuillez renvoyer le code OTP.');
      }

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: vId,
        smsCode: otpCode,
      );

      if (kDebugMode) {
        print('Attempting to sign in with credential...');
      }

      UserCredential? userCredential;

      // Attempt sign in with better error handling for Pigeon type cast issues
      try {
        userCredential = await _auth.signInWithCredential(credential);
      } catch (credentialError) {
        if (kDebugMode) {
          print('Credential sign-in error: $credentialError');
        }

        // Check if user is already signed in after the error (some versions have this bug)
        if (_auth.currentUser != null) {
          if (kDebugMode) {
            print('User already signed in despite error, proceeding...');
          }
          // Create a mock UserCredential-like response
          return null; // Will be handled in auth_provider
        }

        rethrow;
      }

      if (kDebugMode) {
        print(
            'OTP verification successful for user: ${userCredential.user?.uid}');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('OTP verification failed: ${e.message}');
      }
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying OTP: $e');
      }

      // Special handling for Pigeon type cast error
      if (e.toString().contains('PigeonUserDetails') ||
          e.toString().contains('is not a subtype')) {
        // Check if user is actually signed in
        if (_auth.currentUser != null) {
          if (kDebugMode) {
            print('Type cast error but user is signed in, treating as success');
          }
          return null; // Will be handled as success in auth_provider
        }
      }

      throw Exception('Erreur lors de la vérification: $e');
    }
  }

  /// Resend OTP
  Future<bool> resendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    return await sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _verificationId = null;
      _resendToken = null;
      if (kDebugMode) {
        print('User signed out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      throw Exception('Erreur lors de la déconnexion: $e');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        _verificationId = null;
        _resendToken = null;
        if (kDebugMode) {
          print('User account deleted successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting account: $e');
      }
      throw Exception('Erreur lors de la suppression du compte: $e');
    }
  }

  /// Get user phone number
  String? getUserPhoneNumber() {
    return _auth.currentUser?.phoneNumber;
  }

  /// Get user UID
  String? getUserUID() {
    return _auth.currentUser?.uid;
  }

  /// Get ID token
  Future<String?> getIdToken() async {
    try {
      return await _auth.currentUser?.getIdToken();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting ID token: $e');
      }
      return null;
    }
  }

  /// Refresh ID token
  Future<String?> refreshIdToken() async {
    try {
      return await _auth.currentUser?.getIdToken(true);
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing ID token: $e');
      }
      return null;
    }
  }

  /// Convert Firebase Auth errors to user-friendly messages
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Le numéro de téléphone n\'est pas valide.';
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard.';
      case 'invalid-verification-code':
        return 'Le code de vérification est invalide.';
      case 'invalid-verification-id':
        return 'L\'ID de vérification est invalide.';
      case 'code-expired':
        return 'Le code de vérification a expiré.';
      case 'missing-verification-code':
        return 'Veuillez entrer le code de vérification.';
      case 'missing-verification-id':
        return 'ID de vérification manquant.';
      case 'quota-exceeded':
        return 'Quota SMS dépassé. Veuillez réessayer plus tard.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'operation-not-allowed':
        return 'L\'authentification par téléphone n\'est pas activée.';
      case 'network-request-failed':
        return 'Erreur de connexion. Vérifiez votre connexion internet.';
      default:
        return e.message ??
            'Une erreur s\'est produite lors de l\'authentification.';
    }
  }

  /// Format phone number for Firebase (add country code if needed)
  String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // If it doesn't start with +, assume it's a RDC Congo number
    if (!cleaned.startsWith('+')) {
      // Remove leading 0 if present
      if (cleaned.startsWith('0')) {
        cleaned = cleaned.substring(1);
      }
      // Add RDC Congo country code
      cleaned = '+243$cleaned';
    }

    return cleaned;
  }

  /// Validate phone number format
  bool isValidPhoneNumber(String phoneNumber) {
    final String formatted = formatPhoneNumber(phoneNumber);
    // Basic validation for international format
    final RegExp phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(formatted);
  }
}
