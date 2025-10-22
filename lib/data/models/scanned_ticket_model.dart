import 'package:isar/isar.dart';

part 'scanned_ticket_model.g.dart';

@Collection()
class ScannedTicket {
  Id id = Isar.autoIncrement;

  late String numeroBillet; // Numéro unique du billet
  late int? billetId; // ID du billet dans MySQL
  
  // Informations du passager
  late String? clientNom;
  late String? clientTelephone;
  
  // Informations du trajet
  late String arretDepart;
  late String arretArrivee;
  late String dateVoyage;
  late String? heureDepart;
  
  // Informations du bus et équipe
  late String? busNumero;
  late String? busImmatriculation;
  late String? chauffeurMatricule;
  late String? receveurMatricule;
  
  // Informations de paiement
  late double prixPaye;
  late String devise;
  late String modePaiement;
  
  // Statut et validation
  late String statutBillet; // 'utilise' après scan
  DateTime scannedAt; // Date et heure du scan
  late String? scannedBy; // Matricule de la personne qui a scanné
  
  late DateTime createdAt;
  late DateTime updatedAt;

  ScannedTicket({
    this.numeroBillet = '',
    this.billetId,
    this.clientNom,
    this.clientTelephone,
    this.arretDepart = '',
    this.arretArrivee = '',
    this.dateVoyage = '',
    this.heureDepart,
    this.busNumero,
    this.busImmatriculation,
    this.chauffeurMatricule,
    this.receveurMatricule,
    this.prixPaye = 0.0,
    this.devise = 'CDF',
    this.modePaiement = '',
    this.statutBillet = 'utilise',
    required this.scannedAt,
    this.scannedBy,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();

  // Créer depuis les données de l'API
  factory ScannedTicket.fromApi(Map<String, dynamic> json) {
    return ScannedTicket(
      numeroBillet: json['numero_billet'] ?? '',
      billetId: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      clientNom: json['client_nom'] ?? json['nom_client'],
      clientTelephone: json['client_telephone'] ?? json['telephone_client'],
      arretDepart: json['arret_depart'] ?? '',
      arretArrivee: json['arret_arrivee'] ?? '',
      dateVoyage: json['date_voyage'] ?? '',
      heureDepart: json['heure_depart'],
      busNumero: json['bus_numero'] ?? json['numero_bus'],
      busImmatriculation: json['bus_immatriculation'] ?? json['immatriculation_bus'],
      prixPaye: json['prix_paye'] != null 
          ? double.tryParse(json['prix_paye'].toString()) ?? 0.0
          : 0.0,
      devise: json['devise'] ?? 'CDF',
      modePaiement: json['mode_paiement'] ?? '',
      statutBillet: json['statut_billet'] ?? 'utilise',
      scannedAt: json['scanned_at'] != null
          ? DateTime.tryParse(json['scanned_at']) ?? DateTime.now()
          : DateTime.now(),
      scannedBy: json['scanned_by'],
    );
  }

  // Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'numero_billet': numeroBillet,
      'billet_id': billetId,
      'client_nom': clientNom,
      'client_telephone': clientTelephone,
      'arret_depart': arretDepart,
      'arret_arrivee': arretArrivee,
      'date_voyage': dateVoyage,
      'heure_depart': heureDepart,
      'bus_numero': busNumero,
      'bus_immatriculation': busImmatriculation,
      'chauffeur_matricule': chauffeurMatricule,
      'receveur_matricule': receveurMatricule,
      'prix_paye': prixPaye,
      'devise': devise,
      'mode_paiement': modePaiement,
      'statut_billet': statutBillet,
      'scanned_at': scannedAt.toIso8601String(),
      'scanned_by': scannedBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ScannedTicket(numero: $numeroBillet, from: $arretDepart, to: $arretArrivee, '
           'prix: $prixPaye $devise, scannedAt: $scannedAt)';
  }
}
