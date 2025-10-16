import 'package:isar/isar.dart';

part 'ticket_model.g.dart';

@Collection()
class Ticket {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String ticketId;
  
  late String userId;
  late String? tripId;
  late String qrCode;
  
  @Enumerated(EnumType.name)
  late TicketStatus status;
  
  @Enumerated(EnumType.name)
  late TicketType type;
  
  late double price;
  late String currency;
  
  // Route information
  late String? routeId;
  late String? routeName;
  late String? origin;
  late String? destination;
  late double? distance; // Distance du trajet en km
  late String? seatNumber;
  
  // Validation information
  late DateTime? validatedAt;
  late String? validatedBy; // Controller ID
  late String? busId;
  
  // Expiration
  late DateTime? expiresAt;
  
  late DateTime createdAt;
  late DateTime updatedAt;
  
  // Offline sync
  late bool isSynced;
  
  Ticket({
    this.ticketId = '',
    this.userId = '',
    this.tripId,
    this.qrCode = '',
    this.status = TicketStatus.pending,
    this.type = TicketType.single,
    this.price = 0.0,
    this.currency = 'XOF',
    this.routeId,
    this.routeName,
    this.origin,
    this.destination,
    this.distance,
    this.seatNumber,
    this.validatedAt,
    this.validatedBy,
    this.busId,
    this.expiresAt,
    this.isSynced = false,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': ticketId,
      'userId': userId,
      'tripId': tripId,
      'qrCode': qrCode,
      'status': status.name,
      'type': type.name,
      'price': price,
      'currency': currency,
      'routeId': routeId,
      'routeName': routeName,
      'origin': origin,
      'destination': destination,
      'distance': distance,
      'seatNumber': seatNumber,
      'validatedAt': validatedAt?.toIso8601String(),
      'validatedBy': validatedBy,
      'busId': busId,
      'expiresAt': expiresAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }
  
  // Create from JSON
  factory Ticket.fromJson(Map<String, dynamic> json) {
    final ticket = Ticket(
      ticketId: json['id'] ?? '',
      userId: json['userId'] ?? '',
      tripId: json['tripId'],
      qrCode: json['qrCode'] ?? '',
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.pending,
      ),
      type: TicketType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TicketType.single,
      ),
      price: (json['price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'XOF',
      routeId: json['routeId'],
      routeName: json['routeName'],
      origin: json['origin'],
      destination: json['destination'],
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
      seatNumber: json['seatNumber'],
      validatedAt: json['validatedAt'] != null
          ? DateTime.parse(json['validatedAt'])
          : null,
      validatedBy: json['validatedBy'],
      busId: json['busId'],
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : null,
      isSynced: json['isSynced'] ?? false,
    );
    
    if (json['createdAt'] != null) {
      ticket.createdAt = DateTime.parse(json['createdAt']);
    }
    if (json['updatedAt'] != null) {
      ticket.updatedAt = DateTime.parse(json['updatedAt']);
    }
    
    return ticket;
  }
  
  // Check if ticket is valid
  bool get isValid {
    if (status != TicketStatus.active) return false;
    if (expiresAt != null && DateTime.now().isAfter(expiresAt!)) return false;
    return true;
  }
  
  // Check if ticket is expired
  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }
  
  Ticket copyWith({
    String? ticketId,
    String? userId,
    String? tripId,
    String? qrCode,
    TicketStatus? status,
    TicketType? type,
    double? price,
    String? currency,
    String? routeId,
    String? routeName,
    String? origin,
    String? destination,
    double? distance,
    String? seatNumber,
    DateTime? validatedAt,
    String? validatedBy,
    String? busId,
    DateTime? expiresAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    final newTicket = Ticket(
      ticketId: ticketId ?? this.ticketId,
      userId: userId ?? this.userId,
      tripId: tripId ?? this.tripId,
      qrCode: qrCode ?? this.qrCode,
      status: status ?? this.status,
      type: type ?? this.type,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      routeId: routeId ?? this.routeId,
      routeName: routeName ?? this.routeName,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      distance: distance ?? this.distance,
      seatNumber: seatNumber ?? this.seatNumber,
      validatedAt: validatedAt ?? this.validatedAt,
      validatedBy: validatedBy ?? this.validatedBy,
      busId: busId ?? this.busId,
      expiresAt: expiresAt ?? this.expiresAt,
      isSynced: isSynced ?? this.isSynced,
    );
    
    newTicket.id = id;
    newTicket.createdAt = createdAt;
    newTicket.updatedAt = updatedAt ?? DateTime.now();
    
    return newTicket;
  }
}

enum TicketStatus {
  pending,      // En attente
  active,       // Actif
  validated,    // Validé
  expired,      // Expiré
  cancelled,    // Annulé
  refunded,     // Remboursé
}

enum TicketType {
  single,       // Billet simple
  roundTrip,    // Aller-retour
  daily,        // Journalier
  weekly,       // Hebdomadaire
  monthly,      // Mensuel
}
