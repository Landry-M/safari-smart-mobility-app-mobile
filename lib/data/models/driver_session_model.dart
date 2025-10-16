import 'package:isar/isar.dart';

part 'driver_session_model.g.dart';

@Collection()
class DriverSession {
  Id id = Isar.autoIncrement;
  
  // Matricules des membres de l'équipe
  late String chauffeurMatricule;
  late String receveurMatricule;
  late String controleurMatricule;
  
  // Informations supplémentaires
  late String? busNumber;
  late String? route;
  
  // Session active
  late bool isActive;
  late DateTime loginTimestamp;
  late DateTime? logoutTimestamp;
  
  late DateTime createdAt;
  late DateTime updatedAt;

  DriverSession({
    this.chauffeurMatricule = '',
    this.receveurMatricule = '',
    this.controleurMatricule = '',
    this.busNumber,
    this.route,
    this.isActive = true,
    this.logoutTimestamp,
  }) {
    loginTimestamp = DateTime.now();
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  // Copie avec modifications
  DriverSession copyWith({
    String? chauffeurMatricule,
    String? receveurMatricule,
    String? controleurMatricule,
    String? busNumber,
    String? route,
    bool? isActive,
    DateTime? logoutTimestamp,
  }) {
    final copy = DriverSession(
      chauffeurMatricule: chauffeurMatricule ?? this.chauffeurMatricule,
      receveurMatricule: receveurMatricule ?? this.receveurMatricule,
      controleurMatricule: controleurMatricule ?? this.controleurMatricule,
      busNumber: busNumber ?? this.busNumber,
      route: route ?? this.route,
      isActive: isActive ?? this.isActive,
      logoutTimestamp: logoutTimestamp ?? this.logoutTimestamp,
    );
    // Préserver l'ID Isar (CRUCIAL pour éviter les conflits)
    copy.id = this.id;
    // Préserver les timestamps existants
    copy.loginTimestamp = this.loginTimestamp;
    copy.createdAt = this.createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }
}
