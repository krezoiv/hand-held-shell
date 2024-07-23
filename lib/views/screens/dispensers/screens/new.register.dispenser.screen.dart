import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';
import 'package:hand_held_shell/services/dispensers/dispenser.reader.service.dart';
import 'package:hand_held_shell/shared/helpers/text.helpers.dart';
import 'package:hand_held_shell/views/screens/dispensers/screens/register.dispenser.page.screen.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/build.calcutator.buttons.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/navigation.buttons.dart';

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

    // Añade un listener al PageController para actualizar currentPageIndex
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitar Bombas'),
        actions: [
          Obx(() => CupertinoButton(
                onPressed: dispenserController.hasSharedPreferencesData.value &&
                        dispenserController.isAnyButtonDisabledInCards
                    ? () {
                        dispenserController
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

class RegisterDispenserPage extends StatefulWidget {
  final int pageIndex;
  final dynamic dispenserReader;
  final int totalPages;
  final PageController mainPageController;
  final RxBool showCalculatorButtons;
  final RxBool buttonsEnabled;
  final String? dispenserReaderId;

  const RegisterDispenserPage({
    super.key,
    required this.pageIndex,
    required this.dispenserReader,
    required this.totalPages,
    required this.mainPageController,
    required this.showCalculatorButtons,
    required this.buttonsEnabled,
    this.dispenserReaderId,
  });

  @override
  _RegisterDispenserPageState createState() => _RegisterDispenserPageState();
}

class _RegisterDispenserPageState extends State<RegisterDispenserPage> {
  final themeController = Get.find<ThemeController>();
  final dispenserController = Get.find<DispenserController>();
  late RegisterButtonsController calculatorCtrl;
  late PageController verticalPageController;

  @override
  void initState() {
    super.initState();
    calculatorCtrl = Get.put(RegisterButtonsController());
    calculatorCtrl.setDispenserController(dispenserController);
    verticalPageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context)
          .requestFocus(dispenserController.focusNodes[widget.pageIndex][0]);
    });

    widget.mainPageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    verticalPageController.dispose();
    widget.mainPageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    if (widget.mainPageController.page == widget.pageIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context)
            .requestFocus(dispenserController.focusNodes[widget.pageIndex][0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    String fuelName = '';
    String sideName = '';
    String dispenserCode = '';
    String assignmentHoseId = '';

    final assignmentHoseIdMap = widget.dispenserReader['assignmentHoseId'];
    if (assignmentHoseIdMap is Map) {
      final hoseIdMap = assignmentHoseIdMap['hoseId'];
      final sideIdMap = assignmentHoseIdMap['sideId'];
      final assignmentIdMap = assignmentHoseIdMap['assignmentId'];

      if (hoseIdMap is Map && sideIdMap is Map && assignmentIdMap is Map) {
        final fuelIdMap = hoseIdMap['fuelId'];
        final dispenserIdMap = assignmentIdMap['dispenserId'];

        if (fuelIdMap is Map && dispenserIdMap is Map) {
          fuelName = fuelIdMap['fuelName'] as String;
          sideName = sideIdMap['sideName'] as String;
          dispenserCode = dispenserIdMap['dispenserCode'] as String;
          assignmentHoseId = assignmentHoseIdMap['_id'] as String;
        } else {
          // Manejar el caso donde fuelIdMap o dispenserIdMap no sean Map
          print('fuelIdMap or dispenserIdMap is not a Map');
        }
      } else {
        // Manejar el caso donde hoseIdMap, sideIdMap o assignmentIdMap no sean Map
        print('hoseIdMap, sideIdMap or assignmentIdMap is not a Map');
      }
    } else {
      // Manejar el caso donde assignmentHoseIdMap no sea Map
      print('assignmentHoseIdMap is not a Map');
    }

    return Obx(() => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 20,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.local_gas_station),
                const SizedBox(width: 5),
                Expanded(
                    child: Text(
                        '$fuelName | ${TextHelpers.capitalizeFirstLetterOfEachWord(dispenserCode)} -> ${TextHelpers.capitalizeFirstLetterOfEachWord(sideName)}',
                        style: const TextStyle(fontSize: 14.0),
                        overflow: TextOverflow.ellipsis)),
                Text('${widget.pageIndex + 1}/${widget.totalPages}',
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic)),
                Obx(() {
                  final String? dispenserReaderId = dispenserController
                      .dispenserReaders[widget.pageIndex]['dispenserReaderId'];
                  return dispenserReaderId != null
                      ? Text(
                          'ID: ...${dispenserReaderId.substring(dispenserReaderId.length - 10)}',
                          style: const TextStyle(
                              fontSize: 10, fontStyle: FontStyle.italic))
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      controller: verticalPageController,
                      onPageChanged: (index) {
                        calculatorCtrl.setCurrentCardIndex(index);
                        if (index == 0) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FocusScope.of(context).requestFocus(
                                dispenserController.focusNodes[widget.pageIndex]
                                    [0]);
                          });
                        }
                      },
                      children: [
                        _buildCard(
                          'Numeración en Galones',
                          widget.dispenserReader['actualNoGallons'].toString(),
                          0,
                          titleColor: Colors.blue[900],
                          difference: dispenserController
                              .differences[widget.pageIndex][0].value,
                        ),
                        _buildCard(
                          'Numeración Mecánica',
                          widget.dispenserReader['actualNoMechanic'].toString(),
                          1,
                          titleColor: Colors.blue[900],
                          difference: dispenserController
                              .differences[widget.pageIndex][1].value,
                        ),
                        _buildCard(
                          'Numeración en Dinero',
                          widget.dispenserReader['actualNoMoney'].toString(),
                          2,
                          titleColor: Colors.blue[900],
                          difference: dispenserController
                              .differences[widget.pageIndex][2].value,
                        ),
                      ],
                    ),
                  ),
                  Obx(() => NavigationButtons(
                        mainPageController: widget.mainPageController,
                        pageIndex: widget.pageIndex,
                        totalPages: widget.totalPages,
                        currentCardIndex: calculatorCtrl.currentCardIndex.value,
                        enabled: widget.buttonsEnabled.value &&
                            !dispenserController
                                .dataSubmitted[widget.pageIndex].value &&
                            !dispenserController.isLoading.value,
                        onThumbUpPressed: () {
                          if (dispenserController.sendButtonEnabled.value &&
                              !dispenserController
                                  .dataSubmitted[widget.pageIndex].value &&
                              !dispenserController.isLoading.value) {
                            dispenserController.sendDataToDatabase(widget
                                .pageIndex); // !se manade a guardar el nuevo dispenserReader
                          } else if (dispenserController
                              .dataSubmitted[widget.pageIndex].value) {
                            Get.snackbar('Información',
                                'Los datos ya han sido enviados.');
                          } else if (dispenserController.isLoading.value) {
                            Get.snackbar('Información',
                                'Enviando datos, por favor espere...');
                          } else {
                            _showMissingDataDialog();
                          }
                        },
                        dispenserController: dispenserController,
                      )),
                  if (widget.showCalculatorButtons.value)
                    BuildCalculatorButtons(
                      pageIndex: widget.pageIndex,
                    ),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: const CustomBottomNavigation(),
        ));
  }

  Widget _buildCard(String title, String value, int cardIndex,
      {Color? titleColor, required String difference}) {
    Color getDifferenceColor() {
      if (difference == 'Error') return Colors.red;
      final numDifference = Decimal.tryParse(difference.replaceAll(',', ''));
      if (numDifference == null) return Colors.black;
      if (numDifference < Decimal.zero) return Colors.red;
      if (numDifference > Decimal.zero) return Colors.green;
      return Colors.blue;
    }

    String formatNumber(String number) {
      if (number.isEmpty) return '0';

      List<String> parts = number.split('.');
      String integerPart = parts[0];
      String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      String formattedInteger = '';
      for (int i = integerPart.length - 1; i >= 0; i--) {
        if ((integerPart.length - 1 - i) % 3 == 0 &&
            i != integerPart.length - 1) {
          formattedInteger = ',$formattedInteger';
        }
        formattedInteger = integerPart[i] + formattedInteger;
      }

      return formattedInteger + decimalPart;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Card(
        elevation: 1,
        color: themeController.isDarkMode ? null : Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor ??
                            (themeController.isDarkMode
                                ? Colors.white
                                : Colors.black87),
                      ),
                    ),
                  ),
                  Text(
                    difference,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: getDifferenceColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        TextField(
                          controller:
                              TextEditingController(text: formatNumber(value)),
                          readOnly: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            fillColor: themeController.isDarkMode
                                ? Colors.grey[800]
                                : Colors.white,
                            filled: true,
                          ),
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Obx(() => TextField(
                              controller: dispenserController
                                  .textControllers[widget.pageIndex][cardIndex],
                              focusNode: dispenserController
                                  .focusNodes[widget.pageIndex][cardIndex],
                              readOnly: true,
                              onChanged: (value) {
                                dispenserController.updateTextField(
                                    widget.pageIndex, cardIndex, value);
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                hintText: 'Ingrese numeración de la bomba',
                                fillColor: themeController.isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.white,
                                filled: true,
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: themeController.isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 25.0,
                                color: themeController.isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                              onTap: () {
                                // Do nothing to prevent keyboard from showing
                              },
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: Obx(() => ElevatedButton(
                            onPressed: dispenserController
                                    .buttonsEnabled[widget.pageIndex][cardIndex]
                                    .value
                                ? () => dispenserController
                                    .validateAndDisableFields(
                                        widget.pageIndex, cardIndex)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[800],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.hand_thumbsup,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMissingDataDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Falta de datos"),
        content: const Text("Faltan datos por ingresar."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FocusScope.of(context).requestFocus(
                    dispenserController.focusNodes[widget.pageIndex][0]);
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
