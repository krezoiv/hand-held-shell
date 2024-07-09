import 'package:flutter/material.dart';
import 'package:hand_held_shell/config/global/environment.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  SocketService() {
    _initConfig();
  }

  io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void _initConfig() async {
    await connect();
  }

  Future<void> connect() async {
    final token = await AuthService.getToken();

    try {
      _socket = io.io(Environment.socketUrl, {
        'transports': ['websocket'],
        'autoConnect': true,
        'forceNew': true,
        'extraHeaders': {'x-token': token}
      });

      _socket.onConnect((_) {
        _serverStatus = ServerStatus.Online;
        notifyListeners();
      });

      _socket.onDisconnect((_) {
        _serverStatus = ServerStatus.Offline;
        notifyListeners();
      });

      _socket.onConnectError((err) {
        _serverStatus = ServerStatus.Offline;
        notifyListeners();
      });

      _socket.connect(); // Espera a que se conecte
    } catch (e) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    }
  }

  void disconnect() {
    _socket.disconnect();
    _serverStatus = ServerStatus.Offline;
    notifyListeners();
  }
}
