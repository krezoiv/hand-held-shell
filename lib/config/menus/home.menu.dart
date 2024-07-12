import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Importa CupertinoIcons
import 'package:hand_held_shell/config/global/routes.path.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
      title: 'Digitar Bombas',
      subTitle: "módulo de enumeración de bombas",
      link: RoutesPaths.dispensersHome,
      icon: Icons.border_color_outlined),
  MenuItem(
      title: 'Realizar Cierre',
      subTitle: "módulo de cuadre diario",
      link: RoutesPaths.salesHome,
      icon: Icons.calculate_outlined),
  MenuItem(
      title: 'Realizar Compra',
      subTitle: "módulo de compras",
      link: RoutesPaths.shopsHome,
      icon: Icons.shopping_cart),
  MenuItem(
      title: 'Lubricantes',
      subTitle: "módulo de aceites & lubricantes",
      link: RoutesPaths.lubricantsHome,
      icon: Icons.oil_barrel_outlined),
  MenuItem(
      title: 'Chat',
      subTitle: "mensajeria",
      link: RoutesPaths.userHome,
      icon: CupertinoIcons.chat_bubble_2),
  MenuItem(
      title: 'Ajustes',
      subTitle: "módulo de ajustes globales",
      link: RoutesPaths.settingsHome,
      icon: Icons.settings_outlined)
];
