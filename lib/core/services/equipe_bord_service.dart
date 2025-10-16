import 'database_service.dart';
import '../../data/models/equipe_bord_model.dart';
import '../../data/models/driver_session_model.dart';
import '../../data/models/bus_model.dart';

/// Service pour gérer l'équipe de bord et les sessions
class EquipeBordService {
  final _dbService = DatabaseService();

  /// Récupérer la session active avec tous les membres
  Future<Map<String, dynamic>?> getActiveSessionWithMembers() async {
    try {
      final session = await _dbService.getActiveDriverSession();
      if (session == null) return null;

      final members = await _dbService.getCurrentSessionMembers();

      // Organiser les membres par poste
      EquipeBord? chauffeur;
      EquipeBord? receveur;
      EquipeBord? controleur;

      for (final membre in members) {
        switch (membre.poste) {
          case 'chauffeur':
            chauffeur = membre;
            break;
          case 'receveur':
            receveur = membre;
            break;
          case 'controleur':
            controleur = membre;
            break;
        }
      }

      // Récupérer les infos du bus
      Bus? bus;
      if (session.busNumber != null && session.busNumber!.isNotEmpty) {
        bus = await _dbService.getBusByNumero(session.busNumber!);
      }

      return {
        'session': session,
        'chauffeur': chauffeur,
        'receveur': receveur,
        'controleur': controleur,
        'members': members,
        'bus': bus,
      };
    } catch (e) {
      print('❌ Erreur lors de la récupération de la session: $e');
      return null;
    }
  }

  /// Vérifier si une session est active
  Future<bool> hasActiveSession() async {
    try {
      final session = await _dbService.getActiveDriverSession();
      return session != null;
    } catch (e) {
      return false;
    }
  }

  /// Récupérer un membre par matricule
  Future<EquipeBord?> getMemberByMatricule(String matricule) async {
    try {
      return await _dbService.getEquipeBordByMatricule(matricule);
    } catch (e) {
      print('❌ Erreur lors de la récupération du membre: $e');
      return null;
    }
  }

  /// Récupérer tous les membres d'un poste
  Future<List<EquipeBord>> getMembersByPoste(String poste) async {
    try {
      return await _dbService.getEquipeBordByPoste(poste);
    } catch (e) {
      print('❌ Erreur lors de la récupération des membres: $e');
      return [];
    }
  }

  /// Récupérer l'historique des sessions
  Future<List<DriverSession>> getSessionHistory() async {
    try {
      return await _dbService.getAllDriverSessions();
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique: $e');
      return [];
    }
  }

  /// Déconnecter la session active
  Future<void> logout() async {
    try {
      await _dbService.logoutDriverSession();
      print('✅ Session déconnectée avec succès');
    } catch (e) {
      print('❌ Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  /// Obtenir les statistiques de la session actuelle
  Future<Map<String, dynamic>?> getSessionStats() async {
    try {
      final sessionData = await getActiveSessionWithMembers();
      if (sessionData == null) return null;

      final session = sessionData['session'] as DriverSession;
      final duration = DateTime.now().difference(session.loginTimestamp);

      return {
        'duration': duration,
        'durationHours': duration.inHours,
        'durationMinutes': duration.inMinutes % 60,
        'busNumber': session.busNumber,
        'route': session.route,
        'loginTime': session.loginTimestamp,
        'isActive': session.isActive,
      };
    } catch (e) {
      print('❌ Erreur lors du calcul des statistiques: $e');
      return null;
    }
  }

  /// Vérifier si tous les membres de l'équipe sont présents
  Future<bool> isTeamComplete() async {
    try {
      final members = await _dbService.getCurrentSessionMembers();

      bool hasChauffeur = false;
      bool hasReceveur = false;
      bool hasControleur = false;

      for (final membre in members) {
        switch (membre.poste) {
          case 'chauffeur':
            hasChauffeur = true;
            break;
          case 'receveur':
            hasReceveur = true;
            break;
          case 'controleur':
            hasControleur = true;
            break;
        }
      }

      return hasChauffeur && hasReceveur && hasControleur;
    } catch (e) {
      return false;
    }
  }
}
