import 'package:jawda/models/finance_account.dart';

class Expense {
  final int id;
  final DateTime date;
  final String amount;
  final String beneficiary;
  final String description;
  final dynamic pdfFile;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? financeEntryId;
  final int userId;
  final String? signatureFileName;
  final FinanceEntry? entry;
  final DateTime? managerApprovalTime;
  final DateTime? auditorApprovalTime;

  Expense({
    required this.id,
    required this.date,
    required this.amount,
    required this.beneficiary,
    required this.description,
    this.pdfFile,
    required this.createdAt,
    required this.updatedAt,
    required this.financeEntryId,
    required this.userId,
    required this.signatureFileName,
    required this.entry,
    this.managerApprovalTime,
    this.auditorApprovalTime,
  
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      amount: json['amount'] as String,
      beneficiary: json['beneficiary'] as String,
      description: json['description'] as String,
      pdfFile: json['pdf_file'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      financeEntryId: json['finance_entry_id'] != null ?  json['finance_entry_id'] as int : null,
      userId: json['user_id'] as int,
      signatureFileName: json['signature_file_name'] as String?,
      entry: json['entry'] != null ?  FinanceEntry.fromJson(json['entry'] as Map<String, dynamic>) : null,
      managerApprovalTime: json['user_approved_time'] != null? DateTime.parse(json['user_approved_time'] as String) : null,
      auditorApprovalTime: json['auditor_approved_time'] != null? DateTime.parse(json['auditor_approved_time'] as String) : null,
    );
  }
}

