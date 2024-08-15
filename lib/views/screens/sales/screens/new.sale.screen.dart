import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hand_held_shell/controllers/accounting/coupons/coupons.controller.dart';
import 'package:hand_held_shell/controllers/accounting/credis/credits.crontroller.dart';
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
import 'package:hand_held_shell/shared/helpers/Thousands.formatter.dart';
import 'package:hand_held_shell/shared/helpers/show.confirm.dialog.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/sales/widgets/side.menu.sale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
                    ? () async {
                        showConfirmationDialog(
                          title: 'Confirmación',
                          message: '¿Deseas guardar los cambios?',
                          confirmText: 'Sí',
                          cancelText: 'No',
                          onConfirm: () async {
                            Get.back(); // Cierra el diálogo de confirmación

                            // Muestra el spinner
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
                              // Llama al método _updateSalesControl
                              await _updateSalesControl();

                              // Cierra el spinner
                              Navigator.pop(context);

                              // Limpia todos los campos
                              clearFields();

                              // Limpia el estado almacenado
                              await clearState();

                              // Reinicia el Summary Card para mostrar el mensaje de no hay información
                              dispenserController.isSummaryCardEnabled.value =
                                  true;
                              dispenserController
                                  .lastGeneralDispenserReader.value = null;

                              // Restablece la pantalla como un "hot restart"
                              resetScreenState();

                              // Restablece las pantallas NewRegisterDispenserScreen y RegisterDispenserPage
                              final dispenserControllerReset =
                                  Get.find<DispenserController>();
                              await dispenserControllerReset
                                  .clearSharedPreferences();
                              dispenserController.resetState();

                              // Mostrar mensaje de éxito
                              Get.snackbar('Éxito',
                                  'Datos guardados y pantallas actualizadas correctamente');
                            } catch (e) {
                              // Cierra el spinner en caso de error
                              Navigator.pop(context);

                              Get.snackbar('Error',
                                  'Hubo un error al guardar los datos: $e');
                            }
                          },
                          onCancel: () {
                            // Cierra el diálogo de confirmación
                            Get.back();
                          },
                        );
                      }
                    : null,
                child: const Text('Guardar'),
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.delete),
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
            title: 'Confirmación',
            message: '¿Crear nuevo DLP?',
            onConfirm: () async {
              Get.back(); // Cierra el diálogo antes de ejecutar las acciones
              await dispenserController.fetchLastGeneralDispenserReaderData();
              await fuelController.fetchFuels();
              await salesControlController.createNewSalesControl();
              calculateTotalSales();
              updatePayments();
              saveState();
            },
            confirmText: 'Crear',
            cancelText: 'Cancelar',
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
            final diesel = fuels.firstWhere((fuel) => fuel.fuelName == 'diesel',
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
                              // Verificar el label y ejecutar la acción correspondiente
                              if (label == 'Gastos') {
                                await createBill();
                                await billsController
                                    .fetchBillsBySalesControl();
                              } else if (label == 'Vouchers') {
                                await createVoucher();
                                await voucherController
                                    ?.fetchVoucherBySalesControl();
                              } else if (label == 'Vales') {
                                await createVale();
                                await valesController
                                    .fetchValesBySalesControl();
                              } else if (label == "Cupones") {
                                await createCoupon();
                                await couponsController
                                    ?.fetchCouponsBySalesControl();
                              } else if (label == "Depositos") {
                                await createDeposits();
                                await depositsController
                                    ?.fetchDepositsBySalesControl();
                              } else if (label == "Creditos") {
                                await createCredit();
                                await creditsController
                                    ?.fetchCreditsBySalesControl();
                              } else if (label == "Cheques") {
                                await createBankCheck();
                                await bankCheckController
                                    .fetchBankCheckBySalesControl();
                              }

                              Navigator.pop(context); // Cierra el spinner

                              clearFields();

                              Navigator.pop(context); // Cierra el BottomSheet
                            } catch (e) {
                              Navigator.pop(
                                  context); // Cierra el spinner en caso de error
                              Get.snackbar(
                                  'Error', 'Hubo un error al guardar: $e');
                            }
                          },
                          onCancel: () {
                            Navigator.pop(
                                context); // Cierra el diálogo de confirmación
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
          //!gastos
          if (type == TabType.Gastos) {
            title = 'Gasto No. : ${item.billNumber}';
            subtitle =
                'Monto: ${item.billAmount.toStringAsFixed(2)}\nFecha: ${DateFormat('dd-MM-yyyy').format(item.billDate)}\nDescripción: ${item.billDescription}';
          }

          //!voucher
          else if (type == TabType.Vouchers) {
            if (item.authorizationCode == null ||
                item.voucherAmount == null ||
                item.voucherDate == null ||
                item.posId == null ||
                item.posId.posName == null) {
              return ListTile(
                title: Text('Datos incompletos'),
                subtitle: Text('No se puede mostrar este voucher'),
              );
            }
            title = 'Voucher No. : ${item.authorizationCode ?? 'Sin código'}';
            subtitle =
                'Monto: ${item.voucherAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Fecha: ${item.voucherDate != null ? DateFormat('dd-MM-yyyy').format(item.voucherDate) : 'Sin fecha'}\n'
                'POS: ${item.posId.posName}';
          }
          //!vales
          else if (type == TabType.Vales) {
            if (item.valeNumber == null ||
                item.valeAmount == null ||
                item.valeDescription == null ||
                item.valeDate == null) {
              return ListTile(
                title: Text('Datos incompletos'),
                subtitle: Text('No se puede mostrar este vale'),
              );
            }
            title = 'Vale No. : ${item.valeNumber ?? 'Sin número'}';
            subtitle = 'Descripcion: ${item.valeDescription}\n'
                'Fecha: ${item.valeDate != null ? DateFormat('dd-MM-yyyy').format(item.valeDate) : 'Sin fecha'}\n'
                'Monto: ${item.valeAmount.toStringAsFixed(2)}';
          }

          //!cupones
          else if (type == TabType.Cupones) {
            if (item.cuponesNumber == null ||
                item.cuponesAmount == null ||
                item.cuponesDate == null) {
              return ListTile(
                title: Text('Datos incompletos'),
                subtitle: Text('No se puede mostrar este cupón'),
              );
            }
            title = 'Cupón No. : ${item.cuponesNumber ?? 'Sin número'}';
            subtitle = 'Monto: ${item.cuponesAmount.toStringAsFixed(2)}\n'
                'Fecha: ${item.cuponesDate != null ? DateFormat('dd-MM-yyyy').format(item.cuponesDate) : 'Sin fecha'}';
          }
          //!Depositos
          else if (type == TabType.Depositos) {
            if (item.depositNumber == null ||
                item.depositAmount == null ||
                item.depositDate == null ||
                item.bankId == null ||
                item.bankId.bankName == null) {
              return ListTile(
                title: Text('Datos incompletos'),
                subtitle: Text('No se puede mostrar este depósito'),
              );
            }
            title = 'Depósito No. : ${item.depositNumber ?? 'Sin Nnúmero'}';
            subtitle =
                'Monto: ${item.depositAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Fecha: ${item.depositDate != null ? DateFormat('dd-MM-yyyy').format(item.depositDate) : 'Sin fecha'}\n'
                'Banco: ${item.bankId.bankName}';
          }

          //!Creditos
          else if (type == TabType.Creditos) {
            if (item.creditNumber == null ||
                item.creditAmount == null ||
                item.creditDate == null ||
                item.regularAmount == null ||
                item.superAmount == null ||
                item.dieselAmount == null ||
                item.clientId == null ||
                item.clientId.clientName == null) {
              return ListTile(
                title: Text('Datos incompletos'),
                subtitle: Text('No se puede mostrar este crédito'),
              );
            }
            title = 'Crédito No. : ${item.creditNumber ?? 'Sin Nnúmero'}';
            subtitle =
                'Fecha: ${item.creditDate != null ? DateFormat('dd-MM-yyyy').format(item.creditDate) : 'Sin fecha'}\n'
                'Cliente: ${item.clientId.clientName}\n'
                'Cantidad Super: ${item.superAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Cantidad Regular: ${item.regularAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Cantidad Diésel: ${item.dieselAmount?.toStringAsFixed(2) ?? '0.00'}\n'
                'Monto: ${item.creditAmount?.toStringAsFixed(2) ?? '0.00'}';
          }

          //! Cheques
          else if (type == TabType.Cheques) {
            if (item.checkNumber == null ||
                item.checkValue == null ||
                item.checkDate == null ||
                item.bankId == null ||
                item.bankId.bankName == null ||
                item.clientId == null ||
                item.clientId.clientName == null) {
              return ListTile(
                title: Text('Datos incompletos'),
                subtitle: Text('No se puede mostrar este cheque'),
              );
            }

            title = 'Cheque No. : ${item.checkNumber ?? 'Sin Nnúmero'}';
            subtitle =
                'Fecha: ${item.checkDate != null ? DateFormat('dd-MM-yyyy').format(item.checkDate) : 'Sin fecha'}\n'
                'Cliente: ${item.clientId.clientName}\n'
                'Banco: ${item.bankId.bankName}\n'
                'Monto: ${item.checkValue?.toStringAsFixed(2) ?? '0.00'}';
          }

          return ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
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
            'Banco',
            bankController.bankList.map((Bank bank) => bank.bankName).toList(),
            onChanged: (value) {
              setState(() {
                selectedBankCheck = value;
              });
            },
          ),
          buildTextField('No. Cheque', controller: checkNumberController),
          buildNumberTextField('Valor', controller: checkValueController),
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
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: checkDateController),
        ],
      );
    } else if (label == 'Vales') {
      return Column(
        children: [
          buildTextField('Número de Vale', controller: valeNumberController),
          buildTextField('Descripción', controller: valeDescriptionController),
          buildNumberTextField('Valor', controller: valeAmountController),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: valeDateController),
        ],
      );
    } else if (label == 'Cupones') {
      return Column(
        children: [
          buildTextField('No. Cupón', controller: couponsNumberController),
          buildNumberTextField('Valor', controller: couponsAmountController),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: couponsDateController),
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
          buildNumberTextField('Valor', controller: voucherAmountController),
          buildTextField('No. Autorización',
              controller: authorizationCodeController),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: voucherDateController),
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
          buildTextField('No. Boleta', controller: depositNumberController),
          buildNumberTextField('Valor', controller: depositAmountController),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: depositDateController),
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
          buildTextField('No. Comprobante', controller: creditNumberController),
          buildTextField('Galones Super', controller: superAmountController),
          buildTextField('Galones Regular',
              controller: regularAmountController),
          buildTextField('Galones Diesel', controller: dieselAmountController),
          buildNumberTextField('Valor', controller: creditAmountController),
        ],
      );
    } else if (label == 'Gastos') {
      return Column(
        children: [
          buildTextField('Número Correlativo',
              controller: billNumberController),
          buildTextField('Fecha',
              inputType: TextInputType.datetime,
              isDateField: true,
              controller: billDateController),
          buildTextField('Monto', controller: billAmountController),
          buildTextField('Descripción', controller: billDescriptionController),
        ],
      );
    }
    // Otros campos específicos según el tipo de label.
    return Container(); // Fallback si no hay un tipo específico
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
                  // Formatea la fecha seleccionada como dd-MM-yyyy
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
          ThousandsFormatter(),
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

  Future<void> createBankCheck() async {
    if (selectedBankCheck == null || selectedClientChecks == null) {
      Get.snackbar('Error', 'Por favor, seleccione un banco y un cliente');
      return;
    }

    final checkNumber = int.tryParse(checkNumberController.text);
    final checkValue =
        num.tryParse(checkValueController.text.replaceAll(',', ''));
    final checkDate = DateFormat('dd-MM-yyyy').parse(checkDateController.text);

    if (checkNumber == null || checkValue == null) {
      Get.snackbar('Error', 'Por favor, ingrese valores válidos');
      return;
    }

    final bankId = bankController.bankList
        .firstWhere((bank) => bank.bankName == selectedBankCheck)
        .bankId;
    final clientId = clientsController.clientsList
        .firstWhere((client) => client.clientName == selectedClientChecks)
        .clientId;

    await bankCheckController.createBankCheck(
      checkNumber: checkNumber,
      checkValue: checkValue,
      checkDate: checkDate,
      bankId: bankId,
      clientId: clientId,
    );

    cheques.value = (num.parse(cheques.value) + checkValue).toStringAsFixed(2);
    calculateTotalSales();
    saveState();
  }

  Future<void> createBill() async {
    final billDescription = billDescriptionController.text;

    final billNumber = billNumberController.text;
    final billAmount =
        num.tryParse(billAmountController.text.replaceAll(',', ''));
    final billDate = DateFormat('dd-MM-yyyy').parse(billDateController.text);

    if (billAmount == null) {
      Get.snackbar('Error', 'Por favor, ingrese valores válidos');
      return;
    }
    if (billDescription.isEmpty || billNumber.isEmpty) {
      Get.snackbar('Error', 'Por favor, ingrese una descripción para el gasto');
      return;
    }

    await billsController.createBill(
        billNumber: billNumber,
        billDate: billDate,
        billAmount: billAmount,
        billDescription: billDescription);

    gastos.value = (num.parse(gastos.value) + billAmount).toStringAsFixed(2);
    calculateTotalSales();
    saveState();
  }

  Future<void> createVale() async {
    final valeDescription = valeDescriptionController.text;
    final valeNumber = valeNumberController.text;
    final valeAmount =
        num.tryParse(valeAmountController.text.replaceAll(',', ''));
    final valeDate = DateFormat('dd-MM-yyyy').parse(valeDateController
        .text); // Cambia el formato al que esperas en el TextField

    if (valeDescription.isEmpty) {
      Get.snackbar('Error', 'Por favor, ingrese una descripción para el vale');
      return;
    }
    if (valeAmount == null || valeNumber.isEmpty) {
      Get.snackbar('Error', 'Por favor, ingrese valores válidos');
      return;
    }

    // Aquí, estamos enviando `valeDate` como un objeto `DateTime`, que es lo correcto si la base de datos espera un DateTime.
    await valesController.createVale(
        valeNumber: valeNumber,
        valeAmount: valeAmount,
        valeDate: valeDate,
        valeDescription: valeDescription);

    vales.value = (num.parse(vales.value) + valeAmount).toStringAsFixed(2);
    calculateTotalSales();
    saveState();
  }

  Future<void> createCoupon() async {
    final cuponesNumber = couponsNumberController.text;
    final cuponesAmount =
        num.tryParse(couponsAmountController.text.replaceAll(',', ''));
    final cuponesDate =
        DateFormat('dd-MM-yyyy').parse(couponsDateController.text);

    if (cuponesAmount == null || cuponesNumber.isEmpty) {
      return;
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

      Get.snackbar('Éxito', 'Cupón creado exitosamente');
    }
  }

  Future<void> createVoucher() async {
    try {
      if (selectedPOS == null || selectedPOS!.isEmpty) {
        Get.snackbar('Error', 'Por favor, seleccione un POS');
        return;
      }

      final authorizationCode = authorizationCodeController.text;
      final voucherAmount =
          num.tryParse(voucherAmountController.text.replaceAll(',', ''));
      final voucherDate =
          DateFormat('dd-MM-yyyy').parse(voucherDateController.text);

      if (voucherAmount == null) {
        Get.snackbar('Error', 'Por favor, ingrese un monto válido');
        return;
      }

      // Depura los valores de los posNames disponibles
      for (var pos in posController.posList) {}

      // Busca el posId correspondiente al selectedPOS
      final pos = posController.posList.firstWhere(
        (pos) => pos.posName == selectedPOS,
        orElse: () => Pos(posName: '', posId: ''),
      );

      final posId = pos.posId.isNotEmpty
          ? pos.posId
          : throw Exception('ID de POS no válida');

      // Depura el valor de posId

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

        Get.snackbar('Éxito', 'Voucher creado exitosamente');
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Hubo un error al crear el voucher: ${e.toString()}');
    }
  }

  Future<void> createDeposits() async {
    try {
      if (selectedBankDeposit == null) {
        Get.snackbar('Error', 'Por favor, seleccione un banco');
        return;
      }

      final depositNumber = int.parse(depositNumberController.text);
      final depositAmount =
          num.tryParse(depositAmountController.text.replaceAll(',', ''));
      final depositDate =
          DateFormat('dd-MM-yyyy').parse(depositDateController.text);

      if (depositAmount == null) {
        Get.snackbar('Error', 'Por favor, ingrese un monto válido');
        return;
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

        Get.snackbar('Éxito', 'Depósito creado exitosamente');
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Hubo un error al crear el depósito: ${e.toString()}');
    }
  }

  Future<void> createCredit() async {
    try {
      if (selectedClientCredits == null) {
        Get.snackbar('Error', 'Por favor, seleccione un cliente');
        return;
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
        Get.snackbar('Error', 'Por favor, ingrese un monto válido');
        return;
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

        Get.snackbar('Éxito', 'Crédito creado exitosamente');
      }
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al crear crédito: ${e.toString()}');
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
    Get.delete<DispenserController>();
    Get.delete<SalesControlController>();
    Get.delete<FuelController>();
    Get.delete<PosController>();
    Get.delete<BankController>();
    Get.delete<ClientsController>();
    Get.delete<BankCheckController>();
    Get.delete<BillsController>();
    Get.delete<ValesController>();
    Get.delete<CouponsController>();
    Get.delete<VoucherController>();
    Get.delete<DepositsController>();
    Get.delete<CreditsController>();

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

    setState(() {});
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
    dispenserController.dispose();
    fuelController.dispose();
    posController.dispose();
    bankController.dispose();
    clientsController.dispose();
    billsController.dispose();
    valesController.dispose();
    couponsController?.dispose();
    voucherController?.dispose();
    depositsController?.dispose();
    creditsController?.dispose();
    super.dispose();
  }
}
