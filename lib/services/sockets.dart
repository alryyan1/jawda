import 'package:jawda/constansts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket _socket;

  SocketService._internal() {
    _socket = IO.io('${schema}://${socketHost}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      print('Connected to Socket.IO server');
      _socket.emit('msg', 'Flutter app connected');
    });

    _socket.on('flutter', (data) {
      print('Received: $data');
    });

    _socket.onDisconnect((_) => print('Socket Disconnected'));
    _socket.onError((err) => print('Socket Error: $err'));
  }

  void sendMessage(String event, dynamic data) {
    if (_socket.connected) {
      _socket.emit(event, data);
    } else {
      print('Socket not connected');
    }
  }

  void disconnectSocket() {
    _socket.disconnect();
    _socket.dispose();
  }

  IO.Socket get socket => _socket;
}
