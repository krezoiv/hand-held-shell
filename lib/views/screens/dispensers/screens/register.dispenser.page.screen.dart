import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/controllers/register.controller.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/calculator.button.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';

class RegisterDispenserPage extends StatefulWidget {
  final int pageIndex;
  final dynamic dispenserReader;
  final int totalPages;

  const RegisterDispenserPage({
    super.key,
    required this.pageIndex,
    required this.dispenserReader,
    required this.totalPages,
    required PageController pageController,
  });

  @override
  _RegisterDispenserPageState createState() => _RegisterDispenserPageState();
}

class _RegisterDispenserPageState extends State<RegisterDispenserPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String capitalizeFirstLetterOfEachWord(String text) {
      if (text.isEmpty) return text;

      List<String> words = text.split(' ');
      List<String> capitalizedWords = [];

      for (String word in words) {
        if (word.isNotEmpty) {
          String capitalizedWord = word.substring(0, 1).toUpperCase() +
              word.substring(1).toLowerCase();
          capitalizedWords.add(capitalizedWord);
        }
      }

      return capitalizedWords.join(' ');
    }

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final calculatorCtrl = Get.put(RegisterButtonsController());

    // Obtener los datos necesarios del JSON
    final String fuelName = widget.dispenserReader['assignmentHoseId']['hoseId']
        ['fuelId']['fuelName'];
    final String sideName =
        widget.dispenserReader['assignmentHoseId']['sideId']['sideName'];
    final String dispenserCode = widget.dispenserReader['assignmentHoseId']
        ['assignmentId']['dispenserId']['dispenserCode'];

    // Asegurarse de que actualNoMechanic es un String
    final String actualNoMechanic =
        widget.dispenserReader['actualNoMechanic'].toString();

    // Controlador para el TextField
    final TextEditingController actualNoMechanicController =
        TextEditingController(text: actualNoMechanic);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_gas_station), // Icono para fuelName
                    SizedBox(width: 5), // Espacio entre el icono y el texto
                    Text(
                      capitalizeFirstLetterOfEachWord(fuelName),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      capitalizeFirstLetterOfEachWord(dispenserCode),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Icon(Icons.arrow_forward), // Icono de flecha hacia adelante
                    Text(
                      capitalizeFirstLetterOfEachWord(sideName),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Numeración: < ${widget.pageIndex + 1} / ${widget.totalPages}>',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic, // Texto en cursiva
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200, // Altura máxima del contenedor de los Cards
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(3, (index) {
                    return Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: actualNoMechanicController,
                              readOnly: true, // Configurar como de solo lectura
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            TextField(
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Ingrese numeración de la bomba',
                              ),
                            ),
                            SizedBox(height: 20),
                            // Otros widgets necesarios dentro del Card
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        if (pageController.page != null &&
                            pageController.page! > 0) {
                          pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent,
                        elevation: 5,
                        shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.arrowshape_turn_up_left),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción cuando se presiona el botón Clear
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red[400],
                        elevation: 5,
                        shadowColor: Colors.red[400]!.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Icon(Icons.clear),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción cuando se presiona el botón Thumb Up
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green[600],
                        elevation: 5,
                        shadowColor: Colors.green[600]!.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.hand_thumbsup),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        if (pageController.page != null &&
                            pageController.page! < 2) {
                          pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent,
                        elevation: 5,
                        shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.arrowshape_turn_up_right),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CalculatorButton(
                text: '7',
                onPressed: () => calculatorCtrl.addNumber('7'),
              ),
              CalculatorButton(
                text: '8',
                onPressed: () => calculatorCtrl.addNumber('8'),
              ),
              CalculatorButton(
                text: '9',
                onPressed: () => calculatorCtrl.addNumber('9'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CalculatorButton(
                text: '4',
                onPressed: () => calculatorCtrl.addNumber('4'),
              ),
              CalculatorButton(
                text: '5',
                onPressed: () => calculatorCtrl.addNumber('5'),
              ),
              CalculatorButton(
                text: '6',
                onPressed: () => calculatorCtrl.addNumber('6'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CalculatorButton(
                text: '1',
                onPressed: () => calculatorCtrl.addNumber('1'),
              ),
              CalculatorButton(
                text: '2',
                onPressed: () => calculatorCtrl.addNumber('2'),
              ),
              CalculatorButton(
                text: '3',
                onPressed: () => calculatorCtrl.addNumber('3'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CalculatorButton(
                text: '0',
                big: true,
                onPressed: () => calculatorCtrl.addNumber('0'),
              ),
              CalculatorButton(
                text: '.',
                onPressed: () => calculatorCtrl.addDecimalPoint(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
