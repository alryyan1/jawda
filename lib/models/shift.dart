import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:http/http.dart' as http;
import 'package:jawda/models/shift_deduct_summary.dart';

class Shift {
  int id;
  DateTime created_at;
  DateTime updated_at;
  int bank;
  // List cost;
  List<Deduct> deducts;
  int expenses;
  bool is_closed;
  int maxShiftId;
  // List patients;
  // List specialists;
  int total;
  bool touched;
  Shift({
    required this.id,
    required this.created_at,
    required this.updated_at,
    required this.bank,
    // required this.cost,
    required this.deducts,
    required this.expenses,
    required this.is_closed,
    required this.maxShiftId,
    // required this.patients,
    required this.total,
    required this.touched,
    // required this.specialists,
  });

  factory Shift.fromJson(json) {
    return Shift(
      id: json['id'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
      bank: json['bank'],
      // cost: json['cost'].map((cost) => Cost.fromJson(cost)).toList(),
      deducts:
          (json['deducts'] as List<dynamic>).map((deduct) => Deduct.fromJson(deduct)).toList(),
      expenses: json['expenses'],
      is_closed: json['is_closed'] == 1,
      maxShiftId: json['maxShiftId'],
      // patients: json['patients'],
      // specialists: json['specialists'],
      total: json['total'],
      touched: json['touched'] == 1,
    );
  }
    static Future<Shift> getShiftById([int? id] ) async {
    try {
      Uri url =
          Uri(scheme: schema, host: host, path: path + '/shiftById/${id}',queryParameters: {
            'relation':'deducts',
          });
          final headers = await getHeaders();
      http.Response response = await http.get(url,headers:headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        Shift shift = Shift.fromJson(jsonData['data']);
        return shift;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e ');
      rethrow;
    }
  }
  static Future<List<ShiftDeductSummary>> getShiftDeductsSummaries(DateTime date) async {
    try {
      Uri url =
          Uri(scheme: schema, host: host, path: path + '/getShiftByDatePharmacy',queryParameters: {
            'date': DateFormat('yyyy-MM-dd').format(date).toString(),
          });
          final headers = await getHeaders();
      http.Response response = await http.get(url,headers:headers);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<ShiftDeductSummary> shifts = jsonData.map((s)=>ShiftDeductSummary.fromJson(s)).toList();
        print(shifts.length);
        return shifts;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}