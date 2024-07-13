import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Asegúrate de importar GetX
import 'package:hand_held_shell/config/menus/home.menu.dart';

class ListTileHome extends StatelessWidget {
  final MenuItem menuItem;

  const ListTileHome({
    super.key,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap: () {
        Get.toNamed(menuItem.link); // Utiliza Get.toNamed para la navegación
      },
    );
  }
}
