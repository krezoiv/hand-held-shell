import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hand_held_shell/controllers/accounting/coupons/coupons.controller.dart';
import 'package:hand_held_shell/controllers/accounting/credits/credits.crontroller.dart';
import 'package:hand_held_shell/controllers/accounting/deposits/deposits.controller.dart';
import 'package:hand_held_shell/controllers/accounting/voucher/voucher.controller.dart';
import 'package:hand_held_shell/controllers/accounting/bank.check/bank.check.controller.dart';
import 'package:hand_held_shell/controllers/accounting/banks/bank.controller.dart';
import 'package:hand_held_shell/controllers/accounting/bills/bills.controller.dart';
import 'package:hand_held_shell/controllers/accounting/vales/vales.controller.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/fuels/fuels.controller.dart';
import 'package:hand_held_shell/controllers/persons/clients/clients.controller.dart';
import 'package:hand_held_shell/controllers/pos/pos.controller.dart';
import 'package:hand_held_shell/controllers/sales/new.sales.controller.dart';
import 'package:hand_held_shell/models/models/acocounting/bank.model.dart';
import 'package:hand_held_shell/models/models/acocounting/pos.model.dart';
import 'package:hand_held_shell/models/models/fuel.station/fuel.model.dart';
import 'package:hand_held_shell/models/models/persons/client.model.dart';
import 'package:hand_held_shell/models/models/status/status.model.dart';
import 'package:hand_held_shell/models/models/taxes/taxes.model.dart';
import 'package:hand_held_shell/shared/helpers/show.confirm.dialog.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/sales/widgets/side.menu.sale.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TabType { Gastos, Vales, Cheques, Cupones, Vouchers, Depositos, Creditos }

class NewSalesScreen extends StatefulWidget {
  const NewSalesScreen({super.key});

  @override
  _NewSalesScreenState createState() => _NewSalesScreenState();
}

