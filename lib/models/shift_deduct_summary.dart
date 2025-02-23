class ShiftDeductSummary {
  double insurancePaid;
  double totalInsurance;
  double fullTotal;
  double totalDeductsPrice;
  double totalDeductsPaid;
  double totalDeductsPriceBank;
  double totalDeductsPriceCash;
  DateTime created_at;

  ShiftDeductSummary({
    required this.insurancePaid,
    required this.totalInsurance,
    required this.fullTotal,
    required this.totalDeductsPrice,
    required this.totalDeductsPaid,
    required this.totalDeductsPriceBank,
    required this.totalDeductsPriceCash,
    required this.created_at,
  });

  factory ShiftDeductSummary.fromJson(Map<String, dynamic> json) {
    return ShiftDeductSummary(
      insurancePaid: json['insurance_paid']?.toDouble() ?? 0.0,
      totalInsurance: json['total_insurance']?.toDouble() ?? 0.0,
      fullTotal: json['full_total']?.toDouble() ?? 0.0,
      totalDeductsPrice: json['totalDeductsPrice']?.toDouble() ?? 0.0,
      totalDeductsPaid: json['totalDeductsPaid']?.toDouble() ?? 0.0,
      totalDeductsPriceBank: json['totalDeductsPriceBank']?.toDouble() ?? 0.0,
      totalDeductsPriceCash: json['totalDeductsPriceCash']?.toDouble() ?? 0.0,
      created_at: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': created_at.toUtc().toString(),
      'insurance_paid': insurancePaid,
      'total_insurance': totalInsurance,
      'full_total': fullTotal,
      'totalDeductsPrice': totalDeductsPrice,
      'totalDeductsPaid': totalDeductsPaid,
      'totalDeductsPriceBank': totalDeductsPriceBank,
      'totalDeductsPriceCash': totalDeductsPriceCash,
    };
  }
}