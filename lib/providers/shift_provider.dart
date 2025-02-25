import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/Shift.dart';
import 'package:jawda/models/pharmacy_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class ShiftProvider with ChangeNotifier {
  Shift? _shift;
  String? _errorMessage;
  bool _isLoading = false;
    IO.Socket? _socket; // Socket Instance

  get isLoading => _isLoading;
 Shift? get shift => _shift;
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

  Future<void> addDeduct() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      var deduct = await axios<Deduct>(
          'inventory/deduct/new', {'is_sell': "1"}, Deduct.fromJson,'data');
      _shift!.deducts.insert(0,deduct);
      sendMessage('new deduct', jsonEncode(deduct.toJson()));
      notifyListeners();
    } catch (e) {
       throw Exception(e);
    }finally {
      //  print(object)
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
  void sendMessage(String event , dynamic data) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit(event, data);
    } else {
      print('Socket not connected or initialized');
    }
  }
}
