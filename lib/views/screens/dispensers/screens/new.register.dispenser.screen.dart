import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
import 'package:hand_held_shell/services/dispensers/dispenser.reader.service.dart';
import 'package:hand_held_shell/views/screens/dispensers/screens/register.dispenser.page.screen.dart';

class NewRegisterDispenserScreen extends StatelessWidget {
  NewRegisterDispenserScreen({super.key});

  final RxBool showCalculatorButtons = false.obs;

  @override
  Widget build(BuildContext context) {
    final dispenserController = Get.put(DispenserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitar Bombas'),
        actions: [
          CupertinoButton(
            child: Icon(
              CupertinoIcons.delete,
              color: Colors.red[900],
            ),
            onPressed: () {
              showConfirmationDialog(
                title: 'Eliminar Último Dispensador',
                message: '¿Confirmar eliminación del último dispensador?',
                confirmText: 'Sí',
                cancelText: 'No',
                onConfirm: () async {
                  try {
                    await DispenserReaderService
                        .deleteLastGeneralDispenserReader();
                    Get.back(); // Cierra el diálogo

                    // Navegar a una ruta específica después de cerrar el diálogo
                    Get.toNamed(RoutesPaths
                        .dispensersHome); // Cambia '/ruta-especifica' por tu ruta deseada
                  } catch (e) {
                    // Manejo de errores
                    print('Error: $e');
                  }
                },
                onCancel: () {
                  return; // Cierra el diálogo
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          DispenserPageView(showCalculatorButtons: showCalculatorButtons),
          Positioned(
            right: 36,
            bottom: 150,
            child: Obx(() => showCalculatorButtons.value
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () {
                      showConfirmationDialog(
                        title: 'APERTURA DE DÍA',
                        message: '¿Confirmar apertura de día?',
                        cancelText: 'No',
                        confirmText: 'Sí',
                        onConfirm: () async {
                          try {
                            await DispenserReaderService
                                .createGeneralDispenserReader();
                            showCalculatorButtons.value = true;
                            Get.back(); // Cierra el diálogo
                          } catch (e) {
                            // Manejo de errores
                          }
                        },
                        onCancel: () {
                          Get.back(); // Cierra el diálogo
                        },
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.folder_badge_plus,
                      size:
                          60, // Ajusta el tamaño del icono según tus preferencias
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        BoxConstraints(), // Elimina las restricciones de tamaño mínimo
                  )),
          ),
        ],
      ),
    );
  }

  void showConfirmationDialog({
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: confirmText,
      textCancel: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      barrierDismissible: false, // No se puede cerrar tocando fuera del diálogo
    );
  }
}

class DispenserPageView extends StatelessWidget {
  final RxBool showCalculatorButtons;

  const DispenserPageView({super.key, required this.showCalculatorButtons});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final DispenserController controller = Get.find<DispenserController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return PageView.builder(
          controller: pageController,
          itemCount: controller.dispenserReaders.length,
          itemBuilder: (context, index) {
            return RegisterDispenserPage(
              pageIndex: index,
              mainPageController: pageController,
              dispenserReader: controller.dispenserReaders[index],
              totalPages: controller.dispenserReaders.length,
              showCalculatorButtons: showCalculatorButtons,
            );
          },
        );
      }
    });
  }
}
