import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class Environment {
//   static String nameEnv = '.env';
//   static initEnvironment() async {
//     await dotenv.load(fileName: nameEnv);
//   }

//   static String get apiUrl {
//     if (EnvConfig.apiUrl.isNotEmpty) {
//       return EnvConfig.apiUrl;
//     }

//     if (Platform.isAndroid) {
//       return EnvConfig.apiUrlAndroid.isNotEmpty
//           ? EnvConfig.apiUrlAndroid
//           : EnvConfig.apiUrlAndroid;
//     } else if (Platform.isIOS) {
//       return EnvConfig.apiUrlIos.isNotEmpty
//           ? EnvConfig.apiUrlIos
//           : EnvConfig.apiUrlIos;
//     }

//     return EnvConfig.apiUrlDefault.isNotEmpty
//         ? EnvConfig.apiUrlDefault
//         : EnvConfig.apiUrlDefault;
//   }

//   static String get socketUrl {
//     if (Platform.isAndroid) {
//       return EnvConfig.socketUrlAndroid.isNotEmpty
//           ? EnvConfig.socketUrlAndroid
//           : EnvConfig.socketUrlAndroid;
//     } else if (Platform.isIOS) {
//       return EnvConfig.socketUrlIos.isNotEmpty
//           ? EnvConfig.socketUrlIos
//           : EnvConfig.socketUrlIos;
//     }

//     return EnvConfig.apiUrlSocketDefault.isNotEmpty
//         ? EnvConfig.apiUrlSocketDefault
//         : EnvConfig.apiUrlSocketDefault;
//   }
// }

// class Environment {
//   static String nameEnv = '.env';
//   static initEnvironment() async {
//     await dotenv.load(fileName: nameEnv);
//   }

//   static String get apiUrl {
//     // Primero intenta obtener el valor del .env
//     String? envApiUrl = dotenv.env['API_URL'];
//     if (envApiUrl != null && envApiUrl.isNotEmpty) {
//       return envApiUrl;
//     }

//     // Si no está en .env, usa los valores por defecto según la plataforma
//     if (Platform.isAndroid) {
//       return const String.fromEnvironment('API_URL',
//           defaultValue: 'http://192.168.1.148:3000/api');
//     } else if (Platform.isIOS) {
//       return const String.fromEnvironment('API_URL',
//           defaultValue: 'http://localhost:3000/api');
//     }

//     // Valor por defecto final
//     return 'http://localhost:3000/api';
//   }

//   static String get socketUrl {
//     // Primero intenta obtener el valor del .env
//     String? envSocketUrl = dotenv.env['SOCKET_URL'];
//     if (envSocketUrl != null && envSocketUrl.isNotEmpty) {
//       return envSocketUrl;
//     }

//     // Si no está en .env, usa los valores por defecto según la plataforma
//     if (Platform.isAndroid) {
//       return const String.fromEnvironment('SOCKET_URL',
//           defaultValue: 'http://192.168.1.148:3000');
//     } else if (Platform.isIOS) {
//       return const String.fromEnvironment('SOCKET_URL',
//           defaultValue: 'http://localhost:3000');
//     }

//     // Valor por defecto final
//     return 'http://localhost:3000';
//   }
// }

class Environment {
  static String nameEnv = '.env';
  static initEnvironment() async {
    await dotenv.load(fileName: nameEnv);
  }

  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.0.106:3000/api'
      : 'http://localhost:3000/api';

  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.0.106:3000'
      : 'http://localhost:3000';
}
