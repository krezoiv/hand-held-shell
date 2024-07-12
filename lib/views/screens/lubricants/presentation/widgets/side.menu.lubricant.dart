import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/screens/lubricants/presentation/widgets/custom.navigator.drawer.lubricant.dart';

class SideMenuLubricant extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenuLubricant({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<SideMenuLubricant> createState() => _SideMenuLubricantState();
}

class _SideMenuLubricantState extends State<SideMenuLubricant> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;

    return CustomNavigationDrawerLubricant(
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
