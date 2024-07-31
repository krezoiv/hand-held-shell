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

  @override
  void initState() {
    super.initState();
    modifyController = Get.put(ModifyDispenserController());
    controller = Get.find<DispenserController>();
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String dispenserReaderId = args['dispenserReaderId'] ?? 'No ID';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDispenserReaderDetail(dispenserReaderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lógica para actualizar
                },
                icon: Icon(Icons.save_as_outlined, color: Colors.white),
                label: Text('Guardar Cambios',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.tealAccent[700],
                ),
              ),
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
                controller: modifyController.previousControllers[cardIndex],
                decoration: InputDecoration(
                  labelText: 'Lectura Anterior',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
                readOnly: true,
              ),
              SizedBox(height: 8),
              TextField(
                controller: modifyController.actualControllers[cardIndex],
                decoration: InputDecoration(
                  labelText: 'Lectura Actual',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 8),
              Text('Total: ${modifyController.totalValues[cardIndex].value}'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showBottomSheet(context, title, cardIndex,
                        detail[totalKey]?.toString() ?? 'N/A'),
                    icon: Icon(Icons.sync),
                    label: Text('Modificar'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showBottomSheet(
      BuildContext context, String title, int cardIndex, String total) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GetBuilder<ModifyDispenserController>(
          builder: (modifyController) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (_, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
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
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
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
                                                  // Aquí puedes implementar la lógica para confirmar los cambios
                                                  // Por ejemplo:
                                                  // modifyController.confirmChanges(cardIndex);
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.check,
                                                    color: Colors.white),
                                                label: Text('Confirmar',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Colors.purple,
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
                );
              },
            );
          },
        );
      },
    );
  }
}
