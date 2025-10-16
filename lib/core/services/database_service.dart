import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/user_model.dart';
import '../../data/models/ticket_model.dart';
import '../../data/models/bus_position_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/equipe_bord_model.dart';
import '../../data/models/driver_session_model.dart';
import '../../data/models/bus_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Isar? _isar;

  // Initialize database
  Future<void> initialize() async {
    if (_isar != null) return;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        UserSchema,
        TicketSchema,
        BusPositionSchema,
        TransactionSchema,
        EquipeBordSchema,
        DriverSessionSchema,
        BusSchema,
      ],
      directory: dir.path,
      name: 'safari_mobility',
    );
  }

  // Get database instance
  Isar get database {
    if (_isar == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _isar!;
  }

  // User operations
  Future<void> saveUser(User user) async {
    await database.writeTxn(() async {
      await database.users.put(user);
    });
  }

  Future<User?> getUser(String userId) async {
    return await database.users.filter().userIdEqualTo(userId).findFirst();
  }

  Future<User?> getCurrentUser() async {
    return await database.users.where().findFirst();
  }

  Future<void> deleteUser(String userId) async {
    await database.writeTxn(() async {
      await database.users.filter().userIdEqualTo(userId).deleteFirst();
    });
  }

  Future<void> clearUsers() async {
    await database.writeTxn(() async {
      await database.users.clear();
    });
  }

  // Ticket operations
  Future<void> saveTicket(Ticket ticket) async {
    await database.writeTxn(() async {
      await database.tickets.put(ticket);
    });
  }

  Future<void> saveTickets(List<Ticket> tickets) async {
    await database.writeTxn(() async {
      await database.tickets.putAll(tickets);
    });
  }

  Future<Ticket?> getTicket(String ticketId) async {
    return await database.tickets
        .filter()
        .ticketIdEqualTo(ticketId)
        .findFirst();
  }

  Future<Ticket?> getTicketByQRCode(String qrCode) async {
    return await database.tickets.filter().qrCodeEqualTo(qrCode).findFirst();
  }

  Future<List<Ticket>> getUserTickets(String userId) async {
    return await database.tickets.filter().userIdEqualTo(userId).findAll();
  }

  Future<List<Ticket>> getActiveTickets(String userId) async {
    return await database.tickets
        .filter()
        .userIdEqualTo(userId)
        .and()
        .statusEqualTo(TicketStatus.active)
        .findAll();
  }

  Future<List<Ticket>> getUnsyncedTickets() async {
    return await database.tickets.filter().isSyncedEqualTo(false).findAll();
  }

  Future<void> markTicketAsSynced(String ticketId) async {
    final ticket = await getTicket(ticketId);
    if (ticket != null) {
      final updatedTicket = ticket.copyWith(isSynced: true);
      await saveTicket(updatedTicket);
    }
  }

  Future<void> deleteTicket(String ticketId) async {
    await database.writeTxn(() async {
      await database.tickets.filter().ticketIdEqualTo(ticketId).deleteFirst();
    });
  }

  // Bus position operations
  Future<void> saveBusPosition(BusPosition position) async {
    await database.writeTxn(() async {
      await database.busPositions.put(position);
    });
  }

  Future<void> saveBusPositions(List<BusPosition> positions) async {
    await database.writeTxn(() async {
      await database.busPositions.putAll(positions);
    });
  }

  Future<BusPosition?> getLatestBusPosition(String busId) async {
    return await database.busPositions
        .filter()
        .busIdEqualTo(busId)
        .sortByTimestampDesc()
        .findFirst();
  }

  Future<List<BusPosition>> getBusPositions(String busId,
      {int limit = 100}) async {
    return await database.busPositions
        .filter()
        .busIdEqualTo(busId)
        .sortByTimestampDesc()
        .limit(limit)
        .findAll();
  }

  Future<List<BusPosition>> getUnsyncedBusPositions() async {
    return await database.busPositions
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
  }

  Future<void> markBusPositionAsSynced(String busId, DateTime timestamp) async {
    final position = await database.busPositions
        .filter()
        .busIdEqualTo(busId)
        .and()
        .timestampEqualTo(timestamp)
        .findFirst();

    if (position != null) {
      final updatedPosition = position.copyWith(isSynced: true);
      await saveBusPosition(updatedPosition);
    }
  }

  Future<void> cleanOldBusPositions({int daysToKeep = 7}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

    await database.writeTxn(() async {
      await database.busPositions
          .filter()
          .timestampLessThan(cutoffDate)
          .deleteAll();
    });
  }

  // Transaction operations
  Future<void> saveTransaction(Transaction transaction) async {
    await database.writeTxn(() async {
      await database.transactions.put(transaction);
    });
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    await database.writeTxn(() async {
      await database.transactions.putAll(transactions);
    });
  }

  Future<Transaction?> getTransaction(String transactionId) async {
    return await database.transactions
        .filter()
        .transactionIdEqualTo(transactionId)
        .findFirst();
  }

  Future<List<Transaction>> getUserTransactions(String userId) async {
    return await database.transactions
        .filter()
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<List<Transaction>> getPendingTransactions(String userId) async {
    return await database.transactions
        .filter()
        .userIdEqualTo(userId)
        .and()
        .statusEqualTo(TransactionStatus.pending)
        .findAll();
  }

  Future<List<Transaction>> getUnsyncedTransactions() async {
    return await database.transactions
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
  }

  Future<void> markTransactionAsSynced(String transactionId) async {
    final transaction = await getTransaction(transactionId);
    if (transaction != null) {
      final updatedTransaction = transaction.copyWith(isSynced: true);
      await saveTransaction(updatedTransaction);
    }
  }

  // Analytics and reports
  Future<double> getUserTotalSpent(String userId) async {
    final transactions = await database.transactions
        .filter()
        .userIdEqualTo(userId)
        .and()
        .statusEqualTo(TransactionStatus.completed)
        .and()
        .typeEqualTo(TransactionType.purchase)
        .findAll();

    return transactions.fold<double>(
        0.0, (sum, transaction) => sum + transaction.amount);
  }

  Future<int> getUserTicketCount(String userId) async {
    return await database.tickets.filter().userIdEqualTo(userId).count();
  }

  Future<Map<String, dynamic>> getDailyReport(
      String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final transactions = await database.transactions
        .filter()
        .userIdEqualTo(userId)
        .and()
        .createdAtBetween(startOfDay, endOfDay)
        .findAll();

    final tickets = await database.tickets
        .filter()
        .userIdEqualTo(userId)
        .and()
        .createdAtBetween(startOfDay, endOfDay)
        .findAll();

    final totalSpent = transactions
        .where((t) => t.type == TransactionType.purchase && t.isSuccessful)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalEarned = transactions
        .where((t) => t.type == TransactionType.collection && t.isSuccessful)
        .fold(0.0, (sum, t) => sum + t.amount);

    return {
      'date': date.toIso8601String(),
      'ticketCount': tickets.length,
      'transactionCount': transactions.length,
      'totalSpent': totalSpent,
      'totalEarned': totalEarned,
      'netAmount': totalEarned - totalSpent,
    };
  }

  // Sync operations
  Future<Map<String, List<dynamic>>> getUnsyncedData() async {
    final unsyncedTickets = await getUnsyncedTickets();
    final unsyncedPositions = await getUnsyncedBusPositions();
    final unsyncedTransactions = await getUnsyncedTransactions();

    return {
      'tickets': unsyncedTickets,
      'positions': unsyncedPositions,
      'transactions': unsyncedTransactions,
    };
  }

  Future<void> markAllAsSynced() async {
    await database.writeTxn(() async {
      // Mark all tickets as synced
      final tickets =
          await database.tickets.filter().isSyncedEqualTo(false).findAll();
      for (final ticket in tickets) {
        final updated = ticket.copyWith(isSynced: true);
        await database.tickets.put(updated);
      }

      // Mark all positions as synced
      final positions =
          await database.busPositions.filter().isSyncedEqualTo(false).findAll();
      for (final position in positions) {
        final updated = position.copyWith(isSynced: true);
        await database.busPositions.put(updated);
      }

      // Mark all transactions as synced
      final transactions =
          await database.transactions.filter().isSyncedEqualTo(false).findAll();
      for (final transaction in transactions) {
        final updated = transaction.copyWith(isSynced: true);
        await database.transactions.put(updated);
      }
    });
  }

  // EquipeBord operations
  Future<void> saveEquipeBord(EquipeBord membre) async {
    await database.writeTxn(() async {
      await database.equipeBords.put(membre);
    });
  }

  Future<EquipeBord?> getEquipeBordByMatricule(String matricule) async {
    return await database.equipeBords
        .filter()
        .matriculeEqualTo(matricule)
        .findFirst();
  }

  Future<List<EquipeBord>> getAllEquipeBord() async {
    return await database.equipeBords.where().findAll();
  }

  Future<List<EquipeBord>> getEquipeBordByPoste(String poste) async {
    return await database.equipeBords.filter().posteEqualTo(poste).findAll();
  }

  Future<void> clearCurrentSessions() async {
    await database.writeTxn(() async {
      final membres = await database.equipeBords
          .filter()
          .isCurrentSessionEqualTo(true)
          .findAll();
      for (final membre in membres) {
        final updated = membre.copyWith(isCurrentSession: false);
        await database.equipeBords.put(updated);
      }
    });
  }

  Future<List<EquipeBord>> getCurrentSessionMembers() async {
    return await database.equipeBords
        .filter()
        .isCurrentSessionEqualTo(true)
        .findAll();
  }

  // DriverSession operations
  Future<void> saveDriverSession(DriverSession session) async {
    await database.writeTxn(() async {
      await database.driverSessions.put(session);
    });
  }

  Future<DriverSession?> getActiveDriverSession() async {
    return await database.driverSessions
        .filter()
        .isActiveEqualTo(true)
        .findFirst();
  }

  Future<void> deactivateAllSessions() async {
    await database.writeTxn(() async {
      final sessions = await database.driverSessions
          .filter()
          .isActiveEqualTo(true)
          .findAll();
      for (final session in sessions) {
        final updated = session.copyWith(
          isActive: false,
          logoutTimestamp: DateTime.now(),
        );
        await database.driverSessions.put(updated);
      }
    });
  }

  Future<List<DriverSession>> getAllDriverSessions() async {
    return await database.driverSessions
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<void> logoutDriverSession() async {
    await database.writeTxn(() async {
      // Désactiver la session active
      final session = await database.driverSessions
          .filter()
          .isActiveEqualTo(true)
          .findFirst();
      if (session != null) {
        final updated = session.copyWith(
          isActive: false,
          logoutTimestamp: DateTime.now(),
        );
        await database.driverSessions.put(updated);
      }

      // Marquer tous les membres comme non-session courante (directement, sans appel de méthode)
      final membres = await database.equipeBords
          .filter()
          .isCurrentSessionEqualTo(true)
          .findAll();
      for (final membre in membres) {
        final updated = membre.copyWith(isCurrentSession: false);
        await database.equipeBords.put(updated);
      }
    });
  }

  /// Sauvegarder une session complète de manière atomique
  Future<void> saveCompleteDriverSession({
    required EquipeBord? chauffeur,
    required EquipeBord? receveur,
    required EquipeBord? controleur,
    required DriverSession session,
  }) async {
    await database.writeTxn(() async {
      // 1. Désactiver les anciennes sessions
      final oldSessions = await database.driverSessions
          .filter()
          .isActiveEqualTo(true)
          .findAll();
      for (final oldSession in oldSessions) {
        final updated = oldSession.copyWith(
          isActive: false,
          logoutTimestamp: DateTime.now(),
        );
        await database.driverSessions.put(updated);
      }

      // 2. Marquer les anciens membres comme non-session courante
      final oldMembres = await database.equipeBords
          .filter()
          .isCurrentSessionEqualTo(true)
          .findAll();
      for (final oldMembre in oldMembres) {
        final updated = oldMembre.copyWith(isCurrentSession: false);
        await database.equipeBords.put(updated);
      }

      // 3. Sauvegarder les nouveaux membres (avec upsert basé sur matricule)
      if (chauffeur != null) {
        // Chercher si un membre avec ce matricule existe déjà
        final existing = await database.equipeBords
            .filter()
            .matriculeEqualTo(chauffeur.matricule)
            .findFirst();

        if (existing != null) {
          // Mettre à jour l'existant avec les nouvelles données
          final updated = existing.copyWith(
            nom: chauffeur.nom,
            poste: chauffeur.poste,
            telephone: chauffeur.telephone,
            email: chauffeur.email,
            busAffecte: chauffeur.busAffecte,
            statut: chauffeur.statut,
            isCurrentSession: chauffeur.isCurrentSession,
            loginTimestamp: chauffeur.loginTimestamp,
          );
          await database.equipeBords.put(updated);
        } else {
          // Créer un nouveau membre
          await database.equipeBords.put(chauffeur);
        }
      }

      if (receveur != null) {
        final existing = await database.equipeBords
            .filter()
            .matriculeEqualTo(receveur.matricule)
            .findFirst();

        if (existing != null) {
          final updated = existing.copyWith(
            nom: receveur.nom,
            poste: receveur.poste,
            telephone: receveur.telephone,
            email: receveur.email,
            busAffecte: receveur.busAffecte,
            statut: receveur.statut,
            isCurrentSession: receveur.isCurrentSession,
            loginTimestamp: receveur.loginTimestamp,
          );
          await database.equipeBords.put(updated);
        } else {
          await database.equipeBords.put(receveur);
        }
      }

      if (controleur != null) {
        final existing = await database.equipeBords
            .filter()
            .matriculeEqualTo(controleur.matricule)
            .findFirst();

        if (existing != null) {
          final updated = existing.copyWith(
            nom: controleur.nom,
            poste: controleur.poste,
            telephone: controleur.telephone,
            email: controleur.email,
            busAffecte: controleur.busAffecte,
            statut: controleur.statut,
            isCurrentSession: controleur.isCurrentSession,
            loginTimestamp: controleur.loginTimestamp,
          );
          await database.equipeBords.put(updated);
        } else {
          await database.equipeBords.put(controleur);
        }
      }

      // 4. Créer la nouvelle session
      await database.driverSessions.put(session);
    });
  }

  // Bus operations
  Future<void> saveBus(Bus bus) async {
    await database.writeTxn(() async {
      await database.bus.put(bus);
    });
  }

  Future<Bus?> getBusByNumero(String numero) async {
    return await database.bus.filter().numeroEqualTo(numero).findFirst();
  }

  Future<Bus?> getBus(int id) async {
    return await database.bus.get(id);
  }

  Future<List<Bus>> getAllBus() async {
    return await database.bus.where().findAll();
  }

  Future<List<Bus>> getActiveBus() async {
    return await database.bus.filter().statutEqualTo(BusStatut.actif).findAll();
  }

  // Database maintenance
  Future<void> clearAllData() async {
    await database.writeTxn(() async {
      await database.users.clear();
      await database.tickets.clear();
      await database.busPositions.clear();
      await database.transactions.clear();
      await database.equipeBords.clear();
      await database.driverSessions.clear();
      await database.bus.clear();
    });
  }

  Future<int> getDatabaseSize() async {
    return await database.getSize();
  }

  // Close database
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
