import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/disepensers/modify.dispenser.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/modify.dispenser/modify.dispensers.cards.dart';

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

    final modifyDispenserCards = ModifyDispenserCards(
      controller: controller,
      modifyController: modifyController,
      dispenserReaderId: dispenserReaderId,
    );

    // Obtener tamaño de pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Actualizacion de Bomba',
          style: TextStyle(
              fontSize: screenWidth * 0.05), // Ajuste de tamaño de fuente
        ),
      ),
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
                    modifyDispenserCards
                        .buildInfoCard(context, 'Información General', [
                      'Fuel: ${detail['assignmentHoseId']['hoseId']['fuelId']['fuelName']}',
                      'Side: ${detail['assignmentHoseId']['sideId']['sideName']}',
                      'Dispenser: ${detail['assignmentHoseId']['assignmentId']['dispenserId']['dispenserCode']}',
                    ]),
                    const SizedBox(height: 16),
                    modifyDispenserCards.buildEditableCard(
                        context, 'Galones', 0, detail),
                    const SizedBox(height: 16),
                    modifyDispenserCards.buildEditableCard(
                        context, 'Mecánica', 1, detail),
                    const SizedBox(height: 16),
                    modifyDispenserCards.buildEditableCard(
                        context, 'Dinero', 2, detail),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
