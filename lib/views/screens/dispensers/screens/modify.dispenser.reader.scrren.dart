import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/update.calculator.buttonss.dart';

class ModifyDispenserReaderScreen extends StatefulWidget {
  const ModifyDispenserReaderScreen({super.key});

  @override
  _ModifyDispenserReaderScreenState createState() =>
      _ModifyDispenserReaderScreenState();
}

class _ModifyDispenserReaderScreenState
    extends State<ModifyDispenserReaderScreen> {
  final TextEditingController previousGallonsController =
      TextEditingController();
  final TextEditingController actualGallonsController = TextEditingController();
  final TextEditingController previousMechanicController =
      TextEditingController();
  final TextEditingController actualMechanicController =
      TextEditingController();
  final TextEditingController previousMoneyController = TextEditingController();
  final TextEditingController actualMoneyController = TextEditingController();

  final RxBool isGallonsEditable = false.obs;
  final RxBool isMechanicEditable = false.obs;
  final RxBool isMoneyEditable = false.obs;

  late DispenserController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DispenserController>();
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String dispenserReaderId = args['dispenserReaderId'] ?? 'No ID';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDispenserReaderDetail(dispenserReaderId);
    });
  }

  void updateControllers(Map<String, dynamic> detail) {
    previousGallonsController.text = detail['previousNoGallons'].toString();
    actualGallonsController.text = detail['actualNoGallons'].toString();
    previousMechanicController.text = detail['previousNoMechanic'].toString();
    actualMechanicController.text = detail['actualNoMechanic'].toString();
    previousMoneyController.text = detail['previousNoMoney'].toString();
    actualMoneyController.text = detail['actualNoMoney'].toString();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String dispenserReaderId = args['dispenserReaderId'] ?? 'No ID';

    return FocusScope(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Dispenser Id: $dispenserReaderId'),
        ),
        drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.dispenserReaderDetail.value.isEmpty) {
            return const Center(child: Text('No se encontraron detalles'));
          } else {
            final detail = controller.dispenserReaderDetail.value;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              updateControllers(detail);
            });

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
                    _buildEditableCard(
                        'Galones',
                        previousGallonsController,
                        actualGallonsController,
                        detail['totalNoGallons'].toString(),
                        isGallonsEditable,
                        0),
                    const SizedBox(height: 16),
                    _buildEditableCard(
                        'Mecánico',
                        previousMechanicController,
                        actualMechanicController,
                        detail['totalNoMechanic'].toString(),
                        isMechanicEditable,
                        1),
                    const SizedBox(height: 16),
                    _buildEditableCard(
                        'Dinero',
                        previousMoneyController,
                        actualMoneyController,
                        detail['totalNoMoney'].toString(),
                        isMoneyEditable,
                        2),
                  ],
                ),
              ),
            );
          }
        }),
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
      String title,
      TextEditingController previousController,
      TextEditingController actualController,
      String total,
      RxBool isEditable,
      int cardIndex) {
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
              controller: previousController,
              decoration: InputDecoration(
                labelText: 'Numeración Anterior',
                border: OutlineInputBorder(),
              ),
              enabled: false,
              readOnly: true,
            ),
            SizedBox(height: 8),
            Obx(() => TextField(
                  controller: actualController,
                  decoration: InputDecoration(
                    labelText: 'Numeración Actual',
                    border: OutlineInputBorder(),
                  ),
                  enabled: isEditable.value,
                  readOnly: !isEditable.value,
                  showCursor: isEditable.value,
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Total: $total'),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    isEditable.value = !isEditable.value;
                    if (isEditable.value) {
                      _showBottomSheet(context, title, cardIndex, total);
                    }
                  },
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
  }

  void _showBottomSheet(
      BuildContext context, String title, int cardIndex, String total) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
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
                            child: _buildSelectedCard(title, cardIndex, total),
                          ),
                          SizedBox(height: 16),
                          UpdateCalculatorButtons(pageIndex: cardIndex),
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
  }

  Widget _buildSelectedCard(String title, int cardIndex, String total) {
    TextEditingController previousController;
    TextEditingController actualController;
    RxBool isEditable;

    switch (cardIndex) {
      case 0:
        previousController = previousGallonsController;
        actualController = actualGallonsController;
        isEditable = isGallonsEditable;
        break;
      case 1:
        previousController = previousMechanicController;
        actualController = actualMechanicController;
        isEditable = isMechanicEditable;
        break;
      case 2:
        previousController = previousMoneyController;
        actualController = actualMoneyController;
        isEditable = isMoneyEditable;
        break;
      default:
        throw Exception("Invalid card index");
    }

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
              controller: previousController,
              decoration: InputDecoration(
                labelText: 'Previous',
                border: OutlineInputBorder(),
              ),
              enabled: false,
              readOnly: true,
              showCursor: false,
              enableInteractiveSelection: false,
            ),
            SizedBox(height: 8),
            Obx(
              () => TextField(
                controller: actualController,
                decoration: InputDecoration(
                  labelText: 'Actual',
                  border: OutlineInputBorder(),
                ),
                enabled: isEditable.value,
                readOnly: !isEditable.value,
                showCursor: isEditable.value,
                enableInteractiveSelection: isEditable.value,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Total: $total'),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Lógica del botón Check
                    },
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text('Confirmar',
                        style: TextStyle(color: Colors.white)),
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
    );
  }
}
