import 'package:isar/isar.dart';

part 'user_model.g.dart';

@Collection()
class User {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String userId;
  
  late String name;
  late String phone;
  late String email;
  
  @Enumerated(EnumType.name)
  late UserRole role;
  
  late String? token;
  late String? refreshToken;
  
  late double balance;
  
  // Gamification fields
  late String? avatar;
  late String? displayName;
  
  @Enumerated(EnumType.name)
  late TravelPurpose? travelPurpose;
  
  late bool autoRecharge;
  late List<String> badges;
  
  // Preferences
  late bool notificationsEnabled;
  late String language;
  late bool locationEnabled;
  late String currency; // 'USD' or 'FC'
  
  late DateTime createdAt;
  late DateTime updatedAt;
  
  User({
    this.userId = '',
    this.name = '',
    this.phone = '',
    this.email = '',
    this.role = UserRole.passenger,
    this.token,
    this.refreshToken,
    this.balance = 0.0,
    this.avatar,
    this.displayName,
    this.travelPurpose,
    this.autoRecharge = false,
    this.badges = const [],
    this.notificationsEnabled = true,
    this.language = 'fr',
    this.locationEnabled = true,
    this.currency = 'FC',
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role.name,
      'balance': balance,
      'avatar': avatar,
      'displayName': displayName,
      'travelPurpose': travelPurpose?.name,
      'autoRecharge': autoRecharge,
      'badges': badges,
      'notificationsEnabled': notificationsEnabled,
      'language': language,
      'locationEnabled': locationEnabled,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      userId: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.passenger,
      ),
      balance: (json['balance'] ?? 0.0).toDouble(),
      avatar: json['avatar'],
      displayName: json['displayName'],
      travelPurpose: json['travelPurpose'] != null
          ? TravelPurpose.values.firstWhere(
              (e) => e.name == json['travelPurpose'],
              orElse: () => TravelPurpose.work,
            )
          : null,
      autoRecharge: json['autoRecharge'] ?? false,
      badges: List<String>.from(json['badges'] ?? []),
      locationEnabled: json['locationEnabled'] ?? true,
      currency: json['currency'] ?? 'FC',
    );
    
    if (json['createdAt'] != null) {
      user.createdAt = DateTime.parse(json['createdAt']);
    }
    if (json['updatedAt'] != null) {
      user.updatedAt = DateTime.parse(json['updatedAt']);
    }
    
    return user;
  }
  
  User copyWith({
    String? userId,
    String? name,
    String? phone,
    String? email,
    UserRole? role,
    String? token,
    String? refreshToken,
    double? balance,
    String? avatar,
    String? displayName,
    TravelPurpose? travelPurpose,
    bool? autoRecharge,
    List<String>? badges,
    bool? notificationsEnabled,
    String? language,
    bool? locationEnabled,
    String? currency,
    DateTime? updatedAt,
  }) {
    final newUser = User(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      balance: balance ?? this.balance,
      avatar: avatar ?? this.avatar,
      displayName: displayName ?? this.displayName,
      travelPurpose: travelPurpose ?? this.travelPurpose,
      autoRecharge: autoRecharge ?? this.autoRecharge,
      badges: badges ?? this.badges,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      currency: currency ?? this.currency,
    );
    
    newUser.id = id;
    newUser.token = token ?? this.token;
    newUser.refreshToken = refreshToken ?? this.refreshToken;
    newUser.createdAt = createdAt;
    newUser.updatedAt = updatedAt ?? DateTime.now();
    
    return newUser;
  }
}

enum UserRole {
  passenger,    // Usager
  driver,       // Chauffeur
  controller,   // Contrôleur
  collector,    // Receveur
  admin,        // Administrateur
}

enum TravelPurpose {
  work,         // Travail
  studies,      // Études
  tourism,      // Tourisme
}
