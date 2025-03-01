import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/Shift.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:jawda/services/dio_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ShiftProvider with ChangeNotifier {
  Shift? _shift;
  Deduct? _selectedDedduct;
  String? _errorMessage;
  bool _isLoading = false;
  IO.Socket? _socket; // Socket Instance

  get isLoading => _isLoading;
  Shift? get shift => _shift;
  Deduct? get SelectedDeduct => _selectedDedduct;
  //set
  set setSelectedDeduct(Deduct value){
      _selectedDedduct = value;
      notifyListeners();
  
  }
  get errorMessage => _errorMessage;
  IO.Socket? get socket => _socket; // Socket Instance
  Future<void> fetchShift([int? id]) async {
    _isLoading = true;
    _errorMessage = null;
    try {
      _shift = await Shift.getShiftById(id);
    } catch (e) {
      _errorMessage = "Error $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  saveDeductItems(List<Item> items, Deduct deduct,BuildContext context) async {
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

        sendMessage('update deduct', jsonEncode(_selectedDedduct!.toJson()));
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
    } else {
      print('deduct not found');
    }
    sendMessage('update deduct', jsonEncode(deduct));
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
      sendMessage('new deduct', jsonEncode(_selectedDedduct!.toJson()));
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    } finally {
      //  print(object)
      _isLoading = false;
      notifyListeners();
    }
  }

 deleteDeductItem( DeductItem deductItem,BuildContext context) async {
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

        sendMessage('update deduct', jsonEncode(_selectedDedduct!.toJson()));
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


  Future<void> connectSocket() async {
    try {
      _socket = IO.io('http://${host}:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      _socket!.onConnect((_) {
        print('Connected to Socket.IO server');
        _socket!.emit('msg', 'Flutter app connected');
      });

      _socket!.on('chat message', (data) {
        print('Received message: $data');
        notifyListeners();
      });

      _socket!.onDisconnect((_) => print('Disconnected'));
      _socket!.onError((err) => print(err));
      notifyListeners();
    } catch (e) {
      print('Error connecting to Socket.IO server: $e');
    }
  }

  void disconnectSocket() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      notifyListeners();
    }
  }

  void sendMessage(String event, dynamic data) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit(event, data);
    } else {
      print('Socket not connected or initialized');
    }
  }
}
