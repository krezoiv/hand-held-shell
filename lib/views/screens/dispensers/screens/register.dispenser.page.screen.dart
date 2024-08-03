import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/shared/helpers/text.helpers.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/build.calcutator.buttons.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/navigation.buttons.dart';

class RegisterDispenserPage extends StatefulWidget {
  final int pageIndex;
  final dynamic dispenserReader;
  final int totalPages;
  final PageController mainPageController;
  final RxBool showCalculatorButtons;
  final RxBool buttonsEnabled;
  final String? dispenserReaderId;
  final VoidCallback? onBuild;

  const RegisterDispenserPage({
    super.key,
    required this.pageIndex,
    required this.dispenserReader,
    required this.totalPages,
    required this.mainPageController,
    required this.showCalculatorButtons,
    required this.buttonsEnabled,
    this.dispenserReaderId,
    this.onBuild,
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

    widget.mainPageController.addListener(_onPageChanged);

    Future.microtask(() {
      _setInitialFocus();
    });
  }

  @override
  void dispose() {
    verticalPageController.dispose();
    widget.mainPageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _setInitialFocus() {
    if (mounted &&
        widget.pageIndex < dispenserController.focusNodes.length &&
        dispenserController.focusNodes[widget.pageIndex].isNotEmpty &&
        dispenserController.focusNodes[widget.pageIndex][0].context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            dispenserController.focusNodes[widget.pageIndex][0].context !=
                null) {
          FocusScope.of(context).requestFocus(
            dispenserController.focusNodes[widget.pageIndex][0],
          );
        }
      });
    }
  }

  void _onPageChanged() {
    if (widget.mainPageController.page == widget.pageIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setInitialFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onBuild != null) {
      widget.onBuild!();
    }

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
        }
      }
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
                          Future.microtask(() {
                            _setInitialFocus();
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
                            dispenserController
                                .sendDataToDatabase(widget.pageIndex);
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
                  Obx(() {
                    if (widget.showCalculatorButtons.value &&
                        dispenserController
                            .showCalculatorButtonsPerPage.isNotEmpty &&
                        widget.pageIndex <
                            dispenserController
                                .showCalculatorButtonsPerPage.length &&
                        dispenserController
                            .showCalculatorButtonsPerPage[widget.pageIndex]
                            .value) {
                      return BuildCalculatorButtons(
                        pageIndex: widget.pageIndex,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  BuildCalculatorButtons(
                    pageIndex: widget.pageIndex,
                  ),
                ],
              ),
            ),
          ),
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
              Text(
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
              const SizedBox(height: 4),
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
                          enabled: false, // Siempre deshabilitado
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
                              enabled: dispenserController
                                  .buttonsEnabled[widget.pageIndex][cardIndex]
                                  .value,
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
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    difference,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: getDifferenceColor(),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
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
                _setInitialFocus();
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
