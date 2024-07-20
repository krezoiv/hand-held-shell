import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
import 'package:hand_held_shell/services/dispensers/dispenser.reader.service.dart';
import 'package:hand_held_shell/views/screens/dispensers/screens/register.dispenser.page.screen.dart';

class NewRegisterDispenserScreen extends StatefulWidget {
  NewRegisterDispenserScreen({Key? key}) : super(key: key);

  @override
  _NewRegisterDispenserScreenState createState() =>
      _NewRegisterDispenserScreenState();
}

class _NewRegisterDispenserScreenState
    extends State<NewRegisterDispenserScreen> {
  late DispenserController dispenserController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    Get.put(_pageController, tag: 'dispenser_page_controller');

    if (!Get.isRegistered<DispenserController>()) {
      Get.put(DispenserController());
    }
    dispenserController = Get.find<DispenserController>();

    // Carga el estado al iniciar
    dispenserController.loadState();
  }

  @override
  void dispose() {
    Get.delete<PageController>(tag: 'dispenser_page_controller');
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitar Bombas'),
        actions: [
          Obx(() => CupertinoButton(
                onPressed: dispenserController.hasSharedPreferencesData.value
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
                              await dispenserController.clearState();
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
          Obx(() {
            if (dispenserController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return PageView.builder(
                controller: _pageController,
                itemCount: dispenserController.dispenserReaders.length,
                onPageChanged: (index) {
                  dispenserController.setFocusToFirstField(index);
                },
                itemBuilder: (context, index) {
                  return RegisterDispenserPage(
                    pageIndex: index,
                    dispenserReader:
                        dispenserController.dispenserReaders[index],
                    totalPages: dispenserController.dispenserReaders.length,
                    mainPageController: _pageController,
                    showCalculatorButtons:
                        dispenserController.showCalculatorButtons,
                    buttonsEnabled:
                        dispenserController.hasSharedPreferencesData,
                  );
                },
              );
            }
          }),
          Obx(() => Positioned(
                right: 36,
                bottom: 150,
                child: !dispenserController.hasSharedPreferencesData.value
                    ? IconButton(
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
                                dispenserController
                                    .showCalculatorButtons.value = true;
                                dispenserController
                                    .hasSharedPreferencesData.value = true;
                                await dispenserController.saveState();
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
                          color: Colors.teal.shade600,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      )
                    : SizedBox.shrink(),
              )),
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
