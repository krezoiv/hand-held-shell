import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/screens/shop/presentation/widgets/custom.navigator.drawer.shop.dart';

class SideMenuShop extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenuShop({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<SideMenuShop> createState() => _SideMenuShopState();
}

class _SideMenuShopState extends State<SideMenuShop> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;

    return CustomNavigationDrawerShop(
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
