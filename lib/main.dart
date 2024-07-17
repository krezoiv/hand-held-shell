import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/login.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';
import 'package:hand_held_shell/services/auth/users.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/config/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloquear la orientación de la aplicación a portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializa el entorno (descomenta si es necesario)
  // await Environment.initEnvironment();

  // Inicializa los servicios
  Get.put(AuthService());
  Get.put(ChatService());
  Get.put(SocketService(), permanent: true);
  Get.put(UserService());

  // Conecta el socket después de inicializar los servicios
  final socketService = Get.find<SocketService>();
  await socketService.connect();

  // Ahora que el socket está conectado, inicializa el UserController
  Get.put(LoginController());

  // Inicializa el ThemeController
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene el ThemeController
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      // Utiliza el tema actual del ThemeController
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: AppRoutes.initialRoute,
        getPages: AppRoutes.routes,
        theme: themeController.appTheme.value.getTheme(),
      );
    });
  }
}
