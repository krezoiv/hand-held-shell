import 'package:flutter/material.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';

class DeleteAllRegisterDispenserScreen extends StatelessWidget {
  const DeleteAllRegisterDispenserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Delete All'),
      ),
      drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
