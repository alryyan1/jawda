import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io' as io; // Import dart:io
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/screens/ledger.dart';
import 'package:jawda/screens/pdf_veiwer.dart';
import '../models/finance_account.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:pdfrx/pdfrx.dart'; // Import pdfrx

const schema = 'http';
// const host = 'alroomy.a.pinggy.link';
// const socketHost = 'altohami.a.pinggy.link';
// const socketHost = 'rnnvc-196-202-136-105.a.free.pinggy.link';
// const host = 'altohami.a.pinggy.link';
const host = '192.168.100.70';
// const host = '192.168.137.1';
// const path = 'mirgani/public/api';
const path = 'laravel-react-app/public/api';
// const path = 'alroomy/public/api';

getHeaders() async {
  final instance = await SharedPreferences.getInstance();
  final token = instance.getString('auth_token');
  return {
    'Authorization': 'Bearer ${token}',
    'Content-Type': 'application/json',
  };
}
  void sendNotification(String id, String message, String title) async {
    final headers = await getHeaders();
    try {
      final url = Uri(host: host, scheme: schema, port: 8000, path: 'msg');
      http.post(url,
          body: jsonEncode({"id": id, "title": title, "description": message}),
          headers: headers);
    } catch (e) {
      throw Exception('cannot create notification ${e.toString()}');
    }
  }
String cleanBase64(String base64String) {
  // Remove everything before the actual base64 data
  RegExp exp = RegExp(r'base64,(.*)');
  Match? match = exp.firstMatch(base64String);

  if (match != null) {
    return match.group(1)!.trim();
  }

  return base64String
      .replaceAll(RegExp(r'\s+'), '') // Remove whitespaces & newlines
      .trim();
}

Future<Uint8List?> generateAndShowPdf(
    String api, BuildContext context, Map<String, String> query) async {
  final url =
      Uri(scheme: schema, host: host, path: path + api, queryParameters: query);

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final String base64Pdf = response.body;
      var cleaned = cleanBase64(base64Pdf);
      return base64Decode(cleaned);
    } else {
      print('Failed to generate PDF: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF')),
      );
    }
  } catch (error) {
    print('Error generating PDF: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred while generating PDF')),
    );
  }
}

Future<T> axios<T>(
  String api,
  Map<String, String> queryParameters,
  T Function(Map<String, dynamic>) fromJson, 
  key
  // Factory for single object
) async {
  final headers = await getHeaders();

  var url = Uri(
    scheme: schema,
    path: path + '/' + api,
    host: host,
    queryParameters: queryParameters,
  );

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if(key != null){

    return fromJson(jsonResponse[key]) as T;
    }else{
    return fromJson(jsonResponse) as T;

    }
  }

  if (response.statusCode == 404 || response.statusCode == 411) {
    var jsonResponse = jsonDecode(response.body);
    throw Exception(jsonResponse['message']);
  } else {
    throw Exception('Error fetching data from API');
  }
}
Future<List<T>> axiosList<T>(
  String api,
  Map<String, String> queryParameters,
  T Function(Map<String, dynamic>) fromJson, // Factory for single object
 String? key
) async {
  final headers = await getHeaders();

  var url = Uri(
    scheme: schema,
    path: path + '/' + api,
    host: host,
    queryParameters: queryParameters,
  );

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {

    var jsonResponse = jsonDecode(response.body) as List<dynamic>;
      if(key != null){
    return jsonResponse.map((e)=>fromJson(e)).toList().cast<T>();

      }else{
    return jsonResponse.map((e)=>fromJson(e)).toList().cast<T>();

      }
  }

  if (response.statusCode == 404 || response.statusCode == 411) {
    var jsonResponse = jsonDecode(response.body);
    throw Exception(jsonResponse['message']);
  } else {
    throw Exception('Error fetching data from API');
  }
}
