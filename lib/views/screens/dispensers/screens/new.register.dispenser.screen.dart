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
  final RxBool buttonsEnabled = false.obs;

  @override
  Widget build(BuildContext context) {
    final dispenserController = Get.put(DispenserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitar Bombas'),
        actions: [
          Obx(() => CupertinoButton(
                onPressed: buttonsEnabled.value
                    ? () {
                        showConfirmationDialog(
                          title: 'Eliminar Último Dispensador',
                          message:
                              '¿Confirmar eliminación del último dispensador?',
                          confirmText: 'Sí',
                          cancelText: 'No',
                          onConfirm: () async {
                            try {
                              await DispenserReaderService
                                  .deleteLastGeneralDispenserReader();
                              Get.back();
                              Get.toNamed(RoutesPaths.dispensersHome);
                            } catch (e) {
                              print('Error: $e');
                            }
                          },
                          onCancel: () {
                            return;
                          },
                        );
                      }
                    : null,
                child: Icon(
                  CupertinoIcons.delete,
                  color: Colors.red[900],
                ),
              )),
        ],
      ),
      body: Stack(
        children: [
          DispenserPageView(
            showCalculatorButtons: showCalculatorButtons,
            buttonsEnabled: buttonsEnabled,
          ),
          Positioned(
            right: 36,
            bottom: 150,
            child: Obx(() => buttonsEnabled.value
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () {
                      showConfirmationDialog(
                        title: 'APERTURA DE DÍA',
                        message: '¿Confirmar apertura de día?',
                        confirmText: 'Sí',
                        cancelText: 'No',
                        onConfirm: () async {
                          try {
                            await DispenserReaderService
                                .createGeneralDispenserReader();
                            showCalculatorButtons.value = true;
                            buttonsEnabled.value = true;
                            Get.back();
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        onCancel: () {
                          return;
                        },
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.folder_badge_plus,
                      size: 60,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
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
    if (GetPlatform.isIOS) {
      Get.dialog(
        CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: onCancel,
              child: Text(cancelText),
            ),
            CupertinoDialogAction(
              onPressed: onConfirm,
              child: Text(confirmText),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      Get.defaultDialog(
        title: title,
        middleText: message,
        textConfirm: confirmText,
        textCancel: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        barrierDismissible: false,
        confirmTextColor: Colors.black,
        cancelTextColor: Colors.black,
        buttonColor: Colors.blue,
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      );
    }
  }
}

class DispenserPageView extends StatelessWidget {
  final RxBool showCalculatorButtons;
  final RxBool buttonsEnabled;

  const DispenserPageView({
    super.key,
    required this.showCalculatorButtons,
    required this.buttonsEnabled,
  });

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
              buttonsEnabled: buttonsEnabled,
            );
          },
        );
      }
    });
  }
}
