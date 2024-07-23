import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';
import 'package:hand_held_shell/shared/helpers/text.helpers.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
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

  const RegisterDispenserPage({
    Key? key,
    required this.pageIndex,
    required this.dispenserReader,
    required this.totalPages,
    required this.mainPageController,
    required this.showCalculatorButtons,
    required this.buttonsEnabled,
    this.dispenserReaderId,
  }) : super(key: key);

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
      if (widget.pageIndex < dispenserController.focusNodes.length &&
          dispenserController.focusNodes[widget.pageIndex].isNotEmpty) {
        FocusScope.of(context)
            .requestFocus(dispenserController.focusNodes[widget.pageIndex][0]);
      }
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
        if (widget.pageIndex < dispenserController.focusNodes.length &&
            dispenserController.focusNodes[widget.pageIndex].isNotEmpty) {
          FocusScope.of(context).requestFocus(
              dispenserController.focusNodes[widget.pageIndex][0]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final int pageIndex = widget.pageIndex;

    final dispenserReader =
        pageIndex < dispenserController.dispenserReaders.length
            ? dispenserController.dispenserReaders[pageIndex]
            : null;

    if (dispenserReader == null) {
      return Center(child: Text('No hay datos disponibles para este índice'));
    }

    // Asegúrate de que las claves sean correctas
    final String fuelName = dispenserReader['assignmentHoseId']?['hoseId']
            ?['fuelId']?['fuelName'] ??
        'Desconocido';
    final String sideName = dispenserReader['assignmentHoseId']?['sideId']
            ?['sideName'] ??
        'Desconocido';
    final String dispenserCode = dispenserReader['assignmentHoseId']
            ?['assignmentId']?['dispenserId']?['dispenserCode'] ??
        'Desconocido';
    final String assignmentHoseId =
        dispenserReader['assignmentHoseId']?['_id'] ?? 'Desconocido';

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
                        '${(fuelName)} | ${TextHelpers.capitalizeFirstLetterOfEachWord(dispenserCode)} -> ${TextHelpers.capitalizeFirstLetterOfEachWord((sideName))}',
                        style: const TextStyle(fontSize: 14.0),
                        overflow: TextOverflow.ellipsis)),
                Text('${pageIndex + 1}/${widget.totalPages}',
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic)),
                Obx(() {
                  final dispenserReaders = dispenserController.dispenserReaders;
                  final String? dispenserReaderId =
                      pageIndex < dispenserReaders.length
                          ? dispenserReaders[pageIndex]['dispenserReaderId']
                              ?.toString()
                          : null;
                  return dispenserReaderId != null
                      ? Text(
                          'ID: ...${dispenserReaderId.substring(math.max(0, dispenserReaderId.length - 10))}',
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
                            if (pageIndex <
                                    dispenserController.focusNodes.length &&
                                dispenserController
                                    .focusNodes[pageIndex].isNotEmpty) {
                              FocusScope.of(context).requestFocus(
                                  dispenserController.focusNodes[pageIndex][0]);
                            }
                          });
                        }
                      },
                      children: [
                        if (pageIndex < dispenserController.differences.length)
                          _buildCard(
                            'Numeración en Galones',
                            dispenserReader['actualNoGallons']?.toString() ??
                                '0',
                            0,
                            titleColor: Colors.blue[900],
                            difference: 0 <
                                    dispenserController
                                        .differences[pageIndex].length
                                ? dispenserController
                                    .differences[pageIndex][0].value
                                : '0',
                          ),
                        if (pageIndex < dispenserController.differences.length)
                          _buildCard(
                            'Numeración Mecánica',
                            dispenserReader['actualNoMechanic']?.toString() ??
                                '0',
                            1,
                            titleColor: Colors.blue[900],
                            difference: 1 <
                                    dispenserController
                                        .differences[pageIndex].length
                                ? dispenserController
                                    .differences[pageIndex][1].value
                                : '0',
                          ),
                        if (pageIndex < dispenserController.differences.length)
                          _buildCard(
                            'Numeración en Dinero',
                            dispenserReader['actualNoMoney']?.toString() ?? '0',
                            2,
                            titleColor: Colors.blue[900],
                            difference: 2 <
                                    dispenserController
                                        .differences[pageIndex].length
                                ? dispenserController
                                    .differences[pageIndex][2].value
                                : '0',
                          ),
                      ],
                    ),
                  ),
                  Obx(() => NavigationButtons(
                        mainPageController: widget.mainPageController,
                        pageIndex: pageIndex,
                        totalPages: widget.totalPages,
                        currentCardIndex: calculatorCtrl.currentCardIndex.value,
                        enabled: widget.buttonsEnabled.value &&
                            pageIndex <
                                dispenserController.dataSubmitted.length &&
                            !dispenserController
                                .dataSubmitted[pageIndex].value &&
                            !dispenserController.isLoading.value,
                        onThumbUpPressed: () {
                          if (dispenserController.sendButtonEnabled.value &&
                              pageIndex <
                                  dispenserController.dataSubmitted.length &&
                              !dispenserController
                                  .dataSubmitted[pageIndex].value &&
                              !dispenserController.isLoading.value) {
                            dispenserController.sendDataToDatabase(pageIndex);
                          } else if (pageIndex <
                                  dispenserController.dataSubmitted.length &&
                              dispenserController
                                  .dataSubmitted[pageIndex].value) {
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
                      pageIndex: pageIndex,
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
                              controller: widget.pageIndex <
                                          dispenserController
                                              .textControllers.length &&
                                      cardIndex <
                                          dispenserController
                                              .textControllers[widget.pageIndex]
                                              .length
                                  ? dispenserController
                                          .textControllers[widget.pageIndex]
                                      [cardIndex]
                                  : TextEditingController(),
                              focusNode: widget.pageIndex <
                                          dispenserController
                                              .focusNodes.length &&
                                      cardIndex <
                                          dispenserController
                                              .focusNodes[widget.pageIndex]
                                              .length
                                  ? dispenserController
                                      .focusNodes[widget.pageIndex][cardIndex]
                                  : FocusNode(),
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
                            onPressed: widget.pageIndex <
                                        dispenserController
                                            .buttonsEnabled.length &&
                                    cardIndex <
                                        dispenserController
                                            .buttonsEnabled[widget.pageIndex]
                                            .length &&
                                    dispenserController
                                        .buttonsEnabled[widget.pageIndex]
                                            [cardIndex]
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
                if (widget.pageIndex < dispenserController.focusNodes.length &&
                    dispenserController
                        .focusNodes[widget.pageIndex].isNotEmpty) {
                  FocusScope.of(context).requestFocus(
                      dispenserController.focusNodes[widget.pageIndex][0]);
                }
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
