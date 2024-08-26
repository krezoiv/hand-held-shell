import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/services/fuel.statation/dispenser.reader.service.dart';
import 'package:hand_held_shell/shared/helpers/show.confirm.alert.dart';
import 'package:hand_held_shell/views/screens/dispensers/screens/register.dispenser.page.screen.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';

class NewRegisterDispenserScreen extends StatefulWidget {
  const NewRegisterDispenserScreen({Key? key}) : super(key: key);

  @override
  _NewRegisterDispenserScreenState createState() =>
      _NewRegisterDispenserScreenState();
}

class _NewRegisterDispenserScreenState
    extends State<NewRegisterDispenserScreen> {
  late PageController _pageController;
  final RxInt currentPageIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Get.put(_pageController, tag: 'dispenser_page_controller');

    // Inicializar el DispenserController de manera perezosa
    Get.lazyPut<DispenserController>(() => DispenserController(), fenix: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DispenserController>().loadState();
    });

    _pageController.addListener(() {
      currentPageIndex.value = _pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    Get.delete<PageController>(tag: 'dispenser_page_controller');
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<DispenserController>(
      init: DispenserController(),
      builder: (dispenserController) {
        return Scaffold(
          key: scaffoldKey,
          drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
          appBar: AppBar(
            title: Text(
              'Digitar de Bomba',
              style: TextStyle(fontSize: screenWidth * 0.05),
            ),
            actions: [
              Obx(() => CupertinoButton(
                    onPressed:
                        dispenserController.hasSharedPreferencesData.value &&
                                dispenserController.isAnyButtonDisabledInCards
                            ? () => dispenserController
                                .toggleEditMode(currentPageIndex.value)
                            : null,
                    child: Icon(
                      CupertinoIcons.pencil,
                      color: (dispenserController
                                  .hasSharedPreferencesData.value &&
                              dispenserController.isAnyButtonDisabledInCards)
                          ? Colors.blue[900]
                          : Colors.grey,
                    ),
                  )),
              Obx(() => CupertinoButton(
                    onPressed: dispenserController
                            .hasSharedPreferencesData.value
                        ? () =>
                            _showDeleteConfirmationDialog(dispenserController)
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
                            onPressed: () => _showOpenDayConfirmationDialog(
                                dispenserController),
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
      },
      dispose: (state) {
        Get.delete<DispenserController>();
      },
    );
  }

  void _showDeleteConfirmationDialog(DispenserController controller) {
    showConfirmationDialog(
      title: 'Eliminar Último Dispensador',
      message: '¿Confirmar eliminación del último dispensador?',
      confirmText: 'Sí',
      cancelText: 'No',
      onConfirm: () async {
        try {
          await DispenserReaderService.deleteLastGeneralDispenserReader();
          await controller.clearState();
          Get.back();
          Get.offNamed(RoutesPaths.dispensersHome);
        } catch (e) {
          // Manejar el error
          print('Error al eliminar el último dispensador: $e');
        }
      },
      onCancel: () => Get.back(),
    );
  }

  void _showOpenDayConfirmationDialog(DispenserController controller) {
    showConfirmationDialog(
      title: 'APERTURA DE DÍA',
      message: '¿Confirmar apertura de día?',
      confirmText: 'Sí',
      cancelText: 'No',
      onConfirm: () async {
        try {
          await DispenserReaderService.createGeneralDispenserReader();
          controller.showCalculatorButtons.value = true;
          controller.hasSharedPreferencesData.value = true;
          await controller.saveState();
        } catch (e) {
          // Manejar el error
          print('Error al abrir el día: $e');
        }
      },
      onCancel: () => Get.back(),
    );
  }
}
