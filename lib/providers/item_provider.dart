import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/services/dio_client.dart';
import '../models/client.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = List.empty();
  bool _loading = false;
  String? _errorMessage;
  List<Item> get items => _items;
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<Type> _types = [];
  List<Type> get types => _types;

  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;

  Future<List<Category>> getCategories(String filter,context) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final dio = DioClient.getDioInstance(context);
      final response = await dio.get('drugCategory',queryParameters: {
        'filter':filter
      });
      if (response.statusCode == 200) {
        final categoriesAsJson  = response.data as List<dynamic>;
        return  categoriesAsJson.map((e)=>Category.fromJson(e)).toList();
    
      } else {
        _errorMessage = 'Failed to get categories: ${response.statusCode}';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
     finally {
      _loading = false;
      notifyListeners();
     }
     return [];

  }
Future<List<Type>> getTypes(filter,context) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final dio = DioClient.getDioInstance(context);
      final response = await dio.get('pharmacyTypes',queryParameters: {
        'filter':filter
      });
      if (response.statusCode == 200) {
        final typesAsJson  = response.data as List<dynamic>;
        return  typesAsJson.map((e)=>Type.fromJson(e)).toList();
    
      } else {
        _errorMessage = 'Failed to get types: ${response.statusCode}';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
     finally {
      _loading = false;
      notifyListeners();
     }
     return [];

  }

  Future<void> editItem(Map<String,dynamic> itemAsMap, context,id) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dio = DioClient.getDioInstance(context);
      final response = await dio.patch('items-update/$id',data: jsonEncode(itemAsMap));

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Edit Item successfully ');
        final itemAsJson =  response.data;
        final item   = Item.fromJson(itemAsJson['data']);
        // Update the local list
        final index = _items.indexWhere((element) => element.id == id);
        if (index != -1) {
          _items[index] = item ;
        }
      } else {
        _errorMessage = 'Failed to Edit Item: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error add Item : $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(Map<String,dynamic> item, context) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dio = DioClient.getDioInstance(context);
      final response = await dio.post('drugs', data: jsonEncode(item));
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Add Item successfully ');
        // _items.add(item); // Update the local list
      } else {
        _errorMessage = 'Failed to addItem: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error add Item : $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
    ;
  }

  Future<void> getItems(String filter) async {
    _loading = true;
    _errorMessage = null;
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      notifyListeners();
    }
    try {
      _items = await axiosList<Item>(
          'items/all', {'name': filter}, Item.fromJson, null);
      notifyListeners();
      // return _items;
    } catch (e) {
      throw Exception(
        'Failed to fetch items: $e',
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
