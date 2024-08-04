import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/modify.dispenser.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/modify.dispenser/build.update.calculator.buttons.dart';

class ModifyDispenserBottomSheet extends StatelessWidget {
  final String title;
  final int cardIndex;
  final String total;
  final ModifyDispenserController modifyController;

  const ModifyDispenserBottomSheet({
    super.key,
    required this.title,
    required this.cardIndex,
    required this.total,
    required this.modifyController,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final originalPreviousText =
        modifyController.previousControllers[cardIndex].text;
    final originalActualText =
        modifyController.actualControllers[cardIndex].text;
    final originalTotal = modifyController.totalValues[cardIndex].value;

    return GestureDetector(
      onVerticalDragUpdate: (_) {},
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 40,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Actualización de: $title',
                style: TextStyle(
                    fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 12, // Incrementa la sombra
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Colors.black, width: 1), // Borde negro
                        ),
                        shadowColor: Colors.blue, // Sombra más oscura
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: modifyController
                                    .previousControllers[cardIndex],
                                decoration: InputDecoration(
                                  labelText: 'Lectura Anterior',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2), // Borde negro
                                  ),
                                ),
                                readOnly: true,
                                enabled: false,
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: modifyController
                                    .actualControllers[cardIndex],
                                decoration: InputDecoration(
                                  labelText: 'Lectura Actual',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2), // Borde negro
                                  ),
                                ),
                                readOnly: true,
                                showCursor: false,
                                enableInteractiveSelection: false,
                              ),
                              const SizedBox(height: 8),
                              Obx(() => Text(
                                    'Total: ${modifyController.formatTotalValue(modifyController.totalValues[cardIndex].value)}',
                                    style: modifyController
                                        .getTotalTextStyle(cardIndex),
                                  )),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.check,
                                            color: Colors.white),
                                        onPressed: () {
                                          modifyController.validateFields(
                                            context,
                                            modifyController,
                                            cardIndex,
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Colors.purple),
                                        ),
                                      ),
                                      Text(
                                        'Confirmar',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () {
                                          modifyController
                                              .previousControllers[cardIndex]
                                              .text = originalPreviousText;
                                          modifyController
                                              .actualControllers[cardIndex]
                                              .text = originalActualText;
                                          modifyController
                                              .totalValues[cardIndex]
                                              .value = originalTotal;
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Colors.red),
                                        ),
                                      ),
                                      Text(
                                        'Cancelar',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    UpdateCalculatorButtons(cardIndex: cardIndex),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
