import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/pharmacy_models.dart';
import '../models/client.dart';
class ItemProvider with ChangeNotifier {
  List<Item> _items = List.empty();
  bool _loading = false;
  String? _errorMessage ;
  List<Item> get items => _items;
  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> getItems (String filter) async {
     _loading = true;
     _errorMessage = null;
     if(SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle){
     notifyListeners();

     }
     try {
        _items =  await  axiosList<Item>('items/all', {'name':filter}, Item.fromJson, null);
        notifyListeners();
      // return _items;
     } catch (e) {
      throw Exception(
        'Failed to fetch items: $e',
      );
       
     }
     finally {
      _loading = false;
      notifyListeners();

     }
  }

}
