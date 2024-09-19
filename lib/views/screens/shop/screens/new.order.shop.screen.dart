import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hand_held_shell/controllers/fuels/fuels.controller.dart';
import 'package:hand_held_shell/controllers/persons/stores/stores.controller.dart';
import 'package:hand_held_shell/controllers/persons/vehicles/vehicles.controller.dart';
import 'package:hand_held_shell/controllers/purchases/orders/purchase.order.controller.dart';
import 'package:hand_held_shell/models/models/fuel.station/fuel.model.dart';
import 'package:hand_held_shell/models/models/status/status.model.dart';
import 'package:hand_held_shell/models/models/taxes/taxes.model.dart';
import 'package:hand_held_shell/shared/helpers/show.confirm.alert.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/detail.fuel.card.dart';

import 'package:hand_held_shell/views/screens/shop/widgets/new.order/order.detail.dialog.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/order.screen.builder.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/side.menu.shop.dart';

class NewOrderShopsScreen extends StatefulWidget {
  const NewOrderShopsScreen({super.key});

  @override
  _NewOrderShopsScreenState createState() => _NewOrderShopsScreenState();
}

class _NewOrderShopsScreenState extends State<NewOrderShopsScreen> {
  final VechicleController vehicleController = Get.put(VechicleController());
  final StoresController storesController = Get.put(StoresController());
  final PurchaseOrderController purchaseOrderController =
      Get.put(PurchaseOrderController());
  final FuelController fuelController = Get.put(FuelController());

  bool isFirstCardEnabled = true;
  bool isDetailsCardEnabled = false;
  bool areFuelCardsEnabled = false;

  // Variables para mantener los valores del primer Card
  String orderDate = 'dd/mm/yyyy';
  String dispatchDate = 'dd/mm/yyyy';
  String orderNumber = '0';
  String selectedStore = 'Planta';
  String selectedStoreId = '';
  String selectedVehicle = 'Camión';
  String selectedVehicleId = '';
  String shiftTime = '00:00 am';

  // Variables para los montos y totales
  String superValue = '';
  String regularValue = '';
  String dieselValue = '';
  String subTotalValue = '0.0';
  String totalIDPValue = '0.0';
  String totalFacturaValue = '';

  // Controladores para los campos de texto
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController dispatchDateController = TextEditingController();
  final TextEditingController shiftTimeController = TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();

  // Controladores para los diálogos de Fuel
  final TextEditingController superMontoController = TextEditingController();
  final TextEditingController superIdpController = TextEditingController();
  final TextEditingController superPrecioController = TextEditingController();
  final TextEditingController superTotalController = TextEditingController();
  final TextEditingController superTotalIdpController = TextEditingController();

  final TextEditingController regularMontoController = TextEditingController();
  final TextEditingController regularIdpController = TextEditingController();
  final TextEditingController regularPrecioController = TextEditingController();
  final TextEditingController regularTotalController = TextEditingController();
  final TextEditingController regularTotalIdpController =
      TextEditingController();

  final TextEditingController dieselMontoController = TextEditingController();
  final TextEditingController dieselIdpController = TextEditingController();
  final TextEditingController dieselPrecioController = TextEditingController();
  final TextEditingController dieselTotalController = TextEditingController();
  final TextEditingController dieselTotalIdpController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    orderDateController.text = orderDate;
    dispatchDateController.text = dispatchDate;
    shiftTimeController.text = shiftTime;

