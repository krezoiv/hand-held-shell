import 'package:flutter/material.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';

class DispenserMenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const DispenserMenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appDispenserMenuItems = <DispenserMenuItem>[
  DispenserMenuItem(
      title: 'Registrar Numeración',
      subTitle: "ingresar numeración",
      link: RoutesPaths.newRegisterDispenserScreen,
      icon: Icons.filter_9_plus_rounded),
  DispenserMenuItem(
      title: 'Modifcar Numeración',
      subTitle: "modifcar dato",
      link: RoutesPaths.modifyRegisterDispenserScreen,
      icon: Icons.sync),
  DispenserMenuItem(
      title: 'Elminar Numeración',
      subTitle: "Eliminar dato",
      link: RoutesPaths.deleteRegisterDispenserScreen,
      icon: Icons.delete_forever_outlined),
  DispenserMenuItem(
      title: 'Eliminación Competa',
      subTitle: "eliminar numeración completa",
      link: RoutesPaths.deleteAllRegisterDispenserScreen,
      icon: Icons.folder_delete_outlined),
];
