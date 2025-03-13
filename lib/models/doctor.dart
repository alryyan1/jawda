import 'package:jawda/models/doctor_schedule.dart';

class Doctor {
  final int id;
  final String name;
  final String phone;
  final double cashPercentage;
  final double companyPercentage;
  final double staticWage;
  final double labPercentage;
  final int specialistId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int start;
final List<DoctorSchedule> schedules;
  Doctor({
    required this.id,
    required this.name,
    required this.phone,
    required this.cashPercentage,
    required this.companyPercentage,
    required this.staticWage,
    required this.labPercentage,
    required this.specialistId,
    this.createdAt,
    this.updatedAt,
    required this.start,
    required this.schedules,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      cashPercentage: (json['cash_percentage'] as num).toDouble(),
      companyPercentage: (json['company_percentage'] as num).toDouble(),
      staticWage: (json['static_wage'] as num).toDouble(),
      labPercentage: (json['lab_percentage'] as num).toDouble(),
      specialistId: json['specialist_id'] as int,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      schedules: json['schedules'] != null ? (json['schedules'] as List<dynamic>).map((schedule) => DoctorSchedule.fromJson(schedule)).toList() : [] ,
      start: json['start'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'cash_percentage': cashPercentage,
      'company_percentage': companyPercentage,
      'static_wage': staticWage,
      'lab_percentage': labPercentage,
      'specialist_id': specialistId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'start': start,
    };
  }
}