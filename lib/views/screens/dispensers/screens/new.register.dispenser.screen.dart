import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/services/dispensers/dispenser.reader.service.dart';
import 'package:hand_held_shell/shared/helpers/show.confirm.alert.dart';
import 'package:hand_held_shell/views/screens/dispensers/screens/register.dispenser.page.screen.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';

class NewRegisterDispenserScreen extends StatefulWidget {
  const NewRegisterDispenserScreen({super.key});

  @override
  _NewRegisterDispenserScreenState createState() =>
      _NewRegisterDispenserScreenState();
}

class _NewRegisterDispenserScreenState
    extends State<NewRegisterDispenserScreen> {
  late DispenserController dispenserController;
  late PageController _pageController;
  final RxInt currentPageIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // Definir scaffoldKey

  @override
  void initState() {
    super.initState();
    dispenserController = Get.put(DispenserController(), permanent: true);
    _pageController = PageController();
    Get.put(_pageController, tag: 'dispenser_page_controller');

    if (!Get.isRegistered<DispenserController>()) {
      Get.put(DispenserController());
    }
    dispenserController = Get.find<DispenserController>();

    // Carga el estado al iniciar
    dispenserController.loadState();

    // Añade un listener al PageController para actualizar currentPageIndex
    _pageController.addListener(() {
      currentPageIndex.value = _pageController.page?.round() ?? 0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dispenserController.methods.setFocusToFirstField(0);
    });
  }

  @override
  void dispose() {
    Get.delete<PageController>(tag: 'dispenser_page_controller');
    _pageController.dispose();

    super.dispose();
    for (var nodelist in dispenserController.focusNodes) {
      for (var node in nodelist) {
        node.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey, // Utilizar scaffoldKey
      drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: Text(
          'Digitar de Bomba',
          style: TextStyle(
              fontSize: screenWidth * 0.05), // Ajuste de tamaño de fuente
        ),
        actions: [
          Obx(() => CupertinoButton(
                onPressed: dispenserController.hasSharedPreferencesData.value &&
                        dispenserController.isAnyButtonDisabledInCards
                    ? () {
                        dispenserController.methods
                            .toggleEditMode(currentPageIndex.value);
                      }
                    : null,
                child: Icon(
                  CupertinoIcons.pencil,
                  color: (dispenserController.hasSharedPreferencesData.value &&
                          dispenserController.isAnyButtonDisabledInCards)
                      ? Colors.blue[900]
                      : Colors.grey,
                ),
              )),
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
                            } catch (e) {}
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
                  dispenserController.methods.setFocusToFirstField(index);
                  currentPageIndex.value = index;
                },
                itemBuilder: (context, index) {
                  final dispenserReader =
                      dispenserController.dispenserReaders[index];
                  return RegisterDispenserPage(
                    pageIndex: index,
                    dispenserReader: dispenserReader,
                    totalPages: dispenserController.dispenserReaders.length,
                    mainPageController: _pageController,
                    showCalculatorButtons:
                        dispenserController.showCalculatorButtons,
                    buttonsEnabled:
                        dispenserController.hasSharedPreferencesData,
                    dispenserReaderId:
                        dispenserReader['dispenserReaderId'] as String?,
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
                                await dispenserController
                                    .fetchDispenserReaders();

                                // Forzar actualización de la UI
                                setState(() {});

                                // Cerrar el diálogo
                                Get.back();

                                // Forzar la permanencia en la ruta actual
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Get.offNamed(
                                      RoutesPaths.newRegisterDispenserScreen);
                                });
                              } catch (e) {
                                print('Error: $e');
                                Get.back(); // Cerrar el diálogo en caso de error
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
}
