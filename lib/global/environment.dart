import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiUrl {
    if (Platform.isAndroid) {
      return const String.fromEnvironment('API_URL',
          defaultValue: 'http://192.168.1.148:3000/api');
    } else if (Platform.isIOS) {
      return const String.fromEnvironment('API_URL',
          defaultValue: 'http://localhost:3000/api');
    }
    return dotenv.env['API_URL'] ?? 'http://localhost:3000/api';
  }

  static String get socketUrl {
    if (Platform.isAndroid) {
      return const String.fromEnvironment('SOCKET_URL',
          defaultValue: 'http://192.168.1.148:3000');
    } else if (Platform.isIOS) {
      return const String.fromEnvironment('SOCKET_URL',
          defaultValue: 'http://localhost:3000');
    }
    return dotenv.env['SOCKET_URL'] ?? 'http://localhost:3000.com';
  }
}

// class Environment {
//   static String apiUrl = Platform.isAndroid
//       ? 'http://192.168.0.106:3000/api'
//       : 'http://localhost:3000/api';

//   static String socketUrl = Platform.isAndroid
//       ? 'http://192.168.0.106:3000'
//       : 'http://localhost:3000';
// }
