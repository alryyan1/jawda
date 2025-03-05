import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/services/dio_client.dart';

class SupplierProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  List<Supplier> _suppliers = [];
  List<Supplier> get suppliers => _suppliers;
  Supplier? _selectedSupplier;
  Supplier? get selectedSupplier => _selectedSupplier;
  //get suppliers
  Future<List<Supplier>> fetchSuppliers(context, String filter) async {
    //use dio
    _loading = true;
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      // notifyListeners();
    }

    //replace with your API call
    final dio = DioClient.getDioInstance(context);
    var response =
        await dio.get('suppliers/all', queryParameters: {'filter': filter});
    final _suppliersAsJson = response.data as List<dynamic>;
    
    List<Supplier> suplliers  = _suppliersAsJson.map((e)=>Supplier.fromJson(e)).toList();
  //  var s = suppliers;
  //  if(s is List){
  //   print(s);
  //  }
    return suplliers;
  }
}
