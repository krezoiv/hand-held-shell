import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/config/theme/app.theme.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';

class ChangeThemeScreen extends StatelessWidget {
  const ChangeThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(() {
      final isDarkmode = themeController.appTheme.value.isDarkmode;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Theme changer'),
          actions: [
            IconButton(
              icon: Icon(isDarkmode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              onPressed: () {
                themeController.toggleDarkmode();
              },
            ),
          ],
        ),
        body: const _ThemeChangerView(),
      );
    });
  }
}

class _ThemeChangerView extends StatelessWidget {
  const _ThemeChangerView();

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      const colors = colorList;
      final selectedColor = themeController.appTheme.value.selectedColor;

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
