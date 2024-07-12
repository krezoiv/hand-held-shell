import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/screens/dispensers/presentation/widgets/custom.navigator.drawer.dispenser.dart';

class SideMenuDispenser extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenuDispenser({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<SideMenuDispenser> createState() => _SideMenuDispenserState();
}

class _SideMenuDispenserState extends State<SideMenuDispenser> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;

    return CustomNavigationDrawerDispenser(
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
