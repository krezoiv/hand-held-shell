import 'package:flutter/material.dart';
import 'package:hand_held_shell/services/auth/auth.service.dart';
import 'package:hand_held_shell/services/sockets/socket.service.dart';
import 'package:provider/provider.dart';
import 'package:hand_held_shell/config/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
