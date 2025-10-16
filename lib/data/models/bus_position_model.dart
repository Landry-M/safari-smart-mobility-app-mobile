import 'package:isar/isar.dart';

part 'bus_position_model.g.dart';

@Collection()
class BusPosition {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String busId;
  
  // Bus information
  late String? immatriculation;
  late String? marque;
  late String? modele;
  
  late double latitude;
  late double longitude;
  late double? altitude;
  late double? accuracy;
  late double? heading;
  late double? speed;
  
  // Route information
  late String? routeId;
  late String? routeName;
  late String? direction;
  
  // Status
  @Enumerated(EnumType.name)
  late BusStatus status;
  
  late int? occupancy; // Nombre de passagers
  late int? capacity;  // Capacité maximale
  
  // Driver information
  late String? driverId;
  late String? driverName;
  
  late DateTime timestamp;
  late DateTime createdAt;
  
  // Offline sync
  late bool isSynced;
  
  BusPosition({
    this.busId = '',
    this.immatriculation,
    this.marque,
    this.modele,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.altitude,
    this.accuracy,
    this.heading,
    this.speed,
    this.routeId,
    this.routeName,
    this.direction,
    this.status = BusStatus.active,
    this.occupancy,
    this.capacity,
    this.driverId,
    this.driverName,
    this.isSynced = false,
  }) : timestamp = DateTime.now(),
       createdAt = DateTime.now();
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'busId': busId,
      'immatriculation': immatriculation,
      'marque': marque,
      'modele': modele,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'heading': heading,
      'speed': speed,
      'routeId': routeId,
      'routeName': routeName,
      'direction': direction,
      'status': status.name,
      'occupancy': occupancy,
      'capacity': capacity,
      'driverId': driverId,
      'driverName': driverName,
      'timestamp': timestamp.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }
  
  // Create from JSON
  factory BusPosition.fromJson(Map<String, dynamic> json) {
    final position = BusPosition(
      busId: json['busId'] ?? '',
      immatriculation: json['immatriculation'],
      marque: json['marque'],
      modele: json['modele'],
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      altitude: json['altitude']?.toDouble(),
      accuracy: json['accuracy']?.toDouble(),
      heading: json['heading']?.toDouble(),
      speed: json['speed']?.toDouble(),
      routeId: json['routeId'],
      routeName: json['routeName'],
      direction: json['direction'],
      status: BusStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BusStatus.active,
      ),
      occupancy: json['occupancy'],
      capacity: json['capacity'],
      driverId: json['driverId'],
      driverName: json['driverName'],
      isSynced: json['isSynced'] ?? false,
    );
    
    if (json['timestamp'] != null) {
      position.timestamp = DateTime.parse(json['timestamp']);
    }
    if (json['createdAt'] != null) {
      position.createdAt = DateTime.parse(json['createdAt']);
    }
    
    return position;
  }
  
  // Calculate occupancy percentage
  double get occupancyPercentage {
    if (capacity == null || capacity == 0 || occupancy == null) return 0.0;
    return (occupancy! / capacity!) * 100;
  }
  
  // Check if bus is full
  bool get isFull {
    if (capacity == null || occupancy == null) return false;
    return occupancy! >= capacity!;
  }
  
  BusPosition copyWith({
    String? busId,
    String? immatriculation,
    String? marque,
    String? modele,
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracy,
    double? heading,
    double? speed,
    String? routeId,
    String? routeName,
    String? direction,
    BusStatus? status,
    int? occupancy,
    int? capacity,
    String? driverId,
    String? driverName,
    DateTime? timestamp,
    bool? isSynced,
  }) {
    final newPosition = BusPosition(
      busId: busId ?? this.busId,
      immatriculation: immatriculation ?? this.immatriculation,
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      routeId: routeId ?? this.routeId,
      routeName: routeName ?? this.routeName,
      direction: direction ?? this.direction,
      status: status ?? this.status,
      occupancy: occupancy ?? this.occupancy,
      capacity: capacity ?? this.capacity,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      isSynced: isSynced ?? this.isSynced,
    );
    
    newPosition.id = id;
    newPosition.timestamp = timestamp ?? this.timestamp;
    newPosition.createdAt = createdAt;
    
    return newPosition;
  }
}

enum BusStatus {
  active,       // En service
  inactive,     // Hors service
  maintenance,  // En maintenance
  breakdown,    // En panne
  depot,        // Au dépôt
}
