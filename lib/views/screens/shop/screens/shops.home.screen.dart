import 'package:flutter/material.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/side.menu.shop.dart';

class ShopsHomeScreen extends StatelessWidget {
  const ShopsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        key: scaffoldKey,
        title: const Text('Compras'),
      ),
      drawer: SideMenuShop(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