    // Fetch Fuel IDs when the screen is initialized
    fuelController.fetchFuelIds();
  }

  void _calculateTotals() {
    double subTotal = double.tryParse(subTotalValue) ?? 0.0;
    double totalIDP = double.tryParse(totalIDPValue) ?? 0.0;

    totalFacturaValue = (subTotal + totalIDP).toStringAsFixed(2);
  }

  void _showFuelDialog(String fuelType) {
    // Código para mostrar el diálogo de combustible
  }

  void _onFirstCardDoubleTap() async {
    showConfirmationDialog(
      title: 'Confirmar Acción',
      message: '¿Deseas crear una nueva orden de compra?',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      onConfirm: () async {
        await purchaseOrderController.createPurchaseOrder();

        if (purchaseOrderController.purchaseOrderId.isNotEmpty) {
          setState(() {
            isFirstCardEnabled = false;
            isDetailsCardEnabled = true;
            areFuelCardsEnabled = false;
          });

          Get.snackbar(
            'Éxito',
            'Orden creada con ID: ${purchaseOrderController.purchaseOrderId}',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            'No se pudo crear la orden',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      onCancel: () {
        // Acción opcional al cancelar
      },
    );
  }

  void _onDetailsCardDoubleTap() {
    OrderDetailsDialog(
      context: context,
      vehicleController: vehicleController,
      storesController: storesController,
      orderDateController: orderDateController,
      dispatchDateController: dispatchDateController,
      shiftTimeController: shiftTimeController,
      selectedStore: selectedStore,
      selectedStoreId: selectedStoreId,
      selectedVehicle: selectedVehicle,
      selectedVehicleId: selectedVehicleId,
      orderNumberController: orderNumberController,
      onSave: (String newOrderDate,
          String newDispatchDate,
          String newOrderNumber,
          String newStore,
          String newStoreId,
          String newVehicle,
          String newVehicleId,
          String newShiftTime) {
        setState(() {
          orderDate = newOrderDate;
          dispatchDate = newDispatchDate;
          orderNumber = newOrderNumber;
          selectedStore = newStore;
          selectedStoreId = newStoreId;
          selectedVehicle = newVehicle;
          selectedVehicleId = newVehicleId;
          shiftTime = newShiftTime;
          areFuelCardsEnabled =
              true; // Habilitar los Fuel Cards después de guardar
        });
      },
      purchaseOrderController: purchaseOrderController,
    ).show();
  }

  void _onSaveOrder() async {
    if (orderNumber == '0' ||
        selectedStoreId.isEmpty ||
        selectedVehicleId.isEmpty) {
      Get.snackbar(
          'Error', 'Debe completar todos los campos para guardar la orden.');
      return;
    }

    // Convertir fechas a DateTime
    DateTime orderDateParsed = DateTime.parse(orderDateController.text);
    DateTime deliveryDateParsed = DateTime.parse(dispatchDateController.text);

    // Llamar al método del controlador para crear o actualizar la orden
    await purchaseOrderController.createOrUpdatePurchaseOrder(
      orderNumber: orderNumber,
      orderDate: orderDateParsed,
      deliveryDate: deliveryDateParsed,
      totalPurchaseOrder: double.tryParse(totalFacturaValue) ?? 0.00,
      totalIDPPurchaseOrder: double.tryParse(totalIDPValue) ?? 0.00,
      storeId: selectedStoreId,
      vehicleId: selectedVehicleId,
      applied: false, // Valor predeterminado
      turn: shiftTime,
      totalGallonRegular: int.tryParse(regularValue) ?? 0,
      totalGallonSuper: int.tryParse(superValue) ?? 0,
      totalGallonDiesel: int.tryParse(dieselValue) ?? 0,
    );

    // Mostrar mensaje de éxito o error según la respuesta del controlador
    if (purchaseOrderController.createUpdatePurchaseOrderResponse.value?.ok ??
        false) {
      Get.snackbar('Éxito', 'Orden guardada con éxito.');
    } else {
      Get.snackbar('Error', 'Error al guardar la orden.');
    }
  }

  void _onDeleteOrder() {
    // Implementar lógica para eliminar la orden
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Nueva Orden'),
      ),
      drawer: SideMenuShop(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
      body: FutureBuilder(
        future: fuelController.fetchFuels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading fuels'));
          } else if (fuelController.fuels.isEmpty) {
            return Center(child: Text('No fuels available'));
          } else {
            return OrderScreenBuilder(
              isFirstCardEnabled: isFirstCardEnabled,
              isDetailsCardEnabled: isDetailsCardEnabled,
              areFuelCardsEnabled: areFuelCardsEnabled,
              orderDate: orderDate,
              dispatchDate: dispatchDate,
              orderNumber: orderNumber,
              selectedStore: selectedStore,
              selectedStoreId: selectedStoreId,
              selectedVehicle: selectedVehicle,
              selectedVehicleId: selectedVehicleId,
              shiftTime: shiftTime,
              superValue: superValue,
              regularValue: regularValue,
              dieselValue: dieselValue,
              subTotalValue: subTotalValue,
              totalIDPValue: totalIDPValue,
              totalFacturaValue: totalFacturaValue,
              onFirstCardDoubleTap: _onFirstCardDoubleTap,
              onDetailsCardDoubleTap: _onDetailsCardDoubleTap,
              showFuelDialog: _showFuelDialog,
              onSave:
                  _onSaveOrder, // Llamar a _onSaveOrder al presionar "Guardar"
              onDelete: _onDeleteOrder, // Implementar lógica para eliminar
            ).buildOrderScreen();
          }
        },
      ),
    );
  }
}
