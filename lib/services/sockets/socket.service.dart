import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/environment.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService extends GetxController {
  final Rx<ServerStatus> _serverStatus = ServerStatus.Connecting.obs;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus.value;
  io.Socket get socket => _socket;

  @override
  void onInit() {
    super.onInit();
    _initConfig();
  }

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
        _serverStatus.value = ServerStatus.Online;
      });

      _socket.onDisconnect((_) {
        _serverStatus.value = ServerStatus.Offline;
      });

      _socket.onConnectError((err) {
        _serverStatus.value = ServerStatus.Offline;
      });

      _socket.connect();
    } catch (e) {
      _serverStatus.value = ServerStatus.Offline;
    }
  }

  void on(String event, Function(dynamic) handler) {
    _socket.on(event, handler);
  }

  void emit(String event, dynamic data) => _socket.emit(event, data);

  void disconnect() {
    _socket.disconnect();
    _serverStatus.value = ServerStatus.Offline;
  }
}
