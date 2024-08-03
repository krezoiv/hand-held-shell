import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';

class RegisterCard extends StatelessWidget {
  final String title;
  final String value;
  final int cardIndex;
  final String difference;
  final Color? titleColor;
  final ThemeController themeController;
  final DispenserController dispenserController;
  final int pageIndex;

  const RegisterCard({
    super.key,
    required this.title,
    required this.value,
    required this.cardIndex,
    required this.difference,
    this.titleColor,
    required this.themeController,
    required this.dispenserController,
    required this.pageIndex,
  });

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

  @override
  Widget build(BuildContext context) {
    final devicePadding = MediaQuery.of(context).size.width * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: devicePadding),
      child: Card(
        elevation: 12, // Incrementa aún más la sombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black, width: 1), // Borde negro
        ),
        shadowColor: Colors.blue, // Sombra más oscura
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.fromLTRB(devicePadding, 5, devicePadding, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: titleColor ??
                                  (themeController.isDarkMode
                                      ? Colors.white
                                      : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Text(
                              difference,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: getDifferenceColor(),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          TextField(
                            controller: TextEditingController(
                                text: formatNumber(value)),
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2), // Borde negro
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              fillColor: themeController.isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.white,
                              filled: true,
                            ),
                            style: TextStyle(
                              fontSize: 20,
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
                                    .textControllers[pageIndex][cardIndex],
                                focusNode: dispenserController
                                    .focusNodes[pageIndex][cardIndex],
                                readOnly: true,
                                onChanged: (value) {
                                  dispenserController.updateTextField(
                                      pageIndex, cardIndex, value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2), // Borde negro
                                  ),
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
                                  fontSize: 20,
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
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Obx(() => ElevatedButton(
                              onPressed: dispenserController
                                      .buttonsEnabled[pageIndex][cardIndex]
                                      .value
                                  ? () => dispenserController
                                      .validateAndDisableFields(
                                          pageIndex, cardIndex)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[800],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }
}
