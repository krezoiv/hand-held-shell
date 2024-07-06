import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';
import 'package:hand_held_shell/views/screens/users/users.exports.files.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => const UserScreen(),
  'chat': (_) => const ChatScreen(),
  'loading': (_) => const LoadingScreen(),
  'login': (_) => const LoginScreen(),
  'licences': (_) => const LicencesScreen(),
};
