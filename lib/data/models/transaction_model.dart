import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@Collection()
class Transaction {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String transactionId;
  
  late String userId;
  
  @Enumerated(EnumType.name)
  late TransactionType type;
  
  @Enumerated(EnumType.name)
  late TransactionStatus status;
  
  late double amount;
  late String currency;
  
  // Payment information
  @Enumerated(EnumType.name)
  late PaymentMethod paymentMethod;
  
  late String? paymentReference;
  late String? externalTransactionId;
  
  // Related entities
  late String? ticketId;
  late String? routeId;
  late String? busId;
  
  // Description and metadata
  late String description;
  
  @ignore
  Map<String, dynamic> metadata = {};
  
  // Collector information (for cash transactions)
  late String? collectorId;
  late String? collectorName;
  
  // Timestamps
  late DateTime createdAt;
  late DateTime updatedAt;
  late DateTime? processedAt;
  
  // Offline sync
  late bool isSynced;
  
  Transaction({
    this.transactionId = '',
    this.userId = '',
    this.type = TransactionType.purchase,
    this.status = TransactionStatus.pending,
    this.amount = 0.0,
    this.currency = 'XOF',
    this.paymentMethod = PaymentMethod.cash,
    this.paymentReference,
    this.externalTransactionId,
    this.ticketId,
    this.routeId,
    this.busId,
    this.description = '',
    Map<String, dynamic>? metadata,
    this.collectorId,
    this.collectorName,
    this.processedAt,
    this.isSynced = false,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now() {
    this.metadata = metadata ?? {};
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': transactionId,
      'userId': userId,
      'type': type.name,
      'status': status.name,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod.name,
      'paymentReference': paymentReference,
      'externalTransactionId': externalTransactionId,
      'ticketId': ticketId,
      'routeId': routeId,
      'busId': busId,
      'description': description,
      'metadata': metadata,
      'collectorId': collectorId,
      'collectorName': collectorName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'isSynced': isSynced,
    };
  }
  
  // Create from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    final transaction = Transaction(
      transactionId: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.purchase,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'XOF',
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      paymentReference: json['paymentReference'],
      externalTransactionId: json['externalTransactionId'],
      ticketId: json['ticketId'],
      routeId: json['routeId'],
      busId: json['busId'],
      description: json['description'] ?? '',
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      collectorId: json['collectorId'],
      collectorName: json['collectorName'],
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      isSynced: json['isSynced'] ?? false,
    );
    
    if (json['createdAt'] != null) {
      transaction.createdAt = DateTime.parse(json['createdAt']);
    }
    if (json['updatedAt'] != null) {
      transaction.updatedAt = DateTime.parse(json['updatedAt']);
    }
    
    return transaction;
  }
  
  // Check if transaction is successful
  bool get isSuccessful => status == TransactionStatus.completed;
  
  // Check if transaction is pending
  bool get isPending => status == TransactionStatus.pending;
  
  // Check if transaction failed
  bool get isFailed => status == TransactionStatus.failed;
  
  Transaction copyWith({
    String? transactionId,
    String? userId,
    TransactionType? type,
    TransactionStatus? status,
    double? amount,
    String? currency,
    PaymentMethod? paymentMethod,
    String? paymentReference,
    String? externalTransactionId,
    String? ticketId,
    String? routeId,
    String? busId,
    String? description,
    Map<String, dynamic>? metadata,
    String? collectorId,
    String? collectorName,
    DateTime? updatedAt,
    DateTime? processedAt,
    bool? isSynced,
  }) {
    final newTransaction = Transaction(
      transactionId: transactionId ?? this.transactionId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentReference: paymentReference ?? this.paymentReference,
      externalTransactionId: externalTransactionId ?? this.externalTransactionId,
      ticketId: ticketId ?? this.ticketId,
      routeId: routeId ?? this.routeId,
      busId: busId ?? this.busId,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      collectorId: collectorId ?? this.collectorId,
      collectorName: collectorName ?? this.collectorName,
      processedAt: processedAt ?? this.processedAt,
      isSynced: isSynced ?? this.isSynced,
    );
    
    newTransaction.id = id;
    newTransaction.createdAt = createdAt;
    newTransaction.updatedAt = updatedAt ?? DateTime.now();
    
    return newTransaction;
  }
}

enum TransactionType {
  purchase,     // Achat de billet
  recharge,     // Rechargement de carte
  refund,       // Remboursement
  collection,   // Encaissement (receveur)
}

enum TransactionStatus {
  pending,      // En attente
  processing,   // En cours de traitement
  completed,    // Terminé avec succès
  failed,       // Échoué
  cancelled,    // Annulé
  refunded,     // Remboursé
}

enum PaymentMethod {
  cash,         // Espèces
  card,         // Carte bancaire
  mobileMoney,  // Mobile Money
  prepaidCard,  // Carte prépayée
  wallet,       // Portefeuille électronique
}
