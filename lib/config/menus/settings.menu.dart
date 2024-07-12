import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';

class SettingsMenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const SettingsMenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appSettingsMenuItems = <SettingsMenuItem>[
  SettingsMenuItem(
      title: 'Cambio de Precios',
      subTitle: "cambiar precio de combustile",
      link: RoutesPaths.changePriceScreen,
      icon: CupertinoIcons.money_dollar),
  SettingsMenuItem(
      title: 'Cambiar Contraseña',
      subTitle: "modifcar contraseña",
      link: RoutesPaths.changePassScreen,
      icon: Icons.password_rounded),
  SettingsMenuItem(
      title: 'Cambiar Tema',
      subTitle: "cambiar apariencia",
      link: RoutesPaths.changeThemeScreen,
      icon: Icons.palette_outlined),
  SettingsMenuItem(
      title: 'licencia',
      subTitle: "licencias",
      link: RoutesPaths.licencesHome,
      icon: Icons.manage_accounts_outlined),
];
