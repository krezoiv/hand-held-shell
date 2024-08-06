import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/models/models/fuel.station/fuel.model.dart';
import 'package:hand_held_shell/models/models/fuel.station/status/status.model.dart';
import 'package:hand_held_shell/models/models/taxes/taxes.model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/fuels/fuels.controller.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/sales/widgets/side.menu.sale.dart';
import 'package:intl/intl.dart';

class NewSalesScreen extends StatefulWidget {
  const NewSalesScreen({super.key});

  @override
  _NewSalesScreenState createState() => _NewSalesScreenState();
}

class _NewSalesScreenState extends State<NewSalesScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final DispenserController dispenserController =
      Get.put(DispenserController());
  final FuelController fuelController = Get.put(FuelController());

  final totalSalesRegular = 0.0.obs;
  final totalSalesSuper = 0.0.obs;
  final totalSalesDiesel = 0.0.obs;

  final totalPayments = 0.0.obs;
  final totalSaldo = 0.0.obs;

  final gastos = '0.000'.obs;
  final vales = '0.000'.obs;
  final cupones = '0.000'.obs;
  final vouchers = '0.000'.obs;
  final depositos = '0.000'.obs;
  final creditos = '0.000'.obs;
  final cheques = '0.000'.obs;

  double get totalSales =>
      totalSalesRegular.value + totalSalesSuper.value + totalSalesDiesel.value;

  @override
  void initState() {
    super.initState();
    loadState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Cuadre DLP'),
        actions: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: dispenserController.isDataLoaded.value
                    ? () {
                        // Acción al presionar el botón de guardar
                      }
                    : null,
                child: const Text('Guardar'),
              ),
            );
          }),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await clearState();
            },
          ),
        ],
      ),
      drawer: SideMenuSale(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
      body: Obx(() {
        return Column(
          children: [
            Opacity(
              opacity:
                  dispenserController.isSummaryCardEnabled.value ? 1.0 : 0.5,
              child: IgnorePointer(
                ignoring: !dispenserController.isSummaryCardEnabled.value,
                child: buildCardSummary(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Opacity(
                      opacity:
                          dispenserController.isDataLoaded.value ? 1.0 : 0.5,
                      child: IgnorePointer(
                        ignoring: !dispenserController.isDataLoaded.value,
                        child: buildCardInformation(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Opacity(
                      opacity:
                          dispenserController.isDataLoaded.value ? 1.0 : 0.5,
                      child: IgnorePointer(
                        ignoring: !dispenserController.isDataLoaded.value,
                        child: buildCardPayments(),
                      ),
                    ),
                    const SizedBox(height: 100), // Añadir más espacio al final
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildCardSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onDoubleTap: () async {
          await dispenserController.fetchLastGeneralDispenserReaderData();
          await fuelController.fetchFuels();
          calculateTotalSales();
          updatePayments();
          saveState(); // Guarda el estado después de cargar los datos
        },
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
          shadowColor: Colors.blue,
          child: InkWell(
            onTap: () {
              // Acción al presionar el Card Summary
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Obx(() {
                      final reader =
                          dispenserController.lastGeneralDispenserReader.value;
                      if (reader == null) {
                        return const Text('Haz doble tap para cargar la fecha',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold));
                      }
                      final formattedDate =
                          DateFormat('dd-MM-yyyy').format(reader.readingDate);
                      return Text(
                        'Fecha: $formattedDate',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Venta:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(() => Text(totalSales.toStringAsFixed(3))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pagos:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(() => Text(totalPayments.toStringAsFixed(3))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Saldo:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(() => Text(totalSaldo.toStringAsFixed(3))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        shadowColor: Colors.blue,
        child: InkWell(
          onTap: () {
            // Acción al presionar el Card Information
          },
          child: Obx(() {
            final fuels = fuelController.fuels;
            if (fuels.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No hay información de combustibles disponible'),
                ),
              );
            }

            final regular = fuels.firstWhere(
                (fuel) => fuel.fuelName == 'regular',
                orElse: () => Fuel(
                    fuelName: 'regular',
                    costPrice: 0.0,
                    salePrice: 0.0,
                    statusId: Status(id: '', statusName: ''),
                    taxesId: Taxes(id: '', idpName: '', idpAmount: 0.0),
                    fuelId: ''));
            final superFuel = fuels.firstWhere(
                (fuel) => fuel.fuelName == 'super',
                orElse: () => Fuel(
                    fuelName: 'super',
                    costPrice: 0.0,
                    salePrice: 0.0,
                    statusId: Status(id: '', statusName: ''),
                    taxesId: Taxes(id: '', idpName: '', idpAmount: 0.0),
                    fuelId: ''));
            final diesel = fuels.firstWhere((fuel) => fuel.fuelName == 'diesel',
                orElse: () => Fuel(
                    fuelName: 'diesel',
                    costPrice: 0.0,
                    salePrice: 0.0,
                    statusId: Status(id: '', statusName: ''),
                    taxesId: Taxes(id: '', idpName: '', idpAmount: 0.0),
                    fuelId: ''));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: Text('Informacion',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Regular'),
                      SizedBox(width: 16),
                      Text('Super'),
                      SizedBox(width: 16),
                      Text('Diesel'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Precios',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${regular.salePrice}'),
                      SizedBox(width: 16),
                      Text('${superFuel.salePrice}'),
                      SizedBox(width: 16),
                      Text('${diesel.salePrice}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Ventas',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        final reader = dispenserController
                            .lastGeneralDispenserReader.value;
                        if (reader == null) {
                          return const Text('0.000');
                        }
                        return Text(
                            '${reader.totalMechanicRegular.toStringAsFixed(3)}');
                      }),
                      SizedBox(width: 16),
                      Obx(() {
                        final reader = dispenserController
                            .lastGeneralDispenserReader.value;
                        if (reader == null) {
                          return const Text('0.000');
                        }
                        return Text(
                            '${reader.totalMechanicSuper.toStringAsFixed(3)}');
                      }),
                      SizedBox(width: 16),
                      Obx(() {
                        final reader = dispenserController
                            .lastGeneralDispenserReader.value;
                        if (reader == null) {
                          return const Text('0.000');
                        }
                        return Text(
                            '${reader.totalMechanicDiesel.toStringAsFixed(3)}');
                      }),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildCardPayments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        shadowColor: Colors.blue,
        child: InkWell(
          onTap: () {
            // Acción al presionar el Card Payments
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                    child: Text('Payments',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                buildSingleTextField('Gastos', gastos),
                buildSingleTextField('Vales', vales),
                buildSingleTextField('Cupones', cupones),
                buildSingleTextField('Vouchers', vouchers),
                buildSingleTextField('Depósitos', depositos),
                buildSingleTextField('Créditos', creditos),
                buildSingleTextField('Cheques', cheques),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSingleTextField(String label, RxString controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(() {
        final textEditingController =
            TextEditingController(text: controller.value);
        textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length),
        );
        return TextField(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          controller: textEditingController,
          onChanged: (value) {
            controller.value = value;
            calculateTotalSales();
            saveState(); // Guarda el estado cuando cambian los valores
          },
        );
      }),
    );
  }

  void calculateTotalSales() {
    final reader = dispenserController.lastGeneralDispenserReader.value;
    final fuels = fuelController.fuels;

    if (reader != null && fuels.isNotEmpty) {
      final regular = fuels.firstWhere((fuel) => fuel.fuelName == 'regular');
      final superFuel = fuels.firstWhere((fuel) => fuel.fuelName == 'super');
      final diesel = fuels.firstWhere((fuel) => fuel.fuelName == 'diesel');

      totalSalesRegular.value = regular.salePrice * reader.totalMechanicRegular;
      totalSalesSuper.value = superFuel.salePrice * reader.totalMechanicSuper;
      totalSalesDiesel.value = diesel.salePrice * reader.totalMechanicDiesel;

      totalPayments.value = double.parse(gastos.value) +
          double.parse(vales.value) +
          double.parse(cupones.value) +
          double.parse(vouchers.value) +
          double.parse(depositos.value) +
          double.parse(creditos.value) +
          double.parse(cheques.value);

      totalSaldo.value = totalSales - totalPayments.value;
    }
  }

  void updatePayments() {
    gastos.value = '0.000';
    vales.value = '0.000';
    cupones.value = '0.000';
    vouchers.value = '0.000';
    depositos.value = '0.000';
    creditos.value = '0.000';
    cheques.value = '0.000';
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalSalesRegular', totalSalesRegular.value);
    await prefs.setDouble('totalSalesSuper', totalSalesSuper.value);
    await prefs.setDouble('totalSalesDiesel', totalSalesDiesel.value);
    await prefs.setDouble('totalPayments', totalPayments.value);
    await prefs.setDouble('totalSaldo', totalSaldo.value);

    await prefs.setString('gastos', gastos.value);
    await prefs.setString('vales', vales.value);
    await prefs.setString('cupones', cupones.value);
    await prefs.setString('vouchers', vouchers.value);
    await prefs.setString('depositos', depositos.value);
    await prefs.setString('creditos', creditos.value);
    await prefs.setString('cheques', cheques.value);
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    totalSalesRegular.value = prefs.getDouble('totalSalesRegular') ?? 0.0;
    totalSalesSuper.value = prefs.getDouble('totalSalesSuper') ?? 0.0;
    totalSalesDiesel.value = prefs.getDouble('totalSalesDiesel') ?? 0.0;
    totalPayments.value = prefs.getDouble('totalPayments') ?? 0.0;
    totalSaldo.value = prefs.getDouble('totalSaldo') ?? 0.0;

    gastos.value = prefs.getString('gastos') ?? '0.000';
    vales.value = prefs.getString('vales') ?? '0.000';
    cupones.value = prefs.getString('cupones') ?? '0.000';
    vouchers.value = prefs.getString('vouchers') ?? '0.000';
    depositos.value = prefs.getString('depositos') ?? '0.000';
    creditos.value = prefs.getString('creditos') ?? '0.000';
    cheques.value = prefs.getString('cheques') ?? '0.000';
  }

  Future<void> clearState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('totalSalesRegular');
    await prefs.remove('totalSalesSuper');
    await prefs.remove('totalSalesDiesel');
    await prefs.remove('totalPayments');
    await prefs.remove('totalSaldo');
    await prefs.remove('gastos');
    await prefs.remove('vales');
    await prefs.remove('cupones');
    await prefs.remove('vouchers');
    await prefs.remove('depositos');
    await prefs.remove('creditos');
    await prefs.remove('cheques');
    loadState(); // Vuelve a cargar el estado para asegurarse de que se restablezcan los valores
  }
}
