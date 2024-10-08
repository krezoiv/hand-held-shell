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

  bool areButtonsEnabled = false; // Inicialmente deshabilitado

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
  String totalGallonRegular = '0.0';
  String totalGallonSuper = '0.0';
  String totalGallonDiesel = '0.0';
  String totalFacturaValue = '';

  // Controladores para los campos de texto
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController dispatchDateController = TextEditingController();
  final TextEditingController shiftTimeController = TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();

  // Controladores para los diálogos de Fuel (Asegúrate de que estén definidos)
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

  @override
  void dispose() {
    // Liberar todos los controladores para evitar fugas de memoria
    orderDateController.dispose();
    dispatchDateController.dispose();
    shiftTimeController.dispose();
    orderNumberController.dispose();

    superMontoController.dispose();
    superIdpController.dispose();
    superPrecioController.dispose();
    superTotalController.dispose();
    superTotalIdpController.dispose();

    regularMontoController.dispose();
    regularIdpController.dispose();
    regularPrecioController.dispose();
    regularTotalController.dispose();
    regularTotalIdpController.dispose();

    dieselMontoController.dispose();
    dieselIdpController.dispose();
    dieselPrecioController.dispose();
    dieselTotalController.dispose();
    dieselTotalIdpController.dispose();

    super.dispose();
  }

  void _enableButtons() {
    setState(() {
      areButtonsEnabled = true; // Habilitar los botones
    });
  }

  void resetOrderState() {
    setState(() {
      // Restablecer los valores del primer Card
      orderDate = 'dd/mm/yyyy';
      dispatchDate = 'dd/mm/yyyy';
      orderNumber = '0';
      selectedStore = 'Planta';
      selectedStoreId = '';
      selectedVehicle = 'Camión';
      selectedVehicleId = '';
      shiftTime = '00:00 am';

      // Restablecer los valores de los montos y totales
      superValue = '';
      regularValue = '';
      dieselValue = '';
      subTotalValue = '0.0';
      totalIDPValue = '0.0';
      totalGallonRegular = '0.0';
      totalGallonSuper = '0.0';
      totalGallonDiesel = '0.0';
      totalFacturaValue = '';

      // Limpiar los controladores de texto
      orderDateController.clear();
      dispatchDateController.clear();
      shiftTimeController.clear();
      orderNumberController.clear();

      superMontoController.clear();
      superIdpController.clear();
      superPrecioController.clear();
      superTotalController.clear();
      superTotalIdpController.clear();

      regularMontoController.clear();
      regularIdpController.clear();
      regularPrecioController.clear();
      regularTotalController.clear();
      regularTotalIdpController.clear();

      dieselMontoController.clear();
      dieselIdpController.clear();
      dieselPrecioController.clear();
      dieselTotalController.clear();
      dieselTotalIdpController.clear();

      // Reiniciar los estados de los cards
      isFirstCardEnabled = true;
      isDetailsCardEnabled = false;
      areFuelCardsEnabled = false;
    });
  }

  void _calculateTotals() {
    double subTotal = double.tryParse(subTotalValue) ?? 0.0;
    double totalIDP = double.tryParse(totalIDPValue) ?? 0.0;

    totalFacturaValue = (subTotal + totalIDP).toStringAsFixed(2);
  }

  void _showFuelDialog(String fuelType) {
    // Inicialización predeterminada de los controladores
    TextEditingController montoController = TextEditingController();
    TextEditingController idpController = TextEditingController();
    TextEditingController precioController = TextEditingController();
    TextEditingController totalController = TextEditingController();
    TextEditingController totalIdpController = TextEditingController();
    String originalMonto = '';
    String originalTotal = '';
    String originalTotalIdp = '';

    String? fuelId;
    double idpAmount = 0.0;

    fuelType = fuelType.toLowerCase();

    var fuel = fuelController.fuels.firstWhere(
      (fuel) => fuel.fuelName.toLowerCase() == fuelType,
      orElse: () {
        return Fuel(
          fuelName: 'not_found',
          costPrice: 0.0,
          salePrice: 0.0,
          statusId: Status(id: '', statusName: 'not_found'),
          taxesId: Taxes(id: '', idpName: 'not_found', idpAmount: 0.0),
          fuelId: '',
        );
      },
    );

    if (fuel.fuelName != 'not_found') {
      idpAmount = fuel.taxesId.idpAmount;
    } else {
      Get.snackbar('Error', 'Fuel type not found: $fuelType');
      return;
    }

    if (fuelType == 'super') {
      montoController = superMontoController;
      idpController = superIdpController;
      precioController = superPrecioController;
      totalController = superTotalController;
      totalIdpController = superTotalIdpController;

      originalMonto = superValue;
      originalTotal = superTotalController.text;
      originalTotalIdp = superTotalIdpController.text;

      fuelId = fuelController.fuelIds['super'];
    } else if (fuelType == 'regular') {
      montoController = regularMontoController;
      idpController = regularIdpController;
      precioController = regularPrecioController;
      totalController = regularTotalController;
      totalIdpController = regularTotalIdpController;

      originalMonto = regularValue;
      originalTotal = regularTotalController.text;
      originalTotalIdp = regularTotalIdpController.text;

      fuelId = fuelController.fuelIds['regular'];
    } else if (fuelType == 'diesel') {
      montoController = dieselMontoController;
      idpController = dieselIdpController;
      precioController = dieselPrecioController;
      totalController = dieselTotalController;
      totalIdpController = dieselTotalIdpController;

      originalMonto = dieselValue;
      originalTotal = dieselTotalController.text;
      originalTotalIdp = dieselTotalIdpController.text;

      fuelId = fuelController.fuelIds['diesel'];
    }

    // Calcula el valor de Total IDP basado en el Monto y el IDP al abrir el diálogo
    double monto = double.tryParse(montoController.text) ?? 0.0;
    totalIdpController.text = (monto * idpAmount).toStringAsFixed(2);

    FuelDetailDialog(
      context: context,
      fuelType: fuelType,
      montoController: montoController,
      idpController: idpController,
      precioController: precioController,
      totalController: totalController,
      totalIdpController: totalIdpController,
      fuelId: fuelId!,
      purchaseOrderId: purchaseOrderController.purchaseOrderId.value,
      purchaseOrderController: purchaseOrderController,
      idpAmount: idpAmount,
      onSave: () {
        setState(() {
          double newMonto = double.tryParse(montoController.text) ?? 0.0;
          double newTotal = double.tryParse(totalController.text) ?? 0.0;
          double newTotalIdp = double.tryParse(totalIdpController.text) ?? 0.0;

          double previousTotalIdp = double.tryParse(originalTotalIdp) ?? 0.0;
          double previousTotal = double.tryParse(originalTotal) ?? 0.0;

          double currentTotalIdp = double.tryParse(totalIDPValue) ?? 0.0;
          double currentSubTotal = double.tryParse(subTotalValue) ?? 0.0;

          // Verificar si hay cambios en los valores
          if (newMonto.toStringAsFixed(2) == originalMonto &&
              newTotal.toStringAsFixed(2) == originalTotal &&
              newTotalIdp.toStringAsFixed(2) == originalTotalIdp) {
            // Si los valores son los mismos, no hacer nada
            return;
          }

          // Restar los valores originales de los campos de Total IDP y Sub Total
          totalIDPValue =
              (currentTotalIdp - previousTotalIdp).toStringAsFixed(2);
          subTotalValue = (currentSubTotal - previousTotal).toStringAsFixed(2);

          // Sumar los nuevos valores actualizados
          totalIDPValue = (double.tryParse(totalIDPValue)! + newTotalIdp)
              .toStringAsFixed(2);
          subTotalValue =
              (double.tryParse(subTotalValue)! + newTotal).toStringAsFixed(2);

          // Actualiza los valores individuales si es necesario
          if (fuelType == 'super') {
            superValue = newMonto.toStringAsFixed(0);
          } else if (fuelType == 'regular') {
            regularValue = newMonto.toStringAsFixed(0);
          } else if (fuelType == 'diesel') {
            dieselValue = newMonto.toStringAsFixed(0);
          }

          // Recalcula el total de la factura
          _calculateTotals();
        });
      },
    ).show();
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

        _enableButtons(); // Llamar a esta función para habilitar los botones
      },
      purchaseOrderController: purchaseOrderController,
    ).show();
  }

  String convertDateFormat(String date) {
    // Separar el día, mes y año
    List<String> parts = date.split('/');
    if (parts.length == 3) {
      // Retornar en el formato esperado por DateTime.parse (YYYY-MM-DD)
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    // Retornar la fecha original si no tiene el formato esperado
    return date;
  }

  Future<void> _onSaveButtonPressed() async {
    showConfirmationDialog(
      title: 'Confirmación',
      message: '¿Estás seguro de que deseas guardar la orden?',
      confirmText: 'Guardar',
      cancelText: 'Cancelar',
      onConfirm: () async {
        try {
          await purchaseOrderController.createOrUpdatePurchaseOrder(
            orderNumber: orderNumberController.text,
            orderDate:
                DateTime.parse(convertDateFormat(orderDateController.text)),
            deliveryDate:
                DateTime.parse(convertDateFormat(dispatchDateController.text)),
            totalPurchaseOrder: double.tryParse(subTotalValue) ?? 0.0,
            totalIDPPurchaseOrder: double.tryParse(totalIDPValue) ?? 0.0,
            storeId: selectedStoreId,
            vehicleId: selectedVehicleId,
            applied: true,
            turn: shiftTime,
            totalGallonRegular: int.tryParse(regularValue) ?? 0,
            totalGallonSuper: int.tryParse(superValue) ?? 0,
            totalGallonDiesel: int.tryParse(dieselValue) ?? 0,
          );

          // Cierra el diálogo de confirmación después de guardar
          Navigator.of(context).pop();

          Get.snackbar('Éxito', 'Orden guardada exitosamente',
              snackPosition: SnackPosition.BOTTOM);

          // Resetea el estado después de guardar
          resetOrderState();
        } catch (e) {
          Get.snackbar('Error', 'No se pudo guardar la orden: $e',
              snackPosition: SnackPosition.BOTTOM);
        }
      },
      onCancel: () {
        // Aquí puedes agregar alguna acción al cancelar, si es necesario.
      },
    );
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
              areButtonsEnabled:
                  areButtonsEnabled, // Controlar el estado de los botones
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
              onSave: _onSaveButtonPressed,
              onDelete: () {
                // Implementa aquí la lógica para eliminar la orden
                // Puedes agregar un método en el controlador de la orden para eliminar
              },
            ).buildOrderScreen();
          }
        },
      ),
    );
  }
}
