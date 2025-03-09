import 'package:jawda/models/client_payment.dart';
import 'package:jawda/models/pharmacy_models.dart';

class Client {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
 List<Deduct> deducts = [];
 List<ClientPayment> payments = [];

  Client({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.deducts,
    required this.payments,
    
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    deducts: json['deducts']!=null ?  json['deducts'].map<Deduct>((deduct) => Deduct.fromJson(deduct)).toList() : [],
    payments: json['payments']!=null ?  json['payments'].map<ClientPayment>((payment) => ClientPayment.fromJson(payment)).toList() : [],
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deducts': deducts.map((deduct) => deduct.toJson()).toList(),
      'payments': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}