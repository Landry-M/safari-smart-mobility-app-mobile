import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

/// Service pour gérer les interactions avec Firestore
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String usersCollection = 'users';
  static const String ticketsCollection = 'tickets';
  static const String tripsCollection = 'trips';

  /// Créer un nouvel utilisateur dans Firestore
  Future<void> createUser({
    required String uid,
    required String name,
    required String phone,
    String? email,
    UserRole role = UserRole.passenger,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final userData = {
        'uid': uid,
        'name': name,
        'phone': phone,
        'email': email,
        'role': role.name,
        'balance': 0.0,
        'badges': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      };

      await _firestore
          .collection(usersCollection)
          .doc(uid)
          .set(userData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'utilisateur dans Firestore: $e');
    }
  }

  /// Récupérer un utilisateur depuis Firestore
  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(usersCollection).doc(uid).get();
      
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  /// Mettre à jour les informations d'un utilisateur
  Future<void> updateUser({
    required String uid,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (data == null || data.isEmpty) return;

      final updateData = {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(usersCollection)
          .doc(uid)
          .update(updateData);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur: $e');
    }
  }

  /// Ajouter un badge à un utilisateur
  Future<void> addBadge({
    required String uid,
    required String badge,
  }) async {
    try {
      await _firestore.collection(usersCollection).doc(uid).update({
        'badges': FieldValue.arrayUnion([badge]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du badge: $e');
    }
  }

  /// Mettre à jour le solde d'un utilisateur
  Future<void> updateBalance({
    required String uid,
    required double newBalance,
  }) async {
    try {
      await _firestore.collection(usersCollection).doc(uid).update({
        'balance': newBalance,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du solde: $e');
    }
  }

  /// Créer un ticket dans Firestore
  Future<void> createTicket({
    required String ticketId,
    required String userId,
    required Map<String, dynamic> ticketData,
  }) async {
    try {
      await _firestore.collection(ticketsCollection).doc(ticketId).set({
        ...ticketData,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la création du ticket: $e');
    }
  }

  /// Récupérer les tickets d'un utilisateur
  Future<List<Map<String, dynamic>>> getUserTickets(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(ticketsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des tickets: $e');
    }
  }

  /// Vérifier si un utilisateur existe
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore.collection(usersCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Vérifier si un numéro de téléphone existe dans Firestore
  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    try {
      print('🟢 [FirestoreService] getUserByPhone - Recherche pour: $phone');
      
      // Essayer d'abord avec le numéro tel quel
      var querySnapshot = await _firestore
          .collection(usersCollection)
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      print('🟢 [FirestoreService] getUserByPhone - Nombre de documents trouvés (format exact): ${querySnapshot.docs.length}');

      if (querySnapshot.docs.isNotEmpty) {
        final userData = {
          'uid': querySnapshot.docs.first.id,
          ...querySnapshot.docs.first.data(),
        };
        print('🟢 [FirestoreService] getUserByPhone - Utilisateur trouvé: ${userData['name']} (${userData['phone']})');
        return userData;
      }
      
      // Si aucun résultat, essayer sans espaces
      final phoneNoSpaces = phone.replaceAll(' ', '');
      if (phoneNoSpaces != phone) {
        print('🟡 [FirestoreService] getUserByPhone - Tentative sans espaces: $phoneNoSpaces');
        querySnapshot = await _firestore
            .collection(usersCollection)
            .where('phone', isEqualTo: phoneNoSpaces)
            .limit(1)
            .get();
            
        if (querySnapshot.docs.isNotEmpty) {
          final userData = {
            'uid': querySnapshot.docs.first.id,
            ...querySnapshot.docs.first.data(),
          };
          print('🟢 [FirestoreService] getUserByPhone - Utilisateur trouvé (sans espaces): ${userData['name']} (${userData['phone']})');
          return userData;
        }
      }
      
      // Si toujours rien, essayer sans le +
      if (phone.startsWith('+')) {
        final phoneNoPlus = phone.substring(1);
        print('🟡 [FirestoreService] getUserByPhone - Tentative sans +: $phoneNoPlus');
        querySnapshot = await _firestore
            .collection(usersCollection)
            .where('phone', isEqualTo: phoneNoPlus)
            .limit(1)
            .get();
            
        if (querySnapshot.docs.isNotEmpty) {
          final userData = {
            'uid': querySnapshot.docs.first.id,
            ...querySnapshot.docs.first.data(),
          };
          print('🟢 [FirestoreService] getUserByPhone - Utilisateur trouvé (sans +): ${userData['name']} (${userData['phone']})');
          return userData;
        }
      }
      
      // Essayer avec le + si on ne l'avait pas
      if (!phone.startsWith('+')) {
        final phoneWithPlus = '+$phone';
        print('🟡 [FirestoreService] getUserByPhone - Tentative avec +: $phoneWithPlus');
        querySnapshot = await _firestore
            .collection(usersCollection)
            .where('phone', isEqualTo: phoneWithPlus)
            .limit(1)
            .get();
            
        if (querySnapshot.docs.isNotEmpty) {
          final userData = {
            'uid': querySnapshot.docs.first.id,
            ...querySnapshot.docs.first.data(),
          };
          print('🟢 [FirestoreService] getUserByPhone - Utilisateur trouvé (avec +): ${userData['name']} (${userData['phone']})');
          return userData;
        }
      }
      
      print('🟡 [FirestoreService] getUserByPhone - Aucun utilisateur trouvé pour: $phone (tous les formats testés)');
      return null;
    } catch (e) {
      print('🔴 [FirestoreService] getUserByPhone - Erreur: $e');
      throw Exception('Erreur lors de la vérification du numéro de téléphone: $e');
    }
  }

  /// Stream pour écouter les changements d'un utilisateur en temps réel
  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String uid) {
    return _firestore.collection(usersCollection).doc(uid).snapshots();
  }

  /// Supprimer un utilisateur (soft delete - marqué comme supprimé)
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(usersCollection).doc(uid).update({
        'isDeleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'utilisateur: $e');
    }
  }
}
