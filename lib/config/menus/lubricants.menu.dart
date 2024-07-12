import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';

class LubricantsMenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const LubricantsMenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appSettingMenuItems = <LubricantsMenuItem>[
  LubricantsMenuItem(
      title: 'Eliminar Compra',
      subTitle: "registrar compra",
      link: RoutesPaths.deleteShopLubricant,
      icon: CupertinoIcons.trash_fill),
  LubricantsMenuItem(
      title: 'Modificar Compra',
      subTitle: "modifcar compra",
      link: RoutesPaths.modifyShopLubricant,
      icon: Icons.sync),
  LubricantsMenuItem(
      title: 'Nueva Compra',
      subTitle: "eliminar compra",
      link: RoutesPaths.newShopLubricants,
      icon: CupertinoIcons.shopping_cart),
  LubricantsMenuItem(
      title: 'Buscar Compra',
      subTitle: "consulta de compra",
      link: RoutesPaths.searchShopLubricant,
      icon: CupertinoIcons.search)
];
