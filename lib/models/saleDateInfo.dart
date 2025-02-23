import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jawda/constansts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Saledateinfo {
  final DateTime date;
  final int amount;
  final int count;
  const Saledateinfo(
      {required this.date, required this.amount, required this.count});

  factory Saledateinfo.fromJson(json) {
    return Saledateinfo(
        date: DateTime.parse(json['date']),
        amount: json['totalPaid'] as int,
        count: json['count'] as int);
  }

  static Future<List<Saledateinfo>> getData() async {
    //get token
    final shared = await SharedPreferences.getInstance();
    final token = await shared.getString('auth_token');
    try {
      final url =
          Uri(host: host, scheme: schema, path: path + '/searchDeductsByDate2');
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      });
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((info) => Saledateinfo.fromJson(info)).toList();
      } else {
        final result = jsonDecode(response.body);

        throw Exception(result['message']);
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
  static Future<List<Saledateinfo>> getSaleDayDetails() async {
    //get token
    final shared = await SharedPreferences.getInstance();
    final token = await shared.getString('auth_token');
    try {
      final url =
          Uri(host: host, scheme: schema, path: path + '/searchDeductsByDate2');
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      });
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((info) => Saledateinfo.fromJson(info)).toList();
      } else {
        final result = jsonDecode(response.body);

        throw Exception(result['message']);
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
