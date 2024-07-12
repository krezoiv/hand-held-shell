import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';

class ChangeThemeScreen extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  ChangeThemeScreen({super.key}); // Agregar Key aquí

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme changer'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(themeController.isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onPressed: () {
                  themeController.toggleDarkMode();
                },
              )),
        ],
      ),
      body: const _ThemeChangerView(),
    );
  }
}

class _ThemeChangerView extends StatelessWidget {
  const _ThemeChangerView(); // Agregar Key aquí

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() {
      final List<Color> colors = themeController.colorList;
      final int selectedColor = themeController.selectedColorIndex;

      return ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final Color color = colors[index];

          return RadioListTile(
            title: Text('Este color', style: TextStyle(color: color)),
            subtitle: Text('${color.value}'),
            activeColor: color,
            value: index,
            groupValue: selectedColor,
            onChanged: (value) {
              themeController.changeColorIndex(index);
            },
          );
        },
      );
    });
  }
}