class _NewSalesScreenState extends State<NewSalesScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late DispenserController dispenserController;
  late SalesControlController salesControlController;
  late FuelController fuelController;
  late PosController posController;
  late BankController bankController;
  late ClientsController clientsController;
  late BankCheckController bankCheckController;
  late BillsController billsController;
  late ValesController valesController;
  CouponsController? couponsController;
  VoucherController? voucherController;
  DepositsController? depositsController;
  CreditsController? creditsController;

  String? selectedBankDeposit;
  String? selectedBankCheck;
  String? selectedClientChecks;
  String? selectedPOS;
  String? selectedClientCredits;

  TextEditingController billNumberController = TextEditingController();
  TextEditingController billDateController = TextEditingController();
  TextEditingController billAmountController = TextEditingController();
  TextEditingController billDescriptionController = TextEditingController();

  TextEditingController valeNumberController = TextEditingController();
  TextEditingController valeDescriptionController = TextEditingController();
  TextEditingController valeAmountController = TextEditingController();
  TextEditingController valeDateController = TextEditingController();

  TextEditingController couponsNumberController = TextEditingController();
  TextEditingController couponsAmountController = TextEditingController();
  TextEditingController couponsDateController = TextEditingController();

  TextEditingController voucherAmountController = TextEditingController();
  TextEditingController authorizationCodeController = TextEditingController();
  TextEditingController voucherDateController = TextEditingController();

  TextEditingController depositNumberController = TextEditingController();
  TextEditingController depositAmountController = TextEditingController();
  TextEditingController depositDateController = TextEditingController();

  TextEditingController creditNumberController = TextEditingController();
  TextEditingController creditAmountController = TextEditingController();
  TextEditingController creditDateController = TextEditingController();
  TextEditingController regularAmountController = TextEditingController();
  TextEditingController superAmountController = TextEditingController();
  TextEditingController dieselAmountController = TextEditingController();

  TextEditingController checkNumberController = TextEditingController();
  TextEditingController checkValueController = TextEditingController();
  TextEditingController checkDateController = TextEditingController();

  final totalSalesRegular = 0.00.obs;
  final totalSalesSuper = 0.00.obs;
  final totalSalesDiesel = 0.00.obs;

  final totalPayments = 0.00.obs;
  final totalSaldo = 0.00.obs;

  final gastos = '0.00'.obs;
  final vales = '0.00'.obs;
  final cupones = '0.00'.obs;
  final vouchers = '0.00'.obs;
  final depositos = '0.00'.obs;
  final creditos = '0.00'.obs;
  final cheques = '0.00'.obs;

  double get totalSales =>
      totalSalesRegular.value + totalSalesSuper.value + totalSalesDiesel.value;

  @override
  void initState() {
    super.initState();

    Get.put(DispenserController(), permanent: true);
    Get.put(FuelController(), permanent: true);
    Get.put(PosController(), permanent: true);
    Get.put(BankController(), permanent: true);
    Get.put(ClientsController(), permanent: true);
    Get.put(SalesControlController(), permanent: true);
    Get.put(BankCheckController(), permanent: true);
    Get.put(BillsController(), permanent: true);
    Get.put(ValesController(), permanent: true);
    Get.put(CouponsController(), permanent: true);
    Get.put(VoucherController(), permanent: true);
    Get.put(DepositsController(), permanent: true);
    Get.put(CreditsController(), permanent: true);

    dispenserController = Get.find<DispenserController>();
    fuelController = Get.find<FuelController>();
    posController = Get.find<PosController>();
    bankController = Get.find<BankController>();
    clientsController = Get.find<ClientsController>();
    salesControlController = Get.find<SalesControlController>();
    bankCheckController = Get.find<BankCheckController>();
    billsController = Get.find<BillsController>();
    valesController = Get.find<ValesController>();
    couponsController = Get.find<CouponsController>();
    voucherController = Get.find<VoucherController>();
    depositsController = Get.find<DepositsController>();
    creditsController = Get.find<CreditsController>();

    loadState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Cuadre DLP'),
        actions: [
          GetBuilder<DispenserController>(
            init: DispenserController(),
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: controller.isDataLoaded.value
                      ? () async {
                          // Muestra el spinner antes de comenzar la operación
                          showDialog(
                            context: context,
                            barrierDismissible:
                                false, // Evita que se cierre al hacer clic fuera del diálogo
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          showConfirmationDialog(
                            title: 'Confirmación',
                            message: '¿Deseas guardar los cambios?',
                            confirmText: 'Sí',
                            cancelText: 'No',
                            onConfirm: () async {
                              Navigator.of(context).pop();

                              Get.offAllNamed(
                                  '/home'); //cierra el diálogo de confirmación

                              try {
                                // Llama al método _updateSalesControl
                                await _updateSalesControl();

                                // Limpia todos los campos
                                clearFields();

                                // Limpia el estado almacenado
                                await clearState();

                                // Reinicia el Summary Card para mostrar el mensaje de no hay información
                                controller.isSummaryCardEnabled.value = true;
                                controller.lastGeneralDispenserReader.value =
                                    null;

                                // Restablece la pantalla como un "hot restart"
                                resetScreenState();

                                // Restablece las pantallas NewRegisterDispenserScreen y RegisterDispenserPage
                                //await controller.clearSharedPreferences();
                                //controller.resetState();

                                // Mostrar mensaje de éxito
                                Get.snackbar(
                                  'Éxito',
                                  'Datos guardados y pantallas actualizadas correctamente',
                                  backgroundColor: Colors.green[600],
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  borderRadius: 20,
                                  duration: Duration(seconds: 3),
                                  isDismissible: true,
                                  dismissDirection: DismissDirection.horizontal,
                                  forwardAnimationCurve: Curves.easeOutBack,
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Ocurrió un error: $e',
                                  backgroundColor: Colors.red[600],
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  borderRadius: 20,
                                  duration: Duration(seconds: 3),
                                  isDismissible: true,
                                  dismissDirection: DismissDirection.horizontal,
                                  forwardAnimationCurve: Curves.easeOutBack,
                                );
                              } finally {
                                // Cierra el spinner después de que se complete la operación
                                //Navigator.of(context).pop();
                                if (Get.isRegistered<DispenserController>()) {
                                  final dispenserController =
                                      Get.find<DispenserController>();
                                  await dispenserController
                                      .clearSharedPreferences();
                                  dispenserController
                                      .resetState(); // Implementa este método en DispenserController
                                }
                              }
                            },
                            onCancel: () {
                              // Cierra el diálogo de confirmación y el spinner si se cancela
                              Get.back();
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      : null,
                  child: const Text('Guardar'),
                ),
              );
            },
          )
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
                    const SizedBox(height: 100),
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
          showConfirmationDialog(
            title: 'Nuevo DLP',
            message: '¿Crear nuevo DLP?',
            confirmText: 'crear',
            cancelText: 'cancelar',
            onConfirm: () async {
              try {
                // Crea un nuevo DLP
                bool isCreated =
                    await salesControlController.createNewSalesControl();

                if (isCreated) {
                  await dispenserController
                      .fetchLastGeneralDispenserReaderData();
                  await fuelController.fetchFuels();
                  calculateTotalSales();
                  updatePayments();
                  saveState();
                  Get.snackbar(
                    'Éxito',
                    'Nuevo DLP creado exitosamente.',
                    backgroundColor: Colors.purple[300],
                    colorText: Colors.white,
                    margin: EdgeInsets.all(10),
                    borderRadius: 20,
                    duration: Duration(seconds: 3),
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                    forwardAnimationCurve: Curves.easeOutBack,
                  );
                } else {
                  Get.snackbar(
                    'Advertencia',
                    'No se pudo crear el nuevo DLP, no se ha aperturado el día.',
                    backgroundColor: Colors.red[600],
                    colorText: Colors.white,
                    margin: EdgeInsets.all(10),
                    borderRadius: 20,
                    duration: Duration(seconds: 3),
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                    forwardAnimationCurve: Curves.easeOutBack,
                  );
                }
              } catch (e) {
                Get.snackbar('Error', 'Ocurrió un error: $e');
              }
            },
            onCancel: () {
              return;
            },
          );
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
                        Obx(() => Text(totalSales.toStringAsFixed(2))),
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
                        Obx(() => Text(totalPayments.toStringAsFixed(2))),
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
                        Obx(() => Text(totalSaldo.toStringAsFixed(2))),
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
      child: GestureDetector(
        onDoubleTap: () async {
          final fuels = fuelController.fuels;

          // Obtén los combustibles desde el controlador
          final regular = fuels.firstWhere((fuel) => fuel.fuelName == 'regular',
              orElse: () => Fuel(
                  fuelName: 'regular',
                  costPrice: 0.000,
                  salePrice: 0.00,
                  statusId: Status(id: '', statusName: ''),
                  taxesId: Taxes(id: '', idpName: '', idpAmount: 0.00),
                  fuelId: ''));
          final superFuel = fuels.firstWhere((fuel) => fuel.fuelName == 'super',
              orElse: () => Fuel(
                  fuelName: 'super',
                  costPrice: 0.00,
                  salePrice: 0.00,
                  statusId: Status(id: '', statusName: ''),
                  taxesId: Taxes(id: '', idpName: '', idpAmount: 0.00),
                  fuelId: ''));
          final diesel = fuels.firstWhere((fuel) => fuel.fuelName == 'diesel',
              orElse: () => Fuel(
                  fuelName: 'diesel',
                  costPrice: 0.00,
                  salePrice: 0.00,
                  statusId: Status(id: '', statusName: ''),
                  taxesId: Taxes(id: '', idpName: '', idpAmount: 0.00),
                  fuelId: ''));

          // Controladores para los TextFields en el diálogo
          TextEditingController regularController =
              TextEditingController(text: regular.salePrice.toStringAsFixed(2));
          TextEditingController superController = TextEditingController(
              text: superFuel.salePrice.toStringAsFixed(2));
          TextEditingController dieselController =
              TextEditingController(text: diesel.salePrice.toStringAsFixed(2));

          // Mostrar el diálogo con los TextFields
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Información de Precios'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildPriceTextField('Precio Regular', regularController),
                    buildPriceTextField('Precio Super', superController),
                    buildPriceTextField('Precio Diesel', dieselController),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Obtiene el FuelController
                      final fuelController = Get.find<FuelController>();

                      // Actualiza los valores en el controlador
                      setState(() {
                        regular.salePrice =
                            double.parse(regularController.text);
                        superFuel.salePrice =
                            double.parse(superController.text);
                        diesel.salePrice = double.parse(dieselController.text);
                      });

                      // Llama al método updateFuelPrices para actualizar los precios en el backend
                      await fuelController.updateFuelPrices(
                        regularPrice: regular.salePrice,
                        superPrice: superFuel.salePrice,
                        dieselPrice: diesel.salePrice,
                      );

                      // Cierra el diálogo después de actualizar los precios
                      Navigator.of(context).pop();
                    },
                    child: const Text('Agregar'),
                  )
                ],
              );
            },
          );
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
              // Acción al presionar el Card Information
            },
            child: Obx(() {
              final fuels = fuelController.fuels;
              if (fuels.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child:
                        Text('No hay información de combustibles disponible'),
                  ),
                );
              }

              final regular = fuels.firstWhere(
                  (fuel) => fuel.fuelName == 'regular',
                  orElse: () => Fuel(
                      fuelName: 'regular',
                      costPrice: 0.000,
                      salePrice: 0.00,
                      statusId: Status(id: '', statusName: ''),
                      taxesId: Taxes(id: '', idpName: '', idpAmount: 0.00),
                      fuelId: ''));
              final superFuel = fuels.firstWhere(
                  (fuel) => fuel.fuelName == 'super',
                  orElse: () => Fuel(
                      fuelName: 'super',
                      costPrice: 0.00,
                      salePrice: 0.00,
                      statusId: Status(id: '', statusName: ''),
                      taxesId: Taxes(id: '', idpName: '', idpAmount: 0.00),
                      fuelId: ''));
              final diesel = fuels.firstWhere(
                  (fuel) => fuel.fuelName == 'diesel',
                  orElse: () => Fuel(
                      fuelName: 'diesel',
                      costPrice: 0.00,
                      salePrice: 0.00,
                      statusId: Status(id: '', statusName: ''),
                      taxesId: Taxes(id: '', idpName: '', idpAmount: 0.00),
                      fuelId: ''));

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: Text('Información',
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${regular.salePrice}'),
                        const SizedBox(width: 16),
                        Text('${superFuel.salePrice}'),
                        const SizedBox(width: 16),
                        Text('${diesel.salePrice}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('Ventas',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() {
                          final reader = dispenserController
                              .lastGeneralDispenserReader.value;
                          if (reader == null) {
                            return const Text('0.00');
                          }
                          return Text(
                              reader.totalMechanicRegular.toStringAsFixed(3));
                        }),
                        const SizedBox(width: 16),
                        Obx(() {
                          final reader = dispenserController
                              .lastGeneralDispenserReader.value;
                          if (reader == null) {
                            return const Text('0.00');
                          }
                          return Text(
                              reader.totalMechanicSuper.toStringAsFixed(3));
                        }),
                        const SizedBox(width: 16),
                        Obx(() {
                          final reader = dispenserController
                              .lastGeneralDispenserReader.value;
                          if (reader == null) {
                            return const Text('0.00');
                          }
                          return Text(
                              reader.totalMechanicDiesel.toStringAsFixed(3));
                        }),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildPriceTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(
              r'^\d*\.?\d{0,2}')), // Permite solo un punto y hasta 2 decimales
        ],
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
                    child: Text('Abonos',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                buildSingleTextField('Gastos', gastos, TabType.Gastos),
                buildSingleTextField('Vales', vales, TabType.Vales),
                buildSingleTextField('Cupones', cupones, TabType.Cupones),
                buildSingleTextField('Vouchers', vouchers, TabType.Vouchers),
                buildSingleTextField('Depositos', depositos, TabType.Depositos),
                buildSingleTextField('Creditos', creditos, TabType.Creditos),
                buildSingleTextField('Cheques', cheques, TabType.Cheques),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSingleTextField(String label, RxString controller, TabType type) {
    return GestureDetector(
      onDoubleTap: () {
        showBottomSheet(label, controller, type);
      },
      child: AbsorbPointer(
        child: Padding(
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
                saveState();
              },
            );
          }),
        ),
      ),
    );
  }

  void showBottomSheet(String label, RxString controller, TabType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.blueAccent,
                  title: const TabBar(
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(text: 'Datos'),
                      Tab(text: 'Tablas'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    _buildDataTab(label, controller),
                    _buildBillsTableTab(type),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataTab(String label, RxString controller) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSpecificFields(label, controller),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        showConfirmationDialog(
                          title: 'Confirmación',
                          message: '¿Guardar los cambios?',
                          confirmText: 'Sí',
                          cancelText: 'No',
                          onConfirm: () async {
                            // Mostrar un spinner mientras se guarda
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            try {
                              bool success = false;
                              // Verificar el label y ejecutar la acción correspondiente
                              if (label == 'Gastos') {
                                success = await createBill();
                                if (success) {
                                  await billsController
                                      .fetchBillsBySalesControl();
                                }
                              } else if (label == 'Vouchers') {
                                success = await createVoucher();
                                if (success) {
                                  await voucherController
                                      ?.fetchVoucherBySalesControl();
                                }
                              } else if (label == 'Vales') {
                                success = await createVale();
                                if (success) {
                                  await valesController
                                      .fetchValesBySalesControl();
                                }
                              } else if (label == "Cupones") {
                                success = await createCoupon();
                                if (success) {
                                  await couponsController
                                      ?.fetchCouponsBySalesControl();
                                }
                              } else if (label == "Depositos") {
                                success = await createDeposits();
                                if (success) {
                                  await depositsController
                                      ?.fetchDepositsBySalesControl();
                                }
                              } else if (label == "Creditos") {
                                success = await createCredit();
                                if (success) {
                                  await creditsController
                                      ?.fetchCreditsBySalesControl();
                                }
                              } else if (label == "Cheques") {
                                success = await createBankCheck();
                                if (success) {
                                  await bankCheckController
                                      .fetchBankCheckBySalesControl();
                                }
                              }
                              FocusScope.of(Get.context!).unfocus();
                              Navigator.pop(context); // Cierra el spinner

                              if (success) {
                                clearFields();
                                // Cambiar al TabTab
                                DefaultTabController.of(context).animateTo(1);
                                // Get.snackbar(
                                //     'Éxito', 'Operación realizada con éxito');
                              } else {
                                FocusScope.of(Get.context!).unfocus();
                                Get.snackbar(
                                  'Error',
                                  'No se pudo completar la operación',
                                  backgroundColor: Colors.red[600],
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  borderRadius: 20,
                                  duration: Duration(seconds: 3),
                                  isDismissible: true,
                                  dismissDirection: DismissDirection.horizontal,
                                  forwardAnimationCurve: Curves.easeOutBack,
                                );
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              Navigator.pop(
                                  context); // Cierra el spinner en caso de error
                              Get.snackbar(
                                'Error',
                                'Hubo un error al guardar: $e',
                                backgroundColor: Colors.red[600],
                                colorText: Colors.white,
                                margin: EdgeInsets.all(10),
                                borderRadius: 20,
                                duration: Duration(seconds: 3),
                                isDismissible: true,
                                dismissDirection: DismissDirection.horizontal,
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      child: const Text('Guardar'),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBillsTableTab(TabType type) {
    return Obx(() {
      // Definir las listas y controladores según el tipo de TabType
      bool isLoading = true;
      List items = [];

      switch (type) {
        case TabType.Gastos:
          isLoading = billsController.isLoading.value;
          items = billsController.billsListResponse.value?.bills ?? [];
          break;
        case TabType.Vouchers:
          isLoading = voucherController?.isLoading.value ?? true;
          items = voucherController?.voucherListResponse.value?.vouchers ?? [];
          break;
        case TabType.Vales:
          isLoading = valesController.isLoading.value;
          items = valesController.valesListResponse.value?.vales ?? [];
          break;
        case TabType.Cupones:
          isLoading = couponsController?.isLoading.value ?? true;
          items = couponsController?.couponsListResponse.value?.coupons ?? [];
          break;
        case TabType.Depositos:
          isLoading = depositsController?.isLoading.value ?? true;
          items =
              depositsController?.depositsitsListResponse.value?.deposits ?? [];
          break;
        case TabType.Creditos:
          isLoading = creditsController?.isLoading.value ?? true;
          items = creditsController?.creditsListResponse.value?.credits ?? [];
          break;
        case TabType.Cheques:
          isLoading = bankCheckController.isLoading.value;
          items =
              bankCheckController.bankCheckListResponse.value?.bankCheck ?? [];
          break;
        default:
          return const Center(child: Text('Tipo no soportado'));
      }

      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          // Inicializa las variables title y subtitle
          String title = '';
          String subtitle = '';

          // Configuración del título y subtítulo para cada tipo de TabType
          if (type == TabType.Gastos) {
            title = 'Gasto No. : ${item.billNumber}';
            subtitle =
                'Monto: ${item.billAmount.toStringAsFixed(2)}\nFecha: ${DateFormat('dd-MM-yyyy').format(item.billDate)}\nDescripción: ${item.billDescription}';
          } else if (type == TabType.Vouchers) {
            title = 'Voucher No. : ${item.authorizationCode ?? 'Sin código'}';
            subtitle =
                'Monto: ${item.voucherAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Fecha: ${item.voucherDate != null ? DateFormat('dd-MM-yyyy').format(item.voucherDate) : 'Sin fecha'}\n'
                'POS: ${item.posId.posName}';
          } else if (type == TabType.Vales) {
            title = 'Vale No. : ${item.valeNumber ?? 'Sin número'}';
            subtitle = 'Descripcion: ${item.valeDescription}\n'
                'Fecha: ${item.valeDate != null ? DateFormat('dd-MM-yyyy').format(item.valeDate) : 'Sin fecha'}\n'
                'Monto: ${item.valeAmount.toStringAsFixed(2)}';
          } else if (type == TabType.Cupones) {
            title = 'Cupón No. : ${item.cuponesNumber ?? 'Sin número'}';
            subtitle = 'Monto: ${item.cuponesAmount.toStringAsFixed(2)}\n'
                'Fecha: ${item.cuponesDate != null ? DateFormat('dd-MM-yyyy').format(item.cuponesDate) : 'Sin fecha'}';
          } else if (type == TabType.Depositos) {
            title = 'Depósito No. : ${item.depositNumber ?? 'Sin número'}';
            subtitle =
                'Monto: ${item.depositAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Fecha: ${item.depositDate != null ? DateFormat('dd-MM-yyyy').format(item.depositDate) : 'Sin fecha'}\n'
                'Banco: ${item.bankId.bankName}';
          } else if (type == TabType.Creditos) {
            title = 'Crédito No. : ${item.creditNumber ?? 'Sin número'}';
            subtitle =
                'Fecha: ${item.creditDate != null ? DateFormat('dd-MM-yyyy').format(item.creditDate) : 'Sin fecha'}\n'
                'Cliente: ${item.clientId.clientName}\n'
                'Cantidad Super: ${item.superAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Cantidad Regular: ${item.regularAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Cantidad Diésel: ${item.dieselAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Monto: ${item.creditAmount?.toStringAsFixed(2) ?? '0.00'}';
          } else if (type == TabType.Cheques) {
            title = 'Cheque No. : ${item.checkNumber ?? 'Sin número'}';
            subtitle =
                'Fecha: ${item.checkDate != null ? DateFormat('dd-MM-yyyy').format(item.checkDate) : 'Sin fecha'}\n'
                'Cliente: ${item.clientId.clientName}\n'
                'Banco: ${item.bankId.bankName}\n'
                'Monto: ${item.checkValue?.toStringAsFixed(2) ?? '0.00'}';
          }

          return Dismissible(
            key: Key(item.toString()), // Usar un ID único de cada item
            direction: DismissDirection
                .endToStart, // Solo permitir deslizar hacia la izquierda
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              final bool confirmDelete = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('Confirmación'),
                      content: const Text(
                          '¿Estás seguro de que deseas eliminar este ítem?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Get.back(result: false);
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(result: true);
                          },
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (confirmDelete) {
                try {
                  bool success = false;

                  if (type == TabType.Vouchers && voucherController != null) {
                    success =
                        await voucherController!.deleteVoucher(item.voucherId);
                  } else if (type == TabType.Cheques) {
                    success = await bankCheckController
                        .deleteBankCheck(item.bankCheckId);
                  } else if (type == TabType.Gastos) {
                    success = await billsController.deleteBill(item.billId);
                  } else if (type == TabType.Cupones &&
                      couponsController != null) {
                    success =
                        await couponsController!.deleteCoupon(item.couponId);
                  } else if (type == TabType.Creditos &&
                      creditsController != null) {
                    success =
                        await creditsController!.deleteCredit(item.creditId);
                  } else if (type == TabType.Depositos &&
                      depositsController != null) {
                    success =
                        await depositsController!.deleteDeposit(item.depositId);
                  } else if (type == TabType.Vales) {
                    success = await valesController.deleteVale(item.valeId);
                  }
                  if (success) {
                    // Resta el valor del ítem eliminado del campo correspondiente
                    if (type == TabType.Vouchers) {
                      vouchers.value =
                          (double.parse(vouchers.value) - item.voucherAmount!)
                              .toStringAsFixed(2);
                    } else if (type == TabType.Cheques) {
                      cheques.value =
                          (double.parse(cheques.value) - item.checkValue!)
                              .toStringAsFixed(2);
                    } else if (type == TabType.Gastos) {
                      gastos.value =
                          (double.parse(gastos.value) - item.billAmount!)
                              .toStringAsFixed(2);
                    } else if (type == TabType.Cupones) {
                      cupones.value =
                          (double.parse(cupones.value) - item.cuponesAmount!)
                              .toStringAsFixed(2);
                    } else if (type == TabType.Creditos) {
                      creditos.value =
                          (double.parse(creditos.value) - item.creditAmount!)
                              .toStringAsFixed(2);
                    } else if (type == TabType.Depositos) {
                      depositos.value =
                          (double.parse(depositos.value) - item.depositAmount!)
                              .toStringAsFixed(2);
                    } else if (type == TabType.Vales) {
                      vales.value =
                          (double.parse(vales.value) - item.valeAmount!)
                              .toStringAsFixed(2);
                    }

                    // Recalcula los totales
                    calculateTotalSales();

                    // Elimina el ítem de la lista y refresca
                    items.removeAt(index);
                    if (type == TabType.Vouchers) {
                      voucherController?.voucherListResponse.refresh();
                    } else if (type == TabType.Cheques) {
                      bankCheckController.bankCheckListResponse.refresh();
                    } else if (type == TabType.Gastos) {
                      billsController.billsListResponse.refresh();
                    } else if (type == TabType.Cupones) {
                      couponsController!.couponsListResponse.refresh();
                    } else if (type == TabType.Creditos) {
                      creditsController!.creditsListResponse.refresh();
                    } else if (type == TabType.Depositos) {
                      depositsController!.depositsitsListResponse.refresh();
                    } else if (type == TabType.Vales) {
                      valesController.valesListResponse.refresh();
                    }

                    //Get.snackbar('Éxito', 'Ítem eliminado correctamente');
                    return true;
                  } else {
                    Get.snackbar(
                      'Error',
                      'No se pudo eliminar el ítem.',
                      backgroundColor: Colors.red[600],
                      colorText: Colors.white,
                      margin: EdgeInsets.all(10),
                      borderRadius: 20,
                      duration: Duration(seconds: 3),
                      isDismissible: true,
                      dismissDirection: DismissDirection.horizontal,
                      forwardAnimationCurve: Curves.easeOutBack,
                    );
                    return false;
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Hubo un error al eliminar: $e',
                    backgroundColor: Colors.red[600],
                    colorText: Colors.white,
                    margin: EdgeInsets.all(10),
                    borderRadius: 20,
                    duration: Duration(seconds: 3),
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                    forwardAnimationCurve: Curves.easeOutBack,
                  );
                  return false;
                }
              }
              return false;
            },

            child: SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.99, // El 99% del ancho de la pantalla
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0), // Solo margen vertical
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text(subtitle),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildSpecificFields(String label, RxString controller) {
    if (label == 'Cheques') {
      return Column(
        children: [
          buildDropdownField(
            'Clientes',
            clientsController.clientsList
                .map((Client client) => client.clientName)
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedClientChecks = value;
              });
            },
          ),
          buildDropdownField(
            'Banco',
            bankController.bankList.map((Bank bank) => bank.bankName).toList(),
            onChanged: (value) {
              setState(() {
                selectedBankCheck = value;
              });
            },
          ),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: checkDateController),
          buildTextField('No. Cheque',
              inputType: TextInputType.number,
              controller: checkNumberController),
          buildTextField(
            'Valor',
            inputType: TextInputType.numberWithOptions(decimal: true),
            controller: checkValueController,
          ),
        ],
      );
    } else if (label == 'Vales') {
      return Column(
        children: [
          buildTextField('Número de Vale',
              inputType: TextInputType.number,
              controller: valeNumberController),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: valeDateController),
          buildTextField('Valor',
              inputType: TextInputType.numberWithOptions(decimal: true),
              controller: valeAmountController),
          buildTextField('Descripción', controller: valeDescriptionController),
        ],
      );
    } else if (label == 'Cupones') {
      return Column(
        children: [
          buildTextField('No. Cupón',
              inputType: TextInputType.number,
              controller: couponsNumberController),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: couponsDateController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Valor',
                border: const OutlineInputBorder(),
              ),
              value: '10', // Valor inicial seleccionado
              items: ['10', '20', '50', '100', '250', '500', '1000']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  couponsAmountController.text = newValue ?? '';
                });
              },
            ),
          ),
        ],
      );
    } else if (label == 'Vouchers') {
      return Column(
        children: [
          buildDropdownField(
            'POS',
            posController.posList.map((Pos pos) => pos.posName).toList(),
            onChanged: (value) {
              setState(() {
                selectedPOS = value;
              });
            },
          ),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: voucherDateController),
          buildTextField('Valor',
              inputType: TextInputType.numberWithOptions(decimal: true),
              controller: voucherAmountController),
          buildTextField('No. Autorización',
              inputType: TextInputType.number,
              controller: authorizationCodeController),
        ],
      );
    } else if (label == 'Depositos') {
      return Column(
        children: [
          buildDropdownField(
            'Banco',
            bankController.bankList.map((Bank bank) => bank.bankName).toList(),
            onChanged: (value) {
              setState(() {
                selectedBankDeposit = value;
              });
            },
          ),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: depositDateController),
          buildTextField('No. Boleta',
              inputType: TextInputType.number,
              controller: depositNumberController),
          buildTextField('Valor',
              inputType: TextInputType.numberWithOptions(decimal: true),
              controller: depositAmountController),
        ],
      );
    } else if (label == 'Creditos') {
      return Column(
        children: [
          buildDropdownField(
            'Clientes',
            clientsController.clientsList
                .map((Client client) => client.clientName)
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedClientCredits = value;
              });
            },
          ),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: creditDateController),
          buildTextField('No. Comprobante',
              inputType: TextInputType.number,
              controller: creditNumberController),
          buildTextField('Galones Super',
              inputType: TextInputType.numberWithOptions(decimal: true),
              controller: superAmountController),
          buildTextField('Galones Regular',
              inputType: TextInputType.numberWithOptions(decimal: true),
              controller: regularAmountController),
          buildTextField('Galones Diesel',
              inputType: TextInputType.numberWithOptions(decimal: true),
              controller: dieselAmountController),
          buildTextField('Valor',
              inputType: TextInputType.numberWithOptions(decimal: true),
              controller: creditAmountController),
        ],
      );
    } else if (label == 'Gastos') {
      return Column(
        children: [
          buildTextField('Número Correlativo',
              inputType: TextInputType.number,
              controller: billNumberController),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: billDateController),
          buildTextField('Valor',
              inputType: TextInputType.numberWithOptions(decimal: true),
              controller: billAmountController),
          buildTextField('Descripción', controller: billDescriptionController),
        ],
      );
    }
    return Container();
  }

  Widget buildTextField(String label,
      {TextInputType inputType = TextInputType.text,
      TextEditingController? controller,
      bool isDateField = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: inputType,
        inputFormatters:
            inputType == const TextInputType.numberWithOptions(decimal: true)
                ? [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d*\.?\d{0,2}')), // Permite solo un punto y hasta 2 decimales
                  ]
                : [],
        readOnly: isDateField,
        onTap: isDateField
            ? () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                  controller?.text = formattedDate;
                }
              }
            : null,
      ),
    );
  }

  Widget buildNumberTextField(String label,
      {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(
              r'^\d*\.?\d{0,2}')), // Permite solo un punto y hasta 2 decimales
        ],
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> options,
      {Function(String?)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
        isDense: false,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 24,
        dropdownColor: Colors.white,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                option,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<bool> createBankCheck() async {
    try {
      if (selectedBankCheck == null || selectedClientChecks == null) {
        Get.snackbar(
          'Error',
          'Por favor, seleccione un banco y un cliente',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final checkNumber = int.tryParse(checkNumberController.text);
      final checkValue =
          num.tryParse(checkValueController.text.replaceAll(',', ''));
      final checkDate =
          DateFormat('dd-MM-yyyy').parse(checkDateController.text);

      if (checkNumber == null || checkValue == null) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese valores válidos',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final bankId = bankController.bankList
          .firstWhere((bank) => bank.bankName == selectedBankCheck)
          .bankId;
      final clientId = clientsController.clientsList
          .firstWhere((client) => client.clientName == selectedClientChecks)
          .clientId;

      final success = await bankCheckController.createBankCheck(
        checkNumber: checkNumber,
        checkValue: checkValue,
        checkDate: checkDate,
        bankId: bankId,
        clientId: clientId,
      );

      if (success) {
        cheques.value =
            (num.parse(cheques.value) + checkValue).toStringAsFixed(2);
        calculateTotalSales();
        saveState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Hubo un error al crear cheque: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }

  Future<bool> createBill() async {
    try {
      final billDescription = billDescriptionController.text;
      final billNumber = billNumberController.text;
      final billAmount =
          num.tryParse(billAmountController.text.replaceAll(',', ''));
      final billDate = DateFormat('dd-MM-yyyy').parse(billDateController.text);

      if (billAmount == null) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese valores válidos',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }
      if (billDescription.isEmpty || billNumber.isEmpty) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese una descripción para el gasto',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final success = await billsController.createBill(
          billNumber: billNumber,
          billDate: billDate,
          billAmount: billAmount,
          billDescription: billDescription);

      if (success) {
        gastos.value =
            (num.parse(gastos.value) + billAmount).toStringAsFixed(2);
        calculateTotalSales();
        saveState();
        return true;
      } else {
        // Si no fue exitoso, no actualizamos los valores y permanecemos en el DataTab
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Hubo un error al crear el gasto: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }

  Future<bool> createVale() async {
    try {
      final valeDescription = valeDescriptionController.text;
      final valeNumber = valeNumberController.text;
      final valeAmount =
          num.tryParse(valeAmountController.text.replaceAll(',', ''));
      final valeDate = DateFormat('dd-MM-yyyy').parse(valeDateController.text);

      if (valeDescription.isEmpty) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese una descripción para el vale',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }
      if (valeAmount == null || valeNumber.isEmpty) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese valores válidos',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final success = await valesController.createVale(
          valeNumber: valeNumber,
          valeAmount: valeAmount,
          valeDate: valeDate,
          valeDescription: valeDescription);

      if (success) {
        vales.value = (num.parse(vales.value) + valeAmount).toStringAsFixed(2);
        calculateTotalSales();
        saveState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Hubo un error al crear el vale: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }

  Future<bool> createCoupon() async {
    try {
      final cuponesNumber = couponsNumberController.text;
      final cuponesAmount =
          num.tryParse(couponsAmountController.text.replaceAll(',', ''));
      final cuponesDate =
          DateFormat('dd-MM-yyyy').parse(couponsDateController.text);

      if (cuponesAmount == null || cuponesNumber.isEmpty) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese todos los datos requeridos',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final success = await couponsController!.createCoupons(
        cuponesNumber: cuponesNumber,
        cuponesDate: cuponesDate,
        cuponesAmount: cuponesAmount,
      );

      if (success) {
        cupones.value =
            (num.parse(cupones.value) + cuponesAmount).toStringAsFixed(2);
        calculateTotalSales();
        saveState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Hubo un error al crear el cupón: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }

  Future<bool> createVoucher() async {
    try {
      if (selectedPOS == null || selectedPOS!.isEmpty) {
        Get.snackbar(
          'Error',
          'Por favor, seleccione un POS',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final authorizationCode = authorizationCodeController.text;
      final voucherAmount =
          num.tryParse(voucherAmountController.text.replaceAll(',', ''));
      final voucherDate =
          DateFormat('dd-MM-yyyy').parse(voucherDateController.text);

      if (voucherAmount == null) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese un monto válido',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final pos = posController.posList.firstWhere(
        (pos) => pos.posName == selectedPOS,
        orElse: () => Pos(posName: '', posId: ''),
      );

      final posId = pos.posId.isNotEmpty
          ? pos.posId
          : throw Exception('ID de POS no válida');

      final success = await voucherController!.createVoucher(
        authorizationCode: authorizationCode,
        posId: posId,
        voucherAmount: voucherAmount,
        voucherDate: voucherDate,
      );

      if (success) {
        vouchers.value =
            (num.parse(vouchers.value) + voucherAmount).toStringAsFixed(2);
        calculateTotalSales();
        saveState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Hubo un error al crear el voucher: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }

  Future<bool> createDeposits() async {
    try {
      if (selectedBankDeposit == null) {
        Get.snackbar(
          'Error',
          'Por favor, seleccione un banco',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final depositNumber = int.parse(depositNumberController.text);
      final depositAmount =
          num.tryParse(depositAmountController.text.replaceAll(',', ''));
      final depositDate =
          DateFormat('dd-MM-yyyy').parse(depositDateController.text);

      if (depositAmount == null) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese un monto válido',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final bankId = bankController.bankList
          .firstWhere((bank) => bank.bankName == selectedBankDeposit)
          .bankId;

      final success = await depositsController!.createDeposits(
        depositNumber: depositNumber,
        depositAmount: depositAmount,
        depositDate: depositDate,
        bankId: bankId,
      );

      if (success) {
        depositos.value =
            (num.parse(depositos.value) + depositAmount).toStringAsFixed(2);
        calculateTotalSales();
        saveState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Hubo un error al crear el depósito: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }

  Future<bool> createCredit() async {
    try {
      if (selectedClientCredits == null) {
        Get.snackbar(
          'Error',
          'Por favor, seleccione un cliente',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final creditNumber = int.parse(creditNumberController.text);
      final creditAmount =
          num.tryParse(creditAmountController.text.replaceAll(',', ''));
      final creditDate =
          DateFormat('dd-MM-yyyy').parse(creditDateController.text);
      final regularAmount =
          num.tryParse(regularAmountController.text.replaceAll(',', ''));
      final superAmount =
          num.tryParse(superAmountController.text.replaceAll(',', ''));
      final dieselAmount =
          num.tryParse(dieselAmountController.text.replaceAll(',', ''));

      if (creditAmount == null ||
          regularAmount == null ||
          superAmount == null ||
          dieselAmount == null) {
        Get.snackbar(
          'Error',
          'Por favor, ingrese un monto válido',
          backgroundColor: Colors.deepOrange[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return false;
      }

      final clientId = clientsController.clientsList
          .firstWhere((client) => client.clientName == selectedClientCredits)
          .clientId;

      final success = await creditsController!.createCredit(
        creditNumber: creditNumber,
        creditAmount: creditAmount,
        creditDate: creditDate,
        regularAmount: regularAmount,
        superAmount: superAmount,
        dieselAmount: dieselAmount,
        clientId: clientId,
      );

      if (success) {
        creditos.value =
            (num.parse(creditos.value) + creditAmount).toStringAsFixed(2);
        calculateTotalSales();
        saveState();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Hubo un error al crear crédito: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }

  void calculateTotalSales() {
    final reader = dispenserController.lastGeneralDispenserReader.value;
    final fuels = fuelController.fuels;

    if (reader != null && fuels.isNotEmpty) {
      final regular = fuels.firstWhere((fuel) => fuel.fuelName == 'regular');
      final superFuel = fuels.firstWhere((fuel) => fuel.fuelName == 'super');
      final diesel = fuels.firstWhere((fuel) => fuel.fuelName == 'diesel');

      totalSalesRegular.value = reader.totalMoneyRegular.toDouble();
      totalSalesSuper.value = reader.totalMoneySuper.toDouble();
      totalSalesDiesel.value = reader.totalMoneyDiesel.toDouble();

      totalPayments.value = double.parse(gastos.value) +
          double.parse(vales.value) +
          double.parse(cupones.value) +
          double.parse(vouchers.value) +
          double.parse(depositos.value) +
          double.parse(creditos.value) +
          double.parse(cheques.value);

      totalSaldo.value = totalPayments.value - totalSales;
    }
  }

  Future<void> _updateSalesControl() async {
    final reader = dispenserController.lastGeneralDispenserReader.value;
    final fuels = fuelController.fuels;

    if (reader != null && fuels.isNotEmpty) {
      final regular = fuels.firstWhere((fuel) => fuel.fuelName == 'regular');
      final superFuel = fuels.firstWhere((fuel) => fuel.fuelName == 'super');
      final diesel = fuels.firstWhere((fuel) => fuel.fuelName == 'diesel');

      final requestBody = {
        'regularPrice': regular.salePrice,
        'superPrice': superFuel.salePrice,
        'dieselPrice': diesel.salePrice,
        'totalGallonRegular': reader.totalMechanicRegular,
        'totalGallonSuper': reader.totalMechanicSuper,
        'totalGallonDiesel': reader.totalMechanicDiesel,
        'total': totalSales,
        'balance': totalSaldo.value,
        'totalAbonosBalance': _calculateTotalPayments(),
        'abonos': _calculateTotalPayments(),
      };

      await salesControlController.updateSalesControl(requestBody);
    }
  }

  double _calculateTotalPayments() {
    return double.parse(gastos.value) +
        double.parse(vales.value) +
        double.parse(cupones.value) +
        double.parse(vouchers.value) +
        double.parse(depositos.value) +
        double.parse(creditos.value) +
        double.parse(cheques.value);
  }

  void updatePayments() {
    gastos.value = '0.00';
    vales.value = '0.00';
    cupones.value = '0.00';
    vouchers.value = '0.00';
    depositos.value = '0.00';
    creditos.value = '0.00';
    cheques.value = '0.00';
  }

  void clearFields() {
    billNumberController.clear();
    billDateController.clear();
    billAmountController.clear();
    billDescriptionController.clear();

    valeNumberController.clear();
    valeDescriptionController.clear();
    valeAmountController.clear();
    valeDateController.clear();

    couponsNumberController.clear();
    couponsAmountController.clear();
    couponsDateController.clear();

    voucherAmountController.clear();
    authorizationCodeController.clear();
    voucherDateController.clear();

    depositNumberController.clear();
    depositAmountController.clear();
    depositDateController.clear();

    creditNumberController.clear();
    creditAmountController.clear();
    creditDateController.clear();
    regularAmountController.clear();
    superAmountController.clear();
    dieselAmountController.clear();

    checkNumberController.clear();
    checkValueController.clear();
    checkDateController.clear();
  }

  void resetControllers() {
    totalSalesRegular.value = 0.00;
    totalSalesSuper.value = 0.00;
    totalSalesDiesel.value = 0.00;

    totalPayments.value = 0.00;
    totalSaldo.value = 0.00;

    gastos.value = '0.00';
    vales.value = '0.00';
    cupones.value = '0.00';
    vouchers.value = '0.00';
    depositos.value = '0.00';
    creditos.value = '0.00';
    cheques.value = '0.00';

    dispenserController = Get.put(DispenserController());
    fuelController = Get.put(FuelController());
    posController = Get.put(PosController());
    bankController = Get.put(BankController());
    clientsController = Get.put(ClientsController());
    salesControlController = Get.put(SalesControlController());
    bankCheckController = Get.put(BankCheckController());
    billsController = Get.put(BillsController());
    valesController = Get.put(ValesController());
    couponsController = Get.put(CouponsController());
    voucherController = Get.put(VoucherController());
    depositsController = Get.put(DepositsController());
    creditsController = Get.put(CreditsController());
  }

  void resetScreenState() {
    if (!mounted) return;

    // Reinicia los controladores en lugar de eliminarlos y volverlos a crear
    Get.find<DispenserController>().onInit();
    Get.find<SalesControlController>().onInit();
    Get.find<FuelController>().onInit();
    Get.find<PosController>().onInit();
    Get.find<BankController>().onInit();
    Get.find<ClientsController>().onInit();
    Get.find<BankCheckController>().onInit();
    Get.find<BillsController>().onInit();
    Get.find<ValesController>().onInit();
    Get.find<CouponsController>().onInit();
    Get.find<VoucherController>().onInit();
    Get.find<DepositsController>().onInit();
    Get.find<CreditsController>().onInit();

    // Actualiza las referencias locales
    dispenserController = Get.find<DispenserController>();
    fuelController = Get.find<FuelController>();
    posController = Get.find<PosController>();
    bankController = Get.find<BankController>();
    clientsController = Get.find<ClientsController>();
    salesControlController = Get.find<SalesControlController>();
    bankCheckController = Get.find<BankCheckController>();
    billsController = Get.find<BillsController>();
    valesController = Get.find<ValesController>();
    couponsController = Get.find<CouponsController>();
    voucherController = Get.find<VoucherController>();
    depositsController = Get.find<DepositsController>();
    creditsController = Get.find<CreditsController>();

    if (mounted) {
      setState(() {});
    }
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
    try {
      final prefs = await SharedPreferences.getInstance();
      totalSalesRegular.value = prefs.getDouble('totalSalesRegular') ?? 0.0;
      totalSalesSuper.value = prefs.getDouble('totalSalesSuper') ?? 0.0;
      totalSalesDiesel.value = prefs.getDouble('totalSalesDiesel') ?? 0.0;
      totalPayments.value = prefs.getDouble('totalPayments') ?? 0.0;
      totalSaldo.value = prefs.getDouble('totalSaldo') ?? 0.0;

      gastos.value = prefs.getString('gastos') ?? '0.00';
      vales.value = prefs.getString('vales') ?? '0.00';
      cupones.value = prefs.getString('cupones') ?? '0.00';
      vouchers.value = prefs.getString('vouchers') ?? '0.00';
      depositos.value = prefs.getString('depositos') ?? '0.00';
      creditos.value = prefs.getString('creditos') ?? '0.00';
      cheques.value = prefs.getString('cheques') ?? '0.00';
    } catch (e) {
      return;
    }
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
    loadState();
  }

  @override
  void dispose() {
    // dispenserController.dispose();
    // fuelController.dispose();
    // posController.dispose();
    // bankController.dispose();
    // clientsController.dispose();
    // billsController.dispose();
    // valesController.dispose();
    // couponsController?.dispose();
    // voucherController?.dispose();
    // depositsController?.dispose();
    // creditsController?.dispose();
    super.dispose();
  }
}
