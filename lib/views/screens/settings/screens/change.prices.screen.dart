import 'package:flutter/material.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/settings/widgets/side.menu.settings.dart';

class ChangePriceScreen extends StatelessWidget {
  const ChangePriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        key: scaffoldKey,
        title: const Text('ChangePrice'),
      ),
      drawer: SideMenuSettings(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
