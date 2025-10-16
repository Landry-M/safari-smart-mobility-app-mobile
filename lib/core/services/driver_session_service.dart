import 'package:shared_preferences/shared_preferences.dart';

class DriverSessionService {
  static const String _keyIsDriverLoggedIn = 'is_driver_logged_in';
  static const String _keyChauffeurMatricule = 'chauffeur_matricule';
  static const String _keyReceveurMatricule = 'receveur_matricule';
  static const String _keyCollecteurMatricule = 'collecteur_matricule';
  static const String _keyBusNumber = 'bus_number';
  static const String _keyRoute = 'route';
  static const String _keyLoginTimestamp = 'login_timestamp';

  // Sauvegarder la session chauffeur
  Future<void> saveDriverSession({
    required String chauffeurMatricule,
    required String receveurMatricule,
    required String collecteurMatricule,
    String busNumber = 'BUS-225',
    String route = 'Abobo - Plateau',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDriverLoggedIn, true);
    await prefs.setString(_keyChauffeurMatricule, chauffeurMatricule);
    await prefs.setString(_keyReceveurMatricule, receveurMatricule);
    await prefs.setString(_keyCollecteurMatricule, collecteurMatricule);
    await prefs.setString(_keyBusNumber, busNumber);
    await prefs.setString(_keyRoute, route);
    await prefs.setString(_keyLoginTimestamp, DateTime.now().toIso8601String());
  }

  // Vérifier si une session chauffeur existe
  Future<bool> isDriverLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDriverLoggedIn) ?? false;
  }

  // Récupérer les informations de la session
  Future<Map<String, String>?> getDriverSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsDriverLoggedIn) ?? false;

    if (!isLoggedIn) {
      return null;
    }

    return {
      'chauffeur': prefs.getString(_keyChauffeurMatricule) ?? '',
      'receveur': prefs.getString(_keyReceveurMatricule) ?? '',
      'collecteur': prefs.getString(_keyCollecteurMatricule) ?? '',
      'busNumber': prefs.getString(_keyBusNumber) ?? 'BUS-225',
      'route': prefs.getString(_keyRoute) ?? 'Abobo - Plateau',
      'loginTimestamp': prefs.getString(_keyLoginTimestamp) ?? '',
    };
  }

  // Déconnexion - supprimer la session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsDriverLoggedIn);
    await prefs.remove(_keyChauffeurMatricule);
    await prefs.remove(_keyReceveurMatricule);
    await prefs.remove(_keyCollecteurMatricule);
    await prefs.remove(_keyBusNumber);
    await prefs.remove(_keyRoute);
    await prefs.remove(_keyLoginTimestamp);
  }

  // Effacer toutes les données (utile pour le debug)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
