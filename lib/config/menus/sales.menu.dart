import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';

class SalesMenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const SalesMenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appSalesMenuItems = <SalesMenuItem>[
  SalesMenuItem(
      title: 'DLP',
      subTitle: "registrar venta diaria",
      link: RoutesPaths.newSales,
      icon: CupertinoIcons.shopping_cart),
  SalesMenuItem(
      title: 'Modifcar DLP',
      subTitle: "modifcar venta diaria",
      link: RoutesPaths.modifySales,
      icon: Icons.sync),
  SalesMenuItem(
      title: 'Elminar DLP',
      subTitle: "eliminar dlp",
      link: RoutesPaths.deleteSales,
      icon: CupertinoIcons.trash_fill),
  SalesMenuItem(
      title: 'Buscar DLPs',
      subTitle: "consulta de DLP",
      link: RoutesPaths.searchSales,
      icon: CupertinoIcons.search)
];
