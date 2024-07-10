import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/services/auth/users.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/config/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.routes,
      // Si necesitas alguna configuración global, puedes agregarla aquí
      // Por ejemplo:
      // theme: ThemeData(...),
      // translations: MyTranslations(),
      // locale: Locale('en', 'US'),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:hand_held_shell/config/global/environment.dart';
// //import 'package:hand_held_shell/config/global/environment.dart';
// import 'package:provider/provider.dart';
// import 'package:hand_held_shell/services/services.exports.files.dart';
// import 'package:hand_held_shell/config/routes/routes.dart';

// void main() async {
//   //await Environment.initEnvironment();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthService()),
//         ChangeNotifierProvider(create: (_) => ChatService()),
//         ChangeNotifierProvider(create: (_) => SocketService()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Material App',
//         initialRoute: 'loading',
//         routes: appRoutes,
//       ),
//     );
//   }
// }
