import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';

class ShopMenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const ShopMenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appShopMenuItems = <ShopMenuItem>[
  ShopMenuItem(
      title: 'Gnerar Nueva Orden de Compra',
      subTitle: "nueva orden de compra",
      link: RoutesPaths.newOrderShopScreen,
      icon: CupertinoIcons.doc_on_doc),
  ShopMenuItem(
      title: 'Modifcar Orden de Compra',
      subTitle: "modifcar orden",
      link: RoutesPaths.modifyOrderShopScreen,
      icon: Icons.sync),
  ShopMenuItem(
      title: 'Elminar Orden de compra',
      subTitle: "Eliminar orden",
      link: RoutesPaths.deleteOrderShopScreen,
      icon: CupertinoIcons.trash_fill),
  ShopMenuItem(
      title: 'Genrar Factura de Compra',
      subTitle: "nueva factura de compra",
      link: RoutesPaths.newShopScreen,
      icon: CupertinoIcons.doc_append),
  ShopMenuItem(
      title: 'Modificar Compra',
      subTitle: "modificar compra",
      link: RoutesPaths.modifyShopScreen,
      icon: Icons.sync),
  ShopMenuItem(
      title: 'Elimiar Compra',
      subTitle: "eliminar compra",
      link: RoutesPaths.deleteShopScreen,
      icon: Icons.remove_shopping_cart_outlined),
];
