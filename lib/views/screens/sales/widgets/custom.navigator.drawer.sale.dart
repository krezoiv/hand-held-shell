import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';

import 'package:hand_held_shell/config/menus/sales.menu.dart';

class CustomNavigationDrawerSale extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool hasNotch;

  const CustomNavigationDrawerSale({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.scaffoldKey,
    this.hasNotch = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) {
        onDestinationSelected(value);

        final menuItem = appSalesMenuItems[value];

        // Verifica que menuItem.link no sea null o vacío
        if (menuItem.link.isEmpty) {
          return;
        }

        // Navegación basada en la ruta del elemento de menú
        try {
          if (menuItem.link.startsWith(RoutesPaths.salesHome)) {
            // Si es una sub-ruta de dispensers-view, usamos la ruta completa
            Get.toNamed(menuItem.link);
          } else {
            // Para otras rutas, podemos usar toNamed si lo preferimos
            Get.toNamed(menuItem.link);
          }
        } catch (e) {
          // Manejo de la excepción

          // Puedes mostrar un mensaje al usuario si lo deseas
          // showSnackBarError('Error al navegar: $e');
        }

        scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(28, hasNotch ? 10 : 20, 16, 10),
          child: Text(
            'Opciones de Registro',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...appSalesMenuItems.map((item) => NavigationDrawerDestination(
              icon: Icon(item.icon),
              label: Text(item.title),
            )),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
      ],
    );
  }
}
