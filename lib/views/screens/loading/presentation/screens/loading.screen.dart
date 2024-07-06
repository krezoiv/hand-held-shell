import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }
}

Future checkLoginState(BuildContext context) async {
  final authService = Provider.of<AuthService>(context, listen: false);
  //final authenticated = await authService.isUserLoggedIn();
}
