import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/disepensers/modify.dispenser.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/build.update.calculator.buttons.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';

class ModifyDispenserReaderScreen extends StatefulWidget {
  const ModifyDispenserReaderScreen({super.key});

  @override
  _ModifyDispenserReaderScreenState createState() =>
      _ModifyDispenserReaderScreenState();
}

class _ModifyDispenserReaderScreenState
    extends State<ModifyDispenserReaderScreen> {
  late ModifyDispenserController modifyController;
  late DispenserController controller;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ModifyDispenserController controllers =
      Get.put(ModifyDispenserController());
  String? dispenserReaderId;

  @override
  void initState() {
    super.initState();
    modifyController = Get.put(ModifyDispenserController());

    controller = Get.find<DispenserController>();
    final Map<String, dynamic> args = Get.arguments ?? {};
    dispenserReaderId = args['dispenserReaderId'] as String?;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDispenserReaderDetail(dispenserReaderId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String dispenserReaderId = args['dispenserReaderId'] ?? 'No ID';

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Dispenser Id: $dispenserReaderId'),
      ),
      drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
      body: GetX<DispenserController>(
        builder: (_) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.dispenserReaderDetail.value.isEmpty) {
            return const Center(child: Text('No se encontraron detalles'));
          } else {
            final detail = controller.dispenserReaderDetail.value;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoCard(context, 'Información General', [
                      'Fuel: ${detail['assignmentHoseId']['hoseId']['fuelId']['fuelName']}',
                      'Side: ${detail['assignmentHoseId']['sideId']['sideName']}',
                      'Dispenser: ${detail['assignmentHoseId']['assignmentId']['dispenserId']['dispenserCode']}',
                    ]),
                    const SizedBox(height: 16),
                    _buildEditableCard('Galones', 0, detail),
                    const SizedBox(height: 16),
                    _buildEditableCard('Mecánica', 1, detail),
                    const SizedBox(height: 16),
                    _buildEditableCard('Dinero', 2, detail),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<String> details) {
    return Card(
      elevation: 4,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (controller.isLoading.value ||
                          dispenserReaderId == null)
                      ? null
                      : () =>
                          controllers.updateDispenserReader(dispenserReaderId!),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator()
                      : Text('Guardar Cambios'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/new-register-dispenser');
                  },
                  icon: Icon(Icons.cancel, color: Colors.white),
                  label:
                      Text('Cancelar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableCard(
      String title, int cardIndex, Map<String, dynamic> detail) {
    String totalKey = 'totalNo${title.toLowerCase().capitalize}';
    return GetBuilder<ModifyDispenserController>(builder: (modifyController) {
      return Card(
        elevation: 4,
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
                        modifyController.previousControllers[cardIndex].text)),
                decoration: InputDecoration(
                  labelText: 'Lectura Anterior',
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                showCursor: false,
                enableInteractiveSelection: false,
                onTap: () {
                  _showBottomSheet(context, title, cardIndex,
                      detail[totalKey]?.toString() ?? 'N/A');
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
      );
    });
  }

  void _showBottomSheet(
      BuildContext context, String title, int cardIndex, String total) {
    // Almacenar los valores originales antes de mostrar el BottomSheet
    final originalPreviousText =
        modifyController.previousControllers[cardIndex].text;
    final originalActualText =
        modifyController.actualControllers[cardIndex].text;
    final originalTotal = modifyController.totalValues[cardIndex].value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GetBuilder<ModifyDispenserController>(
          builder: (modifyController) {
            return GestureDetector(
              onVerticalDragUpdate: (_) {}, // Disable vertical drag to close
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Actualización de: $title',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Restaurar los valores originales y cerrar el BottomSheet
                              modifyController.previousControllers[cardIndex]
                                  .text = originalPreviousText;
                              modifyController.actualControllers[cardIndex]
                                  .text = originalActualText;
                              modifyController.totalValues[cardIndex].value =
                                  originalTotal;
                              Navigator.pop(context);
                            },
                            child: Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(
                                            text: modifyController
                                                .formatNumberWithCommas(
                                                    modifyController
                                                        .previousControllers[
                                                            cardIndex]
                                                        .text)),
                                        decoration: InputDecoration(
                                          labelText: 'Lectura Anterior',
                                          border: OutlineInputBorder(),
                                        ),
                                        readOnly: true,
                                        enabled: false,
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: TextEditingController(
                                            text: modifyController
                                                .formatNumberWithCommas(
                                                    modifyController
                                                        .actualControllers[
                                                            cardIndex]
                                                        .text)),
                                        decoration: InputDecoration(
                                          labelText: 'Lectura Actual',
                                          border: OutlineInputBorder(),
                                        ),
                                        readOnly: true,
                                        showCursor: false,
                                        enableInteractiveSelection: false,
                                      ),
                                      const SizedBox(height: 8),
                                      Obx(() => Text(
                                            'Total: ${modifyController.totalValues[cardIndex].value}',
                                            style: modifyController
                                                .getTotalTextStyle(cardIndex),
                                          )),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                _validateFields(
                                                    context,
                                                    modifyController,
                                                    cardIndex);
                                              },
                                              icon: Icon(Icons.check,
                                                  color: Colors.white),
                                              label: Text('Confirmar',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.purple,
                                              ),
                                            ),
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
          },
        );
      },
    );
  }

  void _validateFields(BuildContext context,
      ModifyDispenserController modifyController, int cardIndex) {
    String actualReading = modifyController.actualControllers[cardIndex].text;
    double totalValue = double.tryParse(modifyController
            .totalValues[cardIndex].value
            .replaceAll(',', '')) ??
        0;

    if (totalValue < 0) {
      _showErrorDialog(context, 'La numeración no puede estar negativa');
    } else if (actualReading.isEmpty) {
      _showErrorDialog(context, 'La Lectura Actual no puede estar vacía');
    } else {
      Navigator.pop(context); // Cerrar el BottomSheet si las validaciones pasan
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
