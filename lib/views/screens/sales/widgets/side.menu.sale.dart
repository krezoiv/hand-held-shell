import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/screens/sales/widgets/custom.navigator.drawer.sale.dart';

class SideMenuSale extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenuSale({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<SideMenuSale> createState() => _SideMenuSaleState();
}

class _SideMenuSaleState extends State<SideMenuSale> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;

    return CustomNavigationDrawerSale(
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });
      },
      scaffoldKey: widget.scaffoldKey,
      hasNotch: hasNotch,
    );
  }
}
