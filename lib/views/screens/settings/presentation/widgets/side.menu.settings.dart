import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/screens/settings/presentation/widgets/custom.navigator.drawer.settings.dart';

class SideMenuSettings extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenuSettings({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<SideMenuSettings> createState() => _SideMenuSettingsState();
}

class _SideMenuSettingsState extends State<SideMenuSettings> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;

    return CustomNavigationDrawerSetting(
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
