import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class EnvConfig extends GetxController {
  static EnvConfig get to => Get.find();

  String apiUrl = dotenv.env['API_URL'] ?? '';
  final String apiUrlAndroid = dotenv.env['API_URL_ANDROID'] ?? '';
  final String apiUrlIos = dotenv.env['API_URL_IOS'] ?? '';
  final String socketUrlAndroid = dotenv.env['SOCKET_URL_ANDROID'] ?? '';
  final String socketUrlIos = dotenv.env['SOCKET_URL_IOS'] ?? '';
  final String apiUrlDefault = dotenv.env['API_URL_DEFAULT'] ?? '';
  final String apiUrlSocketDefault = dotenv.env['API_URL_SOCKET_DEFAULT'] ?? '';

  // Si necesitas actualizar algún valor en tiempo de ejecución
  void updateApiUrl(String newUrl) {
    apiUrl = newUrl;
    update();
  }

  // Inicializa la configuración
  static Future<void> init() async {
    await dotenv.load(); // Asegúrate de cargar las variables de entorno
    Get.put(EnvConfig());
  }
}
