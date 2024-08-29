import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/persons/stores/stores.controller.dart';
import 'package:hand_held_shell/controllers/persons/vehicles/vehicles.controller.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/detail.card.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/detail.fuel.card.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/fuel.card.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/label.row.dart';

import 'package:hand_held_shell/views/screens/shop/widgets/new.order/order.detail.dialog.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/side.menu.shop.dart';

class NewOrderShopsScreen extends StatefulWidget {
  const NewOrderShopsScreen({super.key});

  @override
  _NewOrderShopsScreenState createState() => _NewOrderShopsScreenState();
}

class _NewOrderShopsScreenState extends State<NewOrderShopsScreen> {
  final VechicleController vehicleController = Get.put(VechicleController());
  final StoresController storesController = Get.put(StoresController());

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
  String superMonto = '0';
  String regularMonto = '0';
  String dieselMonto = '0';
  double subTotal = 0.0;
  double totalIDP = 0.0;
  double totalFactura = 0.0;

  // Controladores para los campos de texto
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController dispatchDateController = TextEditingController();
  final TextEditingController shiftTimeController = TextEditingController();

  // Controladores para los diálogos de Fuel
  final TextEditingController superMontoController = TextEditingController();
  final TextEditingController superIdpController = TextEditingController();
  final TextEditingController superPrecioController = TextEditingController();
  final TextEditingController superTotalController = TextEditingController();

  final TextEditingController regularMontoController = TextEditingController();
  final TextEditingController regularIdpController = TextEditingController();
  final TextEditingController regularPrecioController = TextEditingController();
  final TextEditingController regularTotalController = TextEditingController();

