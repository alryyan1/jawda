import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/Shift.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/services/dio_client.dart';

class ShiftProvider with ChangeNotifier {
  Shift? _shift;
  Deduct? _selectedDedduct;
  String? _errorMessage;
  bool _isLoading = false;

  get isLoading => _isLoading;
  Shift? get shift => _shift;
  Deduct? get SelectedDeduct => _selectedDedduct;
  //set
  set setSelectedDeduct(Deduct value){
      _selectedDedduct = value;
      // notifyListeners();
  
  }
  get errorMessage => _errorMessage;
  Future<void> fetchShift([int? id]) async {
    _isLoading = true;
    _errorMessage = null;
    try {
      _shift = await Shift.getShiftById(id);
    } 
    on TypeError catch(e){
      _errorMessage = "Error $e  at ${e.stackTrace}";

    }
    catch (e) {
      _errorMessage = "Error $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 Future<Deduct?> saveDeductItems(List<Item> items, Deduct deduct,BuildContext context) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final dio = DioClient.getDioInstance(context);
      final response = await dio.post('addDrugForSell', data: {
        'deduct_id': deduct.id,
        'selectedDrugs': items.map((item) => item.id).toList()
      });
      if (response.statusCode == 200) {
        print('Items saved successfully');
        var data = response.data;
         _selectedDedduct = Deduct.fromJson(data['data']);

        //update this deduct in shift.deducts
        int indexOf = shift!.deducts.indexWhere((d) => d.id == _selectedDedduct!.id);

        if (indexOf != -1) {
          shift!.deducts[indexOf] = _selectedDedduct!;
          notifyListeners();
        } else {
          print('deduct not found');
        }
    return _selectedDedduct;
        // sendMessage('update deduct', jsonEncode(_selectedDedduct!.toJson()));
      } else {
        print('Error saving items');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateAndNotify(Map<String, dynamic> deduct) {
    final deductObj = Deduct.fromJson(deduct);
    int indexOf = shift!.deducts.indexWhere((d) => d.id == deductObj.id);
    if (indexOf != -1) {
      shift!.deducts[indexOf] = deductObj;
      _selectedDedduct = deductObj;
      notifyListeners();
    } else {
      print('deduct not found');
    }
    // sendMessage('update deduct', jsonEncode(deduct));
    notifyListeners();
  }

  Future<void> addDeduct() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
       _selectedDedduct = await axios<Deduct>(
          'inventory/deduct/new', {'is_sell': "1"}, Deduct.fromJson, 'data');
      _shift!.deducts.insert(0, _selectedDedduct!);
      // sendMessage('new deduct', jsonEncode(_selectedDedduct!.toJson()));
      notifyListeners();
    } 
    on TypeError catch(e){
      _errorMessage = "Error $e  at ${e.stackTrace}";
    }
    catch (e) {
      throw Exception(e);
    } finally {
      //  print(object)
      _isLoading = false;
      notifyListeners();
    }
  }

 Future<Deduct?> deleteDeductItem( DeductItem deductItem,BuildContext context) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final dio = DioClient.getDioInstance(context);
      final response = await dio.delete('inventory/deduct/${deductItem.id}');
      if (response.statusCode == 200) {
        print('Items saved successfully');
        var data = response.data;
         _selectedDedduct = Deduct.fromJson(data['data']);

        //update this deduct in shift.deducts
        int indexOf = shift!.deducts.indexWhere((d) => d.id == _selectedDedduct!.id);

        if (indexOf != -1) {
          shift!.deducts[indexOf] = _selectedDedduct!;
          notifyListeners();
        } else {
          print('deduct not found');
        }
        return _selectedDedduct;

        // sendMessage('update deduct', jsonEncode(_selectedDedduct!.toJson()));
      } else {
        print('Error saving items');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
