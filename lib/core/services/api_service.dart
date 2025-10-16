import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_strings.dart';

class ApiService {
  static const String _baseUrl = 'https://apiv2.hakika.events'; // À remplacer par l'URL réelle
  static const String _mysqlApiUrl = 'https://apiv2.hakika.events'; // URL de l'API MySQL
  static const String _storageKeyToken = 'auth_token';
  static const String _storageKeyRefreshToken = 'refresh_token';
  
  late final Dio _dio;
  late final FlutterSecureStorage _storage;
  
  ApiService() {
    _storage = const FlutterSecureStorage();
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Request interceptor to add auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: _storageKeyToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle token refresh on 401 error
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the original request
            final options = error.requestOptions;
            final token = await _storage.read(key: _storageKeyToken);
            options.headers['Authorization'] = 'Bearer $token';
            
            try {
              final response = await _dio.fetch(options);
              handler.resolve(response);
              return;
            } catch (e) {
              // If retry fails, continue with original error
            }
          }
        }
        handler.next(error);
      },
    ));
    
    // Logging interceptor (only in debug mode)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) {
        // Only log in debug mode
        // print(object);
      },
    ));
  }
  
  // Authentication endpoints
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });
      
      if (response.data['token'] != null) {
        await _storage.write(key: _storageKeyToken, value: response.data['token']);
        if (response.data['refreshToken'] != null) {
          await _storage.write(key: _storageKeyRefreshToken, value: response.data['refreshToken']);
        }
      }
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    String? email,
    required String password,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final data = {
        'name': name,
        'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
        'password': password,
        ...?additionalData,
      };
      
      final response = await _dio.post('/auth/register', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> sendOtp({required String phone}) async {
    try {
      final response = await _dio.post('/auth/send-otp', data: {
        'phone': phone,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'phone': phone,
        'otp': otp,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Verify Firebase token
  Future<Map<String, dynamic>> verifyFirebaseToken({
    required String idToken,
    String? phoneNumber,
  }) async {
    try {
      final data = {
        'idToken': idToken,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      };
      
      final response = await _dio.post('/auth/verify-firebase', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      await _storage.delete(key: _storageKeyToken);
      await _storage.delete(key: _storageKeyRefreshToken);
    }
  }
  
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: _storageKeyRefreshToken);
      if (refreshToken == null) return false;
      
      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      
      if (response.data['token'] != null) {
        await _storage.write(key: _storageKeyToken, value: response.data['token']);
        return true;
      }
      return false;
    } catch (e) {
      await _storage.delete(key: _storageKeyToken);
      await _storage.delete(key: _storageKeyRefreshToken);
      return false;
    }
  }
  
  // User endpoints
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('/user/profile');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/user/profile', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Ticket endpoints
  Future<Map<String, dynamic>> purchaseTicket({
    required String routeId,
    required String ticketType,
    required double amount,
    required String paymentMethod,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final data = {
        'routeId': routeId,
        'ticketType': ticketType,
        'amount': amount,
        'paymentMethod': paymentMethod,
        ...?additionalData,
      };
      
      final response = await _dio.post('/tickets/purchase', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> validateTicket({
    required String qrCode,
    required String busId,
    Map<String, dynamic>? locationData,
  }) async {
    try {
      final data = {
        'qrCode': qrCode,
        'busId': busId,
        ...?locationData,
      };
      
      final response = await _dio.post('/tickets/validate', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<Map<String, dynamic>>> getUserTickets() async {
    try {
      final response = await _dio.get('/tickets/user');
      return List<Map<String, dynamic>>.from(response.data['tickets'] ?? []);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Bus position endpoints
  Future<Map<String, dynamic>> updateBusPosition({
    required String busId,
    required double latitude,
    required double longitude,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final data = {
        'busId': busId,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
        ...?additionalData,
      };
      
      final response = await _dio.post('/buses/position', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<Map<String, dynamic>>> getNearbyBuses({
    required double latitude,
    required double longitude,
    double radius = 5.0, // km
  }) async {
    try {
      final response = await _dio.get('/buses/nearby', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });
      return List<Map<String, dynamic>>.from(response.data['buses'] ?? []);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Transaction endpoints
  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/transactions', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<Map<String, dynamic>>> getUserTransactions() async {
    try {
      final response = await _dio.get('/transactions/user');
      return List<Map<String, dynamic>>.from(response.data['transactions'] ?? []);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Generic GET request
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Generic POST request
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Generic PUT request
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Generic DELETE request
  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // Error handling
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Délai de connexion dépassé. Vérifiez votre connexion internet.';
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'];
        
        switch (statusCode) {
          case 400:
            return message ?? 'Requête invalide';
          case 401:
            return 'Session expirée. Veuillez vous reconnecter.';
          case 403:
            return 'Accès non autorisé';
          case 404:
            return 'Ressource non trouvée';
          case 500:
            return 'Erreur serveur. Veuillez réessayer plus tard.';
          default:
            return message ?? 'Une erreur est survenue';
        }
      
      case DioExceptionType.cancel:
        return 'Requête annulée';
      
      case DioExceptionType.unknown:
      default:
        return AppStrings.noInternet;
    }
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: _storageKeyToken);
    return token != null;
  }
  
  // Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: _storageKeyToken);
  }

  // Create client in MySQL database
  Future<Map<String, dynamic>> createClientInMySQL({
    required String uid,
    required String telephone,
    String? nom,
    String? prenom,
    String? email,
  }) async {
    try {
      // Créer une instance Dio séparée pour l'API MySQL
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final data = {
        'uid': uid,
        'telephone': telephone,
        if (nom != null) 'nom': nom,
        if (prenom != null) 'prenom': prenom,
        if (email != null) 'email': email,
      };

      final response = await mysqlDio.post('/clients', data: data);
      return response.data;
    } on DioException catch (e) {
      // Log l'erreur mais ne pas bloquer l'inscription si l'API MySQL échoue
      print('Erreur lors de la création du client MySQL: ${e.message}');
      return {
        'success': false,
        'message': 'Erreur MySQL: ${e.message}',
      };
    } catch (e) {
      print('Erreur inattendue lors de la création du client MySQL: $e');
      return {
        'success': false,
        'message': 'Erreur inattendue: $e',
      };
    }
  }

  // Get lignes/trajets for dropdown
  Future<List<Map<String, dynamic>>> getLignes() async {
    try {
      // Créer une instance Dio séparée pour l'API MySQL
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await mysqlDio.get('/trajets/lignes');
      
      if (response.data['success'] == true && response.data['data'] != null) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      
      return [];
    } on DioException catch (e) {
      print('Erreur lors de la récupération des lignes: ${e.message}');
      return [];
    } catch (e) {
      print('Erreur inattendue lors de la récupération des lignes: $e');
      return [];
    }
  }

  // Get bus by ligne affectée
  Future<List<Map<String, dynamic>>> getBusByLigne(String ligneId) async {
    try {
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await mysqlDio.get('/bus/ligne/$ligneId');
      
      if (response.data['success'] == true && response.data['data'] != null) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      
      return [];
    } on DioException catch (e) {
      print('Erreur lors de la récupération des bus: ${e.message}');
      return [];
    } catch (e) {
      print('Erreur inattendue lors de la récupération des bus: $e');
      return [];
    }
  }

  // Get all nearby buses with GPS coordinates
  Future<List<Map<String, dynamic>>> getAllNearbyBuses() async {
    try {
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await mysqlDio.get('/bus/nearby');
      
      if (response.data['success'] == true && response.data['data'] != null) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      
      return [];
    } on DioException catch (e) {
      print('Erreur lors de la récupération des bus à proximité: ${e.message}');
      return [];
    } catch (e) {
      print('Erreur inattendue lors de la récupération des bus à proximité: $e');
      return [];
    }
  }

  // Update client in MySQL database by UID
  Future<Map<String, dynamic>> updateClientInMySQL({
    required String uid,
    required String name,
    required String telephone,
    String? email,
  }) async {
    try {
      // Créer une instance Dio séparée pour l'API MySQL
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      // Extraire nom et prénom du nom complet
      final nameParts = name.split(' ');
      final prenom = nameParts.isNotEmpty ? nameParts.first : name;
      final nom = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Récupérer d'abord l'ID du client via son UID
      final getResponse = await mysqlDio.get('/clients/uid/$uid');
      
      if (getResponse.data['success'] == true && getResponse.data['data'] != null) {
        final clientId = getResponse.data['data']['id'];
        
        // Mettre à jour avec l'ID
        final updateData = {
          'telephone': telephone,
          'nom': nom.isNotEmpty ? nom : null,
          'prenom': prenom,
          if (email != null && email.isNotEmpty) 'email': email,
        };

        final response = await mysqlDio.put('/clients/$clientId', data: updateData);
        return response.data;
      } else {
        // Si le client n'existe pas, le créer
        return await createClientInMySQL(
          uid: uid,
          telephone: telephone,
          nom: nom.isNotEmpty ? nom : null,
          prenom: prenom,
          email: email,
        );
      }
    } on DioException catch (e) {
      // Log l'erreur mais ne pas bloquer la mise à jour si l'API MySQL échoue
      print('Erreur lors de la mise à jour du client MySQL: ${e.message}');
      return {
        'success': false,
        'message': 'Erreur MySQL: ${e.message}',
      };
    } catch (e) {
      print('Erreur inattendue lors de la mise à jour du client MySQL: $e');
      return {
        'success': false,
        'message': 'Erreur inattendue: $e',
      };
    }
  }

  /// Authentifier un membre de l'équipe de bord (chauffeur, receveur, contrôleur)
  /// 
  /// [matricule] Le matricule du membre
  /// [pin] Le code PIN (6 chiffres)
  /// [poste] Le poste: 'chauffeur', 'receveur', ou 'controleur'
  /// 
  /// Retourne les données du membre si l'authentification réussit
  Future<Map<String, dynamic>> authenticateEquipeBord({
    required String matricule,
    required String pin,
    required String poste,
  }) async {
    try {
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await mysqlDio.post(
        '/equipe-bord/auth',
        data: {
          'matricule': matricule,
          'pin': pin,
          'poste': poste,
        },
      );

      return response.data;
    } on DioException catch (e) {
      print('Erreur lors de l\'authentification de l\'équipe: ${e.message}');
      if (e.response?.statusCode == 401) {
        return {
          'success': false,
          'message': 'Identifiants incorrects',
        };
      }
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.message}',
      };
    } catch (e) {
      print('Erreur inattendue lors de l\'authentification: $e');
      return {
        'success': false,
        'message': 'Erreur inattendue: $e',
      };
    }
  }

  /// Récupérer les informations complètes d'un bus depuis l'API MySQL
  /// 
  /// [numero] Le numéro du bus (ex: "BUS-225")
  /// 
  /// Retourne les données du bus si trouvé
  Future<Map<String, dynamic>> getBusInfo(String numero) async {
    try {
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await mysqlDio.get('/bus/numero/$numero');

      return response.data;
    } on DioException catch (e) {
      print('Erreur lors de la récupération du bus: ${e.message}');
      if (e.response?.statusCode == 404) {
        return {
          'success': false,
          'message': 'Bus non trouvé',
        };
      }
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.message}',
      };
    } catch (e) {
      print('Erreur inattendue lors de la récupération du bus: $e');
      return {
        'success': false,
        'message': 'Erreur inattendue: $e',
      };
    }
  }

  /// Récupérer un client par son UID Firebase
  /// 
  /// [uid] L'UID Firebase du client
  /// 
  /// Retourne les données du client si trouvé
  Future<Map<String, dynamic>> getClientByUid(String uid) async {
    try {
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await mysqlDio.get('/clients/uid/$uid');

      return response.data;
    } on DioException catch (e) {
      print('⚠️ Erreur lors de la récupération du client par UID: ${e.message}');
      if (e.response?.statusCode == 404) {
        return {
          'success': false,
          'message': 'Client non trouvé',
        };
      }
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.message}',
      };
    } catch (e) {
      print('❌ Erreur inattendue lors de la récupération du client: $e');
      return {
        'success': false,
        'message': 'Erreur inattendue: $e',
      };
    }
  }

  /// Créer un billet dans la base de données MySQL
  /// 
  /// Insère les données du billet après validation de l'achat
  /// 
  /// Retourne les données du billet créé si succès
  Future<Map<String, dynamic>> createBillet({
    required String numeroBillet,
    required String qrCode,
    required int? trajetId,
    required String? busId,
    required int? clientId,
    required String arretDepart,
    required String arretArrivee,
    required String dateVoyage,
    String? heureDepart,
    String? siegeNumero,
    required double prixPaye,
    required String devise,
    required String statutBillet,
    required String modePaiement,
    String? referencePaiement,
  }) async {
    try {
      final mysqlDio = Dio(BaseOptions(
        baseUrl: _mysqlApiUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final data = {
        'numero_billet': numeroBillet,
        'qr_code': qrCode,
        'trajet_id': trajetId,
        'tarif_id': 1, // Default tarif_id
        'bus_id': busId,
        'client_id': clientId,
        'arret_depart': arretDepart,
        'arret_arrivee': arretArrivee,
        'date_voyage': dateVoyage,
        'heure_depart': heureDepart,
        'siege_numero': siegeNumero,
        'prix_paye': prixPaye,
        'devise': devise,
        'statut_billet': statutBillet,
        'mode_paiement': modePaiement,
        'reference_paiement': referencePaiement,
        'point_vente': 'Application mobile',
      };

      print('📝 Création de billet dans MySQL: $numeroBillet');
      print('🔵 URL API: $_mysqlApiUrl/billets');
      print('🔵 Données envoyées: $data');
      
      final response = await mysqlDio.post('/billets', data: data);
      
      print('🔵 Réponse HTTP reçue - Status: ${response.statusCode}');

      if (response.data['success'] == true) {
        print('✅ Billet créé avec succès dans MySQL: ${response.data['data']['id']}');
      }

      return response.data;
    } on DioException catch (e) {
      print('⚠️ Erreur lors de la création du billet dans MySQL: ${e.message}');
      if (e.response != null) {
        print('Réponse serveur: ${e.response?.data}');
      }
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.message}',
      };
    } catch (e) {
      print('❌ Erreur inattendue lors de la création du billet: $e');
      return {
        'success': false,
        'message': 'Erreur inattendue: $e',
      };
    }
  }
}
