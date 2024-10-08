import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/shared/helpers/show.missing.data.dart';
import 'package:hand_held_shell/shared/helpers/text.helpers.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/register.dispenser/build.calcutator.buttons.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/register.dispenser/navigation.buttons.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/register.dispenser/register.card.dart';

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
  late DispenserController dispenserController =
      Get.find<DispenserController>();
  late RegisterButtonsController calculatorCtrl;
  late PageController verticalPageController;

  @override
  void initState() {
    super.initState();
    dispenserController = Get.find<DispenserController>();
    calculatorCtrl = Get.put(RegisterButtonsController());
    calculatorCtrl.setDispenserController(dispenserController);
    verticalPageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dispenserController.ensureFocusNodesInitialized();
      dispenserController.setFocusToFirstField(widget.pageIndex);
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
        _setFocusToFirstField();
      });
    }
  }

  void _setFocusToFirstField() {
    if (mounted &&
        dispenserController.focusNodes.isNotEmpty &&
        dispenserController.focusNodes[widget.pageIndex].isNotEmpty &&
        dispenserController.focusNodes[widget.pageIndex][0] != null &&
        dispenserController.focusNodes[widget.pageIndex][0].canRequestFocus) {
      FocusScope.of(context)
          .requestFocus(dispenserController.focusNodes[widget.pageIndex][0]);
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
        }
      } else {
        // Manejar el caso donde hoseIdMap, sideIdMap o assignmentIdMap no sean Map
      }
    } else {
      // Manejar el caso donde assignmentHoseIdMap no sea Map
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FocusScope.of(context).requestFocus(
                                dispenserController.focusNodes[widget.pageIndex]
                                    [0]);
                          });
                        }
                      },
                      children: [
                        RegisterCard(
                          title: 'No. en Galones',
                          value: widget.dispenserReader['actualNoGallons']
                              .toString(),
                          cardIndex: 0,
                          difference: dispenserController
                              .differences[widget.pageIndex][0].value,
                          titleColor: Colors.blue[900],
                          themeController: themeController,
                          dispenserController: dispenserController,
                          pageIndex: widget.pageIndex,
                        ),
                        RegisterCard(
                          title: 'No. Mecánica',
                          value: widget.dispenserReader['actualNoMechanic']
                              .toString(),
                          cardIndex: 1,
                          difference: dispenserController
                              .differences[widget.pageIndex][1].value,
                          titleColor: Colors.blue[900],
                          themeController: themeController,
                          dispenserController: dispenserController,
                          pageIndex: widget.pageIndex,
                        ),
                        RegisterCard(
                          title: 'No. en Dinero',
                          value: widget.dispenserReader['actualNoMoney']
                              .toString(),
                          cardIndex: 2,
                          difference: dispenserController
                              .differences[widget.pageIndex][2].value,
                          titleColor: Colors.blue[900],
                          themeController: themeController,
                          dispenserController: dispenserController,
                          pageIndex: widget.pageIndex,
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
                            Get.snackbar(
                              'Información',
                              'Los datos ya han sido enviados.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green[600],
                              colorText: Colors.white,
                              margin: EdgeInsets.all(10),
                              borderRadius: 20,
                              duration: Duration(seconds: 3),
                              isDismissible: true,
                              dismissDirection: DismissDirection.horizontal,
                              forwardAnimationCurve: Curves.easeOutBack,
                            );
                          } else if (dispenserController.isLoading.value) {
                            Get.snackbar(
                              'Información',
                              'Enviando datos, por favor espere...',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green[600],
                              colorText: Colors.white,
                              margin: EdgeInsets.all(10),
                              borderRadius: 20,
                              duration: Duration(seconds: 3),
                              isDismissible: true,
                              dismissDirection: DismissDirection.horizontal,
                              forwardAnimationCurve: Curves.easeOutBack,
                            );
                          } else {
                            ShowMissingDataDialog.show(
                                context, dispenserController, widget.pageIndex);
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
        ));
  }
}
