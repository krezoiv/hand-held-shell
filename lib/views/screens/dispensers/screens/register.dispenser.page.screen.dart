import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/shared/helpers/text.helpers.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/build.calcutator.buttons.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/navigation.buttons.dart';

class RegisterDispenserPage extends StatefulWidget {
  final int pageIndex;
  final dynamic dispenserReader;
  final int totalPages;
  final PageController mainPageController;
  final RxBool showCalculatorButtons;
  final RxBool buttonsEnabled;

  const RegisterDispenserPage({
    super.key,
    required this.pageIndex,
    required this.dispenserReader,
    required this.totalPages,
    required this.mainPageController,
    required this.showCalculatorButtons,
    required this.buttonsEnabled,
  });

  @override
  _RegisterDispenserPageState createState() => _RegisterDispenserPageState();
}

class _RegisterDispenserPageState extends State<RegisterDispenserPage> {
  final themeController = Get.find<ThemeController>();
  final dispenserController = Get.find<DispenserController>();
  late RegisterButtonsController calculatorCtrl;
  late PageController verticalPageController;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    calculatorCtrl = Get.put(RegisterButtonsController());
    calculatorCtrl.setDispenserController(dispenserController);
    verticalPageController = PageController();
    widget.mainPageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    verticalPageController.dispose();
    widget.mainPageController.removeListener(_onPageChanged);
    focusNode.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    if (widget.mainPageController.page == widget.pageIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNode);
      });
    }
  }

  void _onThumbUpPressed() {
    dispenserController.sendDataToDatabase(widget.pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final String fuelName = widget.dispenserReader['assignmentHoseId']['hoseId']
        ['fuelId']['fuelName'];
    final String sideName =
        widget.dispenserReader['assignmentHoseId']['sideId']['sideName'];
    final String dispenserCode = widget.dispenserReader['assignmentHoseId']
        ['assignmentId']['dispenserId']['dispenserCode'];
    final String assignmentHoseId =
        widget.dispenserReader['assignmentHoseId']['_id'];

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    // child: Text(
                    //   'Assignment Hose ID: $assignmentHoseId',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //     color: themeController.isDarkMode
                    //         ? Colors.white
                    //         : Colors.black,
                    //   ),
                    // ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      controller: verticalPageController,
                      onPageChanged: (index) {
                        calculatorCtrl.setCurrentCardIndex(index);
                      },
                      children: [
                        _buildCard(
                          'Numeración en Galones',
                          widget.dispenserReader['actualNoGallons'].toString(),
                          0,
                          titleColor: Colors.blue[900],
                        ),
                        _buildCard(
                          ' Numeración Mecánica',
                          widget.dispenserReader['actualNoMechanic'].toString(),
                          1,
                          titleColor: Colors.blue[900],
                        ),
                        _buildCard(
                          'Numeración en Dinero',
                          widget.dispenserReader['actualNoMoney'].toString(),
                          2,
                          titleColor: Colors.blue[900],
                        ),
                      ],
                    ),
                  ),
                  Obx(() => NavigationButtons(
                        mainPageController: widget.mainPageController,
                        pageIndex: widget.pageIndex,
                        totalPages: widget.totalPages,
                        clearTextField: (pageIndex, cardIndex) {
                          calculatorCtrl.clearTextField(pageIndex, cardIndex);
                        },
                        currentCardIndex: calculatorCtrl.currentCardIndex.value,
                        enabled: widget.buttonsEnabled.value,
                        onThumbUpPressed: _onThumbUpPressed,
                      )),
                  if (widget.showCalculatorButtons.value &&
                      widget.buttonsEnabled.value)
                    BuildCalculatorButtons(
                      pageIndex: widget.pageIndex,
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const CustomBottomNavigation(),
        ));
  }

  Widget _buildCard(String title, String value, int cardIndex,
      {Color? titleColor}) {
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        // Text(
                        //   'PageIndex: ${widget.pageIndex}, CardIndex: $cardIndex, Field: 0',
                        //   style: const TextStyle(fontSize: 10),
                        // ),
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
                        // Text(
                        //   'PageIndex: ${widget.pageIndex}, CardIndex: $cardIndex, Field: 1',
                        //   style: const TextStyle(fontSize: 10),
                        // ),
                        TextField(
                          controller: dispenserController
                              .textControllers[widget.pageIndex][cardIndex],
                          focusNode: cardIndex == 0 ? focusNode : null,
                          readOnly: true,
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
                        ),
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
                            onPressed: widget.buttonsEnabled.value
                                ? _onThumbUpPressed
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
}
