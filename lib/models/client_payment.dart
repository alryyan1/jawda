class ClientPayment {
  final int id;
  final double amount;
  final int clientId;
  final DateTime paymentDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientPayment({
    required this.id,
    required this.amount,
    required this.clientId,
    required this.paymentDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Payment object from JSON
  factory ClientPayment.fromJson(Map<String, dynamic> json) {
    return ClientPayment(
      id: json['id'],
      amount: (double.parse(json['amount']) as num).toDouble(),
      clientId: json['client_id'],
      paymentDate: DateTime.parse(json['payment_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert Payment object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'client_id': clientId,
      'payment_date': paymentDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
