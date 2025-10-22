import 'package:isar/isar.dart';

part 'bus_model.g.dart';

@Collection()
class Bus {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String numero;
  
  late int? mysqlId; // ID du bus dans la base MySQL
  
  late String immatriculation;
  late String? marque;
  late String? modele;
  late int? annee;
  late int? capacite;
  late int? kilometrage;
  late int? trajetId; // ID du trajet dans la table trajets
  late String? nomLigne; // Nom du trajet récupéré depuis la table trajets
  
  @Enumerated(EnumType.name)
  late BusStatut statut;
  
  late String? modules;
  late String? notes;
  late DateTime? derniereActivite;
  late double? latitude;
  late double? longitude;
  
  late DateTime createdAt;
  late DateTime updatedAt;

  Bus({
    this.numero = '',
    this.immatriculation = '',
    this.mysqlId,
    this.marque,
    this.modele,
    this.annee,
    this.capacite,
    this.kilometrage,
    this.trajetId,
    this.nomLigne,
    this.statut = BusStatut.actif,
    this.modules,
    this.notes,
    this.derniereActivite,
    this.latitude,
    this.longitude,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();

  // Copie avec modifications
  Bus copyWith({
    String? numero,
    String? immatriculation,
    int? mysqlId,
    String? marque,
    String? modele,
    int? annee,
    int? capacite,
    int? kilometrage,
    int? trajetId,
    String? nomLigne,
    BusStatut? statut,
    String? modules,
    String? notes,
    DateTime? derniereActivite,
    double? latitude,
    double? longitude,
  }) {
    final copy = Bus(
      numero: numero ?? this.numero,
      immatriculation: immatriculation ?? this.immatriculation,
      mysqlId: mysqlId ?? this.mysqlId,
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      annee: annee ?? this.annee,
      capacite: capacite ?? this.capacite,
      kilometrage: kilometrage ?? this.kilometrage,
      trajetId: trajetId ?? this.trajetId,
      nomLigne: nomLigne ?? this.nomLigne,
      statut: statut ?? this.statut,
      modules: modules ?? this.modules,
      notes: notes ?? this.notes,
      derniereActivite: derniereActivite ?? this.derniereActivite,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
    // Préserver l'ID Isar
    copy.id = this.id;
    copy.createdAt = this.createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }

  // Créer depuis API
  factory Bus.fromApi(Map<String, dynamic> json) {
    final bus = Bus(
      numero: json['numero'] ?? '',
      immatriculation: json['immatriculation'] ?? '',
      mysqlId: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      marque: json['marque'],
      modele: json['modele'],
      annee: json['annee'] != null ? int.tryParse(json['annee'].toString()) : null,
      capacite: json['capacite'] != null ? int.tryParse(json['capacite'].toString()) : null,
      kilometrage: json['kilometrage'] != null ? int.tryParse(json['kilometrage'].toString()) : null,
      trajetId: json['trajet_id'] != null ? int.tryParse(json['trajet_id'].toString()) : null,
      nomLigne: json['nom_ligne'] ?? json['trajet_nom'],
      statut: _parseStatut(json['statut']),
      modules: json['modules'],
      notes: json['notes'],
      derniereActivite: json['derniere_activite'] != null
          ? DateTime.tryParse(json['derniere_activite'])
          : null,
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );

    if (json['date_creation'] != null) {
      bus.createdAt = DateTime.tryParse(json['date_creation']) ?? DateTime.now();
    }

    return bus;
  }

  static BusStatut _parseStatut(dynamic statut) {
    if (statut == null) return BusStatut.actif;
    final statusStr = statut.toString().toLowerCase();
    switch (statusStr) {
      case 'actif':
        return BusStatut.actif;
      case 'maintenance':
        return BusStatut.maintenance;
      case 'panne':
        return BusStatut.panne;
      case 'inactif':
        return BusStatut.inactif;
      default:
        return BusStatut.actif;
    }
  }

  // Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': mysqlId,
      'numero': numero,
      'immatriculation': immatriculation,
      'marque': marque,
      'modele': modele,
      'annee': annee,
      'capacite': capacite,
      'kilometrage': kilometrage,
      'trajet_id': trajetId,
      'nom_ligne': nomLigne,
      'statut': statut.name,
      'modules': modules,
      'notes': notes,
      'derniere_activite': derniereActivite?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'date_creation': createdAt.toIso8601String(),
    };
  }

  // Méthode toString pour faciliter le débogage
  @override
  String toString() {
    return 'Bus(numero: $numero, immatriculation: $immatriculation, '
           'marque: $marque, modele: $modele, capacite: $capacite, '
           'trajetId: $trajetId, nomLigne: $nomLigne, '
           'statut: ${statut.name})';
  }
}

enum BusStatut {
  actif,
  maintenance,
  panne,
  inactif,
}
