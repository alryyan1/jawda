import 'package:jawda/models/pharmacy_models.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:http/http.dart' as http;
import 'package:jawda/models/shift_deduct_summary.dart';
class ExpireData {
  final String firstofMonth;
  final String lastofmonth;
  final List<Item> items;
  final String monthname;
  final int year;

  ExpireData({
    required this.firstofMonth,
    required this.lastofmonth,
    required this.items,
    required this.monthname,
    required this.year,
  });

     static Future<List<ExpireData>> getData() async {
    try {
      Uri url =
          Uri(scheme: schema, host: host, path: path + '/expireMonthPanel');
          final headers = await getHeaders();
      http.Response response = await http.get(url,headers:headers);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> data = jsonData['data'];
        List<ExpireData> expireData = data.map((e)=>ExpireData.fromJson(e)).toList();
        return expireData;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  factory ExpireData.fromJson(Map<String, dynamic> json) {
    return ExpireData(
      firstofMonth: json['firstofMonth'] as String,
      lastofmonth: json['lastofmonth'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
          .toList(),
      monthname: json['monthname'] as String,
      year: json['year'] as int,
    );
  }
}

  