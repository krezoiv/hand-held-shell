import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/label.row.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/detail.card.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/new.order/fuel.card.dart';

class OrderScreenBuilder {
  final bool isFirstCardEnabled;
  final bool isDetailsCardEnabled;
  final bool areFuelCardsEnabled;
  final String orderDate;
  final String dispatchDate;
  final String orderNumber;
  final String selectedStore;
  final String selectedStoreId;
  final String selectedVehicle;
  final String selectedVehicleId;
  final String shiftTime;
  final String superValue;
  final String regularValue;
  final String dieselValue;
  final String subTotalValue;
  final String totalIDPValue;
  final String totalFacturaValue;
  final VoidCallback onFirstCardDoubleTap;
  final VoidCallback onDetailsCardDoubleTap;
  final Function(String) showFuelDialog;
  final VoidCallback onSave; // Callback para el botón de guardar
  final VoidCallback onDelete; // Callback para el botón de eliminar

  OrderScreenBuilder({
    required this.isFirstCardEnabled,
    required this.isDetailsCardEnabled,
    required this.areFuelCardsEnabled,
    required this.orderDate,
    required this.dispatchDate,
    required this.orderNumber,
    required this.selectedStore,
    required this.selectedStoreId,
    required this.selectedVehicle,
    required this.selectedVehicleId,
    required this.shiftTime,
    required this.superValue,
    required this.regularValue,
    required this.dieselValue,
    required this.subTotalValue,
    required this.totalIDPValue,
    required this.totalFacturaValue,
    required this.onFirstCardDoubleTap,
    required this.onDetailsCardDoubleTap,
    required this.showFuelDialog,
    required this.onSave, // Requerido para guardar
    required this.onDelete, // Requerido para eliminar
  });

  Widget buildOrderScreen() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onDoubleTap: isFirstCardEnabled ? onFirstCardDoubleTap : null,
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
                    LabelRow(label: 'Fecha de despacho:', value: dispatchDate),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'No. Orden:', value: orderNumber),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Planta:', value: selectedStore),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'PlantaId:', value: selectedStoreId),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Vehiculo:', value: selectedVehicle),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'IdVehiculo:', value: selectedVehicleId),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Turno:', value: shiftTime),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Super:', value: superValue),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Regular:', value: regularValue),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Diesel:', value: dieselValue),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Sub Total:', value: subTotalValue),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Total IDP:', value: totalIDPValue),
                    const SizedBox(height: 10.0),
                    LabelRow(label: 'Total Factura:', value: totalFacturaValue),
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
                  onDoubleTap:
                      isDetailsCardEnabled ? onDetailsCardDoubleTap : null,
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
                      showFuelDialog('Super');
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
                      showFuelDialog('Regular');
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
                      showFuelDialog('Diesel');
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
          const SizedBox(height: 10.0),
          // Botones para Guardar y Eliminar
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
