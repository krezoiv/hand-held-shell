import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static final String apiUrl = dotenv.env['API_URL'] ?? '';
  static final String apiUrlAndroid = dotenv.env['API_URL_ANDROID'] ?? '';
  static final String apiUrlIos = dotenv.env['API_URL_IOS'] ?? '';
  static final String socketUrlAndroid = dotenv.env['SOCKET_URL_ANDROID'] ?? '';
  static final String socketUrlIos = dotenv.env['SOCKET_URL_IOS'] ?? '';
  static final String apiUrlDefault = dotenv.env['API_URL_DEFAULT'] ?? '';
  static final String apiUrlSocketDefault =
      dotenv.env['API_URL_SOCKET_DEFAULT'] ?? '';
}
