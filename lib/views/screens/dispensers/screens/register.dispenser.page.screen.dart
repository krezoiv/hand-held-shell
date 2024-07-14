import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'package:hand_held_shell/controllers/theme.controller.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/calculator.button.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';

class RegisterDispenserPage extends StatefulWidget {
  final int pageIndex;
  final dynamic dispenserReader;
  final int totalPages;
  final PageController mainPageController;

  const RegisterDispenserPage({
    Key? key,
    required this.pageIndex,
    required this.dispenserReader,
    required this.totalPages,
    required this.mainPageController,
  }) : super(key: key);

  @override
  _RegisterDispenserPageState createState() => _RegisterDispenserPageState();
}

class _RegisterDispenserPageState extends State<RegisterDispenserPage> {
  late PageController cardPageController;
  final themeController = Get.find<ThemeController>();
  final TextEditingController secondTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    cardPageController = PageController();
  }

  @override
  void dispose() {
    cardPageController.dispose();
    secondTextFieldController.dispose();
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
    final calculatorCtrl = Get.put(RegisterButtonsController());
    calculatorCtrl.setTextController(secondTextFieldController);

    final String fuelName = widget.dispenserReader['assignmentHoseId']['hoseId']
        ['fuelId']['fuelName'];
    final String sideName =
        widget.dispenserReader['assignmentHoseId']['sideId']['sideName'];
    final String dispenserCode = widget.dispenserReader['assignmentHoseId']
        ['assignmentId']['dispenserId']['dispenserCode'];

    return Obx(() => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_gas_station),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              capitalizeFirstLetterOfEachWord(fuelName),
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              capitalizeFirstLetterOfEachWord(dispenserCode),
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_forward),
                          Expanded(
                            child: Text(
                              capitalizeFirstLetterOfEachWord(sideName),
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Numeración: < ${widget.pageIndex + 1} / ${widget.totalPages}>',
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 220,
                    child: PageView(
                      controller: cardPageController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCard(
                          'Galones',
                          widget.dispenserReader['actualNoGallons'].toString(),
                          titleColor: Colors.blue[900],
                        ),
                        _buildCard(
                          'Mecánica',
                          widget.dispenserReader['actualNoMechanic'].toString(),
                          titleColor: Colors.blue[900],
                        ),
                        _buildCard(
                          'Dinero',
                          widget.dispenserReader['actualNoMoney'].toString(),
                          titleColor: Colors.blue[900],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildNavigationButtons(),
                  SizedBox(height: 20),
                  _buildCalculatorButtons(calculatorCtrl),
                ],
              ),
            ),
          ),
          drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
          bottomNavigationBar: const CustomBottomNavigation(),
        ));
  }

  Widget _buildCard(String title, String value, {Color? titleColor}) {
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 5,
        color: themeController.isDarkMode ? null : Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleColor ??
                      (themeController.isDarkMode
                          ? Colors.white
                          : Colors.black87),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              TextField(
                controller: TextEditingController(text: formatNumber(value)),
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: themeController.isDarkMode
                      ? Colors.grey[800]
                      : Colors.white,
                  filled: true,
                ),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: themeController.isDarkMode
                      ? Colors.white
                      : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              TextField(
                controller: secondTextFieldController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese numeración de la bomba',
                  fillColor: themeController.isDarkMode
                      ? Colors.grey[800]
                      : Colors.white,
                  filled: true,
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: themeController.isDarkMode
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  color: themeController.isDarkMode
                      ? Colors.white
                      : Colors.black87,
                ),
                textAlign: TextAlign.center,
                onTap: () {
                  // Aquí puedes añadir lógica para manejar el tap si es necesario
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
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
        SizedBox(width: 10),
        Expanded(
          child: _buildNavigationButton(
            icon: Icons.clear,
            backgroundColor: Colors.red[400]!,
            onPressed: () {
              // Acción cuando se presiona el botón Clear
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildNavigationButton(
            icon: CupertinoIcons.hand_thumbsup,
            backgroundColor: Colors.green[600]!,
            onPressed: () {
              // Acción cuando se presiona el botón Thumb Up
            },
          ),
        ),
        SizedBox(width: 10),
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
      ),
      child: Center(
        child: Icon(icon),
      ),
    );
  }

  Widget _buildCalculatorButtons(RegisterButtonsController calculatorCtrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildCalculatorRow(['7', '8', '9'], calculatorCtrl),
        SizedBox(height: 10),
        _buildCalculatorRow(['4', '5', '6'], calculatorCtrl),
        SizedBox(height: 10),
        _buildCalculatorRow(['1', '2', '3'], calculatorCtrl),
        _buildCalculatorRow(['0', '.', 'C'], calculatorCtrl),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCalculatorRow(
      List<String> numbers, RegisterButtonsController calculatorCtrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers
          .map((number) => CalculatorButton(
                text: number,
                onPressed: () => calculatorCtrl.addNumber(number),
              ))
          .toList(),
    );
  }
}

// Controlador
class RegisterButtonsController extends GetxController {
  late TextEditingController textController;

  void setTextController(TextEditingController controller) {
    textController = controller;
  }

  void addNumber(String number) {
    if (number == 'C') {
      textController.clear();
      return;
    }

    String currentText = textController.text;

    if (number == '.' && currentText.contains('.')) {
      return;
    }

    if (currentText.isEmpty && number == '0') {
      return;
    }

    if (currentText.contains('.') && currentText.split('.')[1].length >= 3) {
      return;
    }

    textController.text += number;
    textController.text = formatNumberForDisplay(textController.text);
  }

  String formatNumberForDisplay(String number) {
    if (number.isEmpty) return '';

    List<String> parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Eliminar cualquier coma existente para evitar duplicados
    integerPart = integerPart.replaceAll(',', '');

    // Revertir la parte entera para facilitar la inserción de comas
    String reversedIntegerPart = integerPart.split('').reversed.join();

    // Construir la parte entera con comas cada tres dígitos
    String formattedInteger = '';
    for (int i = 0; i < reversedIntegerPart.length; i++) {
      if (i != 0 && i % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += reversedIntegerPart[i];
    }

    // Revertir nuevamente para obtener el orden correcto
    formattedInteger = formattedInteger.split('').reversed.join();

    return formattedInteger + decimalPart;
  }
}
