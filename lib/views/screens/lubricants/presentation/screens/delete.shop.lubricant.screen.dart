import 'package:flutter/material.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/lubricants/presentation/widgets/side.menu.lubricant.dart';

class DeleteShopLubricantScreen extends StatelessWidget {
  const DeleteShopLubricantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Delete Lubricantes'),
      ),
      drawer: SideMenuLubricant(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
