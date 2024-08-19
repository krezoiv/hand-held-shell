import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String nameEnv = '.env';
  static initEnvironment() async {
    await dotenv.load(fileName: nameEnv);
  }

  static String get apiUrl {
    if (Platform.isAndroid) {
      return 'http://192.168.1.148:3000/api'; // Asegúrate de que esta IP es correcta
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/api';
    }
    throw UnsupportedError('Plataforma no soportada');
  }

  static String get socketUrl {
    if (Platform.isAndroid) {
      return 'http:/192.168.1.148:3000'; // Para emulador de Android
    } else if (Platform.isIOS) {
      return 'http://localhost:3000';
    }
    throw UnsupportedError('Plataforma no soportada');
  }
}


//192.168.1.148 ofic
//192.168.0.103  casa