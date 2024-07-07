import 'package:flutter/material.dart';
import 'package:hand_held_shell/global/environment.dart';
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

  io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    connect();
  }

  void connect() async {
    final token = await AuthService
        .getToken(); // Asegúrate de esperar a que se resuelva el Future
    _socket = io.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('connect_error', (error) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
    _serverStatus = ServerStatus.Offline;
    notifyListeners();
  }
}
