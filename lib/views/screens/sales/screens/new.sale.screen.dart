import 'package:flutter/material.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/sales/widgets/side.menu.sale.dart';

class NewSalesScreen extends StatelessWidget {
  const NewSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('New Sales'),
      ),
      drawer: SideMenuSale(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