  final TextEditingController dieselMontoController = TextEditingController();
  final TextEditingController dieselIdpController = TextEditingController();
  final TextEditingController dieselPrecioController = TextEditingController();
  final TextEditingController dieselTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    orderDateController.text = orderDate;
    dispatchDateController.text = dispatchDate;
    shiftTimeController.text = shiftTime;
  }

  void _calculateTotals() {
    totalFactura = subTotal - totalIDP;
  }

  void _showFuelDialog(String fuelType) {
    TextEditingController montoController;
    TextEditingController idpController;
    TextEditingController precioController;
    TextEditingController totalController;
    String originalMonto;
    String originalIdp;
    String originalTotal;

    if (fuelType == 'Super') {
      montoController = superMontoController;
      idpController = superIdpController;
      precioController = superPrecioController;
      totalController = superTotalController;

      originalMonto = superMonto;
      originalIdp = superIdpController.text;
      originalTotal = superTotalController.text;
    } else if (fuelType == 'Regular') {
      montoController = regularMontoController;
      idpController = regularIdpController;
      precioController = regularPrecioController;
      totalController = regularTotalController;

      originalMonto = regularMonto;
      originalIdp = regularIdpController.text;
      originalTotal = regularTotalController.text;
    } else {
      montoController = dieselMontoController;
      idpController = dieselIdpController;
      precioController = dieselPrecioController;
      totalController = dieselTotalController;

      originalMonto = dieselMonto;
      originalIdp = dieselIdpController.text;
      originalTotal = dieselTotalController.text;
    }

    FuelDetailDialog(
      context: context,
      fuelType: fuelType,
      montoController: montoController,
      idpController: idpController,
      precioController: precioController,
      totalController: totalController,
      onSave: () {
        setState(() {
          double newMonto = double.tryParse(montoController.text) ?? 0.0;
          double newIdp = double.tryParse(idpController.text) ?? 0.0;
          double newTotal = double.tryParse(totalController.text) ?? 0.0;

          // Multiplicar Monto por IDP y calcular el nuevo total IDP
          double idpTotal = newMonto * newIdp;

          // Solo actualizar si hay cambios
          if (montoController.text != originalMonto ||
              idpController.text != originalIdp ||
              totalController.text != originalTotal) {
            // Restar los valores anteriores del Sub Total y Total IDP
            subTotal -= double.tryParse(originalTotal) ?? 0.0;
            totalIDP -= (double.tryParse(originalMonto) ?? 0.0) *
                (double.tryParse(originalIdp) ?? 0.0);

            // Agregar los valores nuevos al Sub Total y Total IDP
            subTotal += newTotal;
            totalIDP += idpTotal;

            // Actualizar los montos específicos
            if (fuelType == 'Super') {
              superMonto = newMonto.toString();
            } else if (fuelType == 'Regular') {
              regularMonto = newMonto.toString();
            } else if (fuelType == 'Diesel') {
              dieselMonto = newMonto.toString();
            }

            _calculateTotals();
          }
        });
      },
    ).show();
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isFirstCardEnabled = false;
                  isDetailsCardEnabled = true;
                });
              },
              child: Card(
                elevation: isFirstCardEnabled ? 4.0 : 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelRow(label: 'Fecha de orden:', value: orderDate),
                      const SizedBox(height: 10.0),
                      LabelRow(
                          label: 'Fecha de despacho:', value: dispatchDate),
                      const SizedBox(height: 10.0),
                      LabelRow(label: 'No. Orden:', value: orderNumber),
                      const SizedBox(height: 10.0),
                      LabelRow(label: 'Planta:', value: selectedStore),
                      const SizedBox(height: 10.0),
                      Visibility(
                          visible: false,
                          child: LabelRow(
                              label: 'storeId:', value: selectedStoreId)),
                      LabelRow(label: 'Vehiculo:', value: selectedVehicle),
                      const SizedBox(height: 10.0),
                      Visibility(
                          visible: false,
                          child: LabelRow(
                            label: 'VehicleId:',
                            value: selectedVehicleId,
                          )),
                      LabelRow(label: 'Turno:', value: shiftTime),
                      const SizedBox(height: 10.0),
                      LabelRow(label: 'Super:', value: superMonto),
                      const SizedBox(height: 10.0),
                      LabelRow(label: 'Regular:', value: regularMonto),
                      const SizedBox(height: 10.0),
                      LabelRow(label: 'Diesel:', value: dieselMonto),
                      const SizedBox(height: 10.0),
                      LabelRow(
                          label: 'Sub Total:',
                          value: subTotal.toStringAsFixed(2)),
                      const SizedBox(height: 10.0),
                      LabelRow(
                          label: 'Total IDP:',
                          value: totalIDP.toStringAsFixed(2)),
                      const SizedBox(height: 10.0),
                      LabelRow(
                          label: 'Total Factura:',
                          value: totalFactura.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 3 / 2,
                children: [
                  GestureDetector(
                    onDoubleTap: () {
                      if (isDetailsCardEnabled) {
                        OrderDetailsDialog(
                          storesController: storesController,
                          context: context,
                          vehicleController: vehicleController,
                          orderDateController: orderDateController,
                          dispatchDateController: dispatchDateController,
                          shiftTimeController: shiftTimeController,
                          selectedStore: selectedStore,
                          selectedStoreId: selectedStoreId,
                          selectedVehicle: selectedVehicle,
                          selectedVehicleId: selectedVehicleId,
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
                              areFuelCardsEnabled = true;
                            });
                          },
                        ).show();
                      }
                    },
                    child: DetailsCard(
                      icon: Icons.info,
                      label: 'Detalles',
                      iconSize: 48.0,
                      isEnabled: isDetailsCardEnabled,
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      if (areFuelCardsEnabled) {
                        _showFuelDialog('Super');
                      }
                    },
                    child: FuelCard(
                      icon: Icons.local_gas_station,
                      label: 'Super',
                      iconSize: 48.0,
                      isEnabled: areFuelCardsEnabled,
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      if (areFuelCardsEnabled) {
                        _showFuelDialog('Regular');
                      }
                    },
                    child: FuelCard(
                      icon: Icons.local_gas_station,
                      label: 'Regular',
                      iconSize: 48.0,
                      isEnabled: areFuelCardsEnabled,
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      if (areFuelCardsEnabled) {
                        _showFuelDialog('Diesel');
                      }
                    },
                    child: FuelCard(
                      icon: Icons.local_gas_station,
                      label: 'Diesel',
                      iconSize: 48.0,
                      isEnabled: areFuelCardsEnabled,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
