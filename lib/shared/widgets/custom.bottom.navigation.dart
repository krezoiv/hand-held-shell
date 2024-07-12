import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        // Navegar a la pantalla anterior
        Get.back();
        break;
      case 1:
        // Navegar a Inicio
        Get.toNamed(
            RoutesPaths.mainHome); // Asegúrate de tener esta ruta definida
        break;
      case 2:
        // Navegar a Favoritos
        Get.toNamed(
            RoutesPaths.userHome); // Asegúrate de tener esta ruta definida
        break;

      // Navegar a Favoritos
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.arrowshape_turn_up_left),
          label: 'Regresar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2),
          label: 'Chat',
        ),
      ],
      onTap: (index) => _onItemTapped(index),
    );
  }
}
