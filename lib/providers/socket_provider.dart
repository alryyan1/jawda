import 'package:flutter/widgets.dart';
import 'package:jawda/constansts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider with ChangeNotifier {
  IO.Socket? _socket; // Socket Instance
  IO.Socket? get socket => _socket; // Socket Instance

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