import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/calculator.button.dart';

class RegisterDispenserPage extends StatefulWidget {
  final int pageIndex;
  final dynamic dispenserReader;
  final int totalPages;
  final PageController mainPageController;

  const RegisterDispenserPage({
    super.key,
    required this.pageIndex,
    required this.dispenserReader,
    required this.totalPages,
    required this.mainPageController,
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
  }

  @override
  void dispose() {
    verticalPageController.dispose();
    super.dispose();
  }

  String capitalizeFirstLetterOfEachWord(String text) {
    if (text.isEmpty) return text;
    List<String> words = text.split(' ');
    return words
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
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

    return Obx(() => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 20,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.local_gas_station),
                SizedBox(width: 5),
                Expanded(
                    child: Text(
                        '${capitalizeFirstLetterOfEachWord(fuelName)} | ${capitalizeFirstLetterOfEachWord(dispenserCode)} -> ${capitalizeFirstLetterOfEachWord(sideName)}',
                        style: TextStyle(fontSize: 14.0),
                        overflow: TextOverflow.ellipsis)),
                Text('${widget.pageIndex + 1}/${widget.totalPages}',
                    style:
                        TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
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
                  _buildNavigationButtons(),
                  _buildCalculatorButtons(calculatorCtrl),
                ],
              ),
            ),
          ),
          // drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
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
                  fontSize: 16, // Reducido de 18 a 16
                  fontWeight: FontWeight.bold,
                  color: titleColor ??
                      (themeController.isDarkMode
                          ? Colors.white
                          : Colors.black87),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.85, // Ajusta el ancho al 70% del ancho de la pantalla
                  child: TextField(
                    controller:
                        TextEditingController(text: formatNumber(value)),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8), // Reduce el padding interno
                      fillColor: themeController.isDarkMode
                          ? Colors.grey[800]
                          : Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(
                      fontSize: 16.0, // Reducido de 20 a 16
                      fontWeight: FontWeight.w700,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.85, // Ajusta el ancho al 70% del ancho de la pantalla
                  child: TextField(
                    controller: dispenserController
                        .textControllers[widget.pageIndex][cardIndex],
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10), // Reduce el padding interno
                      hintText: 'Ingrese numeración de la bomba',
                      fillColor: themeController.isDarkMode
                          ? Colors.grey[800]
                          : Colors.white,
                      filled: true,
                      hintStyle: TextStyle(
                        fontSize: 13, // Reducido de 15 a 13
                        color: themeController.isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0, // Reducido de 20 a 16
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildNavigationButton(
              icon: CupertinoIcons.arrowshape_turn_up_left,
              onPressed: () {
                if (widget.pageIndex > 0) {
                  widget.mainPageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: Icons.update,
              backgroundColor: Colors.yellow.shade900,
              onPressed: () {
                calculatorCtrl.clearTextField(
                    widget.pageIndex, calculatorCtrl.currentCardIndex);
              },
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: CupertinoIcons.hand_thumbsup,
              backgroundColor: Colors.green[600]!,
              onPressed: () {
                // Acción cuando se presiona el botón Thumb Up
              },
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: CupertinoIcons.arrowshape_turn_up_right,
              onPressed: () {
                if (widget.pageIndex < widget.totalPages - 1) {
                  widget.mainPageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.deepPurpleAccent,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        elevation: 5,
        shadowColor: backgroundColor.withOpacity(0.5),
        padding: EdgeInsets.all(8),
      ),
      child: Center(
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildCalculatorButtons(RegisterButtonsController calculatorCtrl) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCalculatorRow(['7', '8', '9'], calculatorCtrl),
          SizedBox(height: 5),
          _buildCalculatorRow(['4', '5', '6'], calculatorCtrl),
          SizedBox(height: 5),
          _buildCalculatorRow(['1', '2', '3'], calculatorCtrl),
          _buildCalculatorRow(['0', '.', 'C'], calculatorCtrl),
        ],
      ),
    );
  }

  Widget _buildCalculatorRow(
      List<String> numbers, RegisterButtonsController calculatorCtrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers
          .map((number) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CalculatorButton(
                    text: number,
                    onPressed: () {
                      calculatorCtrl.addNumber(number, widget.pageIndex,
                          calculatorCtrl.currentCardIndex);
                    },
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class RegisterButtonsController extends GetxController {
  late DispenserController dispenserController;
  int currentCardIndex = 0;

  void setDispenserController(DispenserController controller) {
    dispenserController = controller;
  }

  void setCurrentCardIndex(int index) {
    currentCardIndex = index;
  }

  void addNumber(String number, int pageIndex, int cardIndex) {
    String currentText =
        dispenserController.textControllers[pageIndex][cardIndex].text;

    if (number == 'C') {
      clearTextField(pageIndex, cardIndex);
      return;
    }

    if (number == '.' && currentText.contains('.')) {
      return;
    }

    if (currentText.isEmpty && number == '0') {
      return;
    }

    if (currentText.contains('.') && currentText.split('.')[1].length >= 3) {
      return;
    }

    String newText = currentText + number;
    newText = formatNumberForDisplay(newText);
    dispenserController.updateTextField(pageIndex, cardIndex, newText);
  }

  void clearTextField(int pageIndex, int cardIndex) {
    dispenserController.updateTextField(pageIndex, cardIndex, '');
  }

  String formatNumberForDisplay(String number) {
    if (number.isEmpty) return '';

    List<String> parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    integerPart = integerPart.replaceAll(',', '');

    String reversedIntegerPart = integerPart.split('').reversed.join();

    String formattedInteger = '';
    for (int i = 0; i < reversedIntegerPart.length; i++) {
      if (i != 0 && i % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += reversedIntegerPart[i];
    }

    formattedInteger = formattedInteger.split('').reversed.join();

    return formattedInteger + decimalPart;
  }
}
