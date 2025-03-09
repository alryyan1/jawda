import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/services/dio_client.dart';

class DepositProvider with ChangeNotifier {

  bool _loading = false;
  String? _errorMessage;

  List<Deposit> _deposits = [];
  Deposit? _selectedDeposit;
  Deposit get selectedDeposit => _selectedDeposit!;
 List<Deposit> _loadedDeposits = [];
 List<Deposit> get loadedDeposits => _loadedDeposits;
void setLoadedDeposits(data){
    _loadedDeposits =data;
    notifyListeners();
}
void addDeposits(deposits){
    _loadedDeposits.addAll(deposits);
    notifyListeners();
}
  void setSelectedDeposit(Deposit? deposit) {
    _selectedDeposit = deposit;
    notifyListeners();
  }
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  List<Deposit> get deposits => _deposits;


  Future<List<Deposit>> fetchDeposits(context,int page) async {
    try {
       _loading = true;
       _errorMessage = null;
      //  notifyListeners();
       //dio
       final dio = DioClient.getDioInstance(context);
       final response = await dio.get(
         'allDepositsByPulse',
         queryParameters: {'page':page}
       );

       final dataAsJson = response.data;
      final depositsAsJson = dataAsJson['data'] as List<dynamic>;
       return depositsAsJson.map((e)=>Deposit.fromJson(e)).toList();
    } catch (e) {
       _errorMessage = 'Failed to fetch deposits: $e';
       print(_errorMessage);
       rethrow;
    }
    finally {
       _loading = false;
      //  notifyListeners();
    }
  }
  Future<Deposit> getDeposit(id,context) async {
    try {
       _loading = true;
       _errorMessage = null;
      //  notifyListeners();
       //dio
       final dio = DioClient.getDioInstance(context);
       final response = await dio.get(
         'inventory/deposit/getDepositById/$id',
       );

       final dataAsJson = response.data;
       final deposit = Deposit.fromJson(dataAsJson['data']);
       _selectedDeposit = deposit;
       notifyListeners();
       return deposit;
 
    } catch (e) {
       _errorMessage = 'Failed to fetch deposits: $e';
       print(_errorMessage);
       rethrow;
    }
    finally {
       _loading = false;
      //  notifyListeners();
    }
  }
   Future<Deposit> addDeposit(Deposit deposit,context) async {
    try {
       _loading = true;
       _errorMessage = null;
      //  notifyListeners();
       //dio
       final dio = DioClient.getDioInstance(context);
       final response = await dio.post(
         'inventory/deposit/newDeposit',
         data: {
          'bill_date':DateFormat('yyyy-MM-dd').format(deposit.createdAt),
           'bill_number':deposit.billNumber,
           'supplier_id':deposit.supplier.id
         },
       );

       final dataAsJson = response.data;
      
       final Deposit addedDeposit =  Deposit.fromJson(dataAsJson['data']);
       _loadedDeposits.insert(0, addedDeposit);
       notifyListeners();
        return addedDeposit;
    } catch (e) {
       _errorMessage = 'Failed to add new deposit: $e';
       print(_errorMessage);
       rethrow;
    }
    finally {
       _loading = false;
      //  notifyListeners();
    }
  }
 Future<Deposit?> saveDepositItems(List<Item> items, Deposit deposit,BuildContext context) async {
    
    
    try {
      
            _loading = true;
      _errorMessage = null;
      notifyListeners();
      final dio = DioClient.getDioInstance(context);

      final response = await dio.post('itemsDepositMobile/${deposit.id}', data: {
        'items': items.map((item) => item.id).toList()
      });
      if (response.statusCode == 200) {
        print('Items saved successfully');
        var data = response.data;
         _selectedDeposit = Deposit.fromJson(data);
         notifyListeners();
         return _selectedDeposit;

      }
    } catch (e) {
      throw Exception(e.toString());
    }
    finally {
       _loading = false;
      notifyListeners();
    }

 }



}