import 'package:isar/isar.dart';

part 'equipe_bord_model.g.dart';

@Collection()
class EquipeBord {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String matricule;
  
  late String nom;
  late String poste; // 'chauffeur', 'receveur', 'controleur'
  late String? telephone;
  late String? email;
  late String? busAffecte;
  late String statut; // 'actif', 'conge', 'suspendu', 'inactif'
  
  // Données de session
  late bool isCurrentSession; // true si c'est la session en cours
  late DateTime? loginTimestamp;
  
  late DateTime createdAt;
  late DateTime updatedAt;

  EquipeBord({
    this.matricule = '',
    this.nom = '',
    this.poste = '',
    this.telephone,
    this.email,
    this.busAffecte,
    this.statut = 'actif',
    this.isCurrentSession = false,
    this.loginTimestamp,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  // Créer depuis la réponse API
  factory EquipeBord.fromApi(Map<String, dynamic> json) {
    return EquipeBord(
      matricule: json['matricule'] ?? '',
      nom: json['nom'] ?? '',
      poste: json['poste'] ?? '',
      telephone: json['telephone'],
      email: json['email'],
      busAffecte: json['bus_affecte'],
      statut: json['statut'] ?? 'actif',
    );
  }

  // Convertir en Map pour l'API
  Map<String, dynamic> toJson() {
    return {
      'matricule': matricule,
      'nom': nom,
      'poste': poste,
      'telephone': telephone,
      'email': email,
      'bus_affecte': busAffecte,
      'statut': statut,
    };
  }

  // Copie avec modifications
  EquipeBord copyWith({
    String? matricule,
    String? nom,
    String? poste,
    String? telephone,
    String? email,
    String? busAffecte,
    String? statut,
    bool? isCurrentSession,
    DateTime? loginTimestamp,
  }) {
    final copy = EquipeBord(
      matricule: matricule ?? this.matricule,
      nom: nom ?? this.nom,
      poste: poste ?? this.poste,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      busAffecte: busAffecte ?? this.busAffecte,
      statut: statut ?? this.statut,
      isCurrentSession: isCurrentSession ?? this.isCurrentSession,
      loginTimestamp: loginTimestamp ?? this.loginTimestamp,
    );
    // Préserver l'ID Isar (CRUCIAL pour éviter les conflits d'index unique)
    copy.id = this.id;
    // Préserver les timestamps existants
    copy.createdAt = this.createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }
}
