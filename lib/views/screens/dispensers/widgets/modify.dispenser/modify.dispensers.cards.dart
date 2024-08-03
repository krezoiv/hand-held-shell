import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/disepensers/modify.dispenser.controller.dart';
import 'package:hand_held_shell/shared/helpers/show.confirm.alert.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/modify.dispenser/modify.dispenser.bottom.sheet.dart';

class ModifyDispenserCards {
  final DispenserController controller;
  final ModifyDispenserController modifyController;
  final String? dispenserReaderId;

  ModifyDispenserCards({
    required this.controller,
    required this.modifyController,
    this.dispenserReaderId,
  });

  Widget buildInfoCard(
      BuildContext context, String title, List<String> details) {
    return Card(
      elevation: 12, // Incrementa aún más la sombra
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.black, width: 1), // Borde negro
      ),
      shadowColor: Colors.blue, // Sombra más oscura
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Acción opcional al hacer clic en el Card
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...details.map((detail) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(detail),
                  )),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.save, color: Colors.white),
                        onPressed: (controller.isLoading.value ||
                                dispenserReaderId == null)
                            ? null
                            : () {
                                showConfirmationDialog(
                                  title: 'Confirmación',
                                  message: '¿Deseas guardar los cambios?',
                                  onConfirm: () async {
                                    modifyController.updateDispenserReader(
                                        dispenserReaderId!);
                                    for (int i = 0; i < 3; i++) {
                                      controller.updateTextField(
                                          0,
                                          i,
                                          modifyController
                                              .actualControllers[i].text);
                                    }
                                    Get.toNamed('/new-register-dispenser');
                                  },
                                );
                              },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                        ),
                      ),
                      Text(
                        'Guardar',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          showConfirmationDialog(
                            title: 'Salir',
                            message: '¿Saldrás sin guardar cambios?',
                            onConfirm: () async {
                              Get.toNamed('/new-register-dispenser');
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
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
    );
  }

  Widget buildEditableCard(BuildContext context, String title, int cardIndex,
      Map<String, dynamic> detail) {
    String totalKey = 'totalNo${title.toLowerCase().capitalize}';
    return GetBuilder<ModifyDispenserController>(builder: (modifyController) {
      return Card(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(
                      text: modifyController.formatNumberWithCommas(
                          modifyController
                              .previousControllers[cardIndex].text)),
                  decoration: InputDecoration(
                    labelText: 'Lectura Anterior',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.black, width: 2), // Borde negro
                    ),
                  ),
                  enabled: false,
                  readOnly: true,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(
                      text: modifyController.formatNumberWithCommas(
                          modifyController.actualControllers[cardIndex].text)),
                  decoration: InputDecoration(
                    labelText: 'Lectura Actual',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.black, width: 2), // Borde negro
                    ),
                  ),
                  readOnly: true,
                  showCursor: false,
                  enableInteractiveSelection: false,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return ModifyDispenserBottomSheet(
                          title: title,
                          cardIndex: cardIndex,
                          total: detail[totalKey]?.toString() ?? 'N/A',
                          modifyController: modifyController,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                Obx(() => Text(
                      'Total: ${modifyController.formatNumberWithCommas(modifyController.totalValues[cardIndex].value)}',
                      style: modifyController.getTotalTextStyle(cardIndex),
                    )),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
