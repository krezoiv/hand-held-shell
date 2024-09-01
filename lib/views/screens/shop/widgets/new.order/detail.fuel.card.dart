import 'package:flutter/material.dart';
import 'package:hand_held_shell/controllers/purchases/orders/purchase.order.controller.dart';

class FuelDetailDialog {
  final BuildContext context;
  final String fuelType;
  final TextEditingController montoController;
  final TextEditingController idpController;
  final TextEditingController precioController;
  final TextEditingController totalController;
  final TextEditingController totalIdpController; // Controlador para Total IDP
  final String fuelId;
  final String purchaseOrderId;
  final PurchaseOrderController purchaseOrderController;
  final VoidCallback onSave;
  final double idpAmount;

  FuelDetailDialog({
    required this.context,
    required this.fuelType,
    required this.montoController,
    required this.idpController,
    required this.precioController,
    required this.totalController,
    required this.totalIdpController, // Controlador para Total IDP
    required this.fuelId,
    required this.purchaseOrderId,
    required this.purchaseOrderController,
    required this.onSave,
    required this.idpAmount,
  });

  double _calculateTitleValue() {
    double monto = double.tryParse(montoController.text) ?? 0.0;
    double precio = double.tryParse(precioController.text) ?? 0.0;
    return monto * precio;
  }

  void _calculateTotal() {
    double monto = double.tryParse(montoController.text) ?? 0.0;
    double idp = double.tryParse(idpController.text) ?? 0.0;
    double precio = double.tryParse(precioController.text) ?? 0.0;

    double total = (monto * precio) - (monto * idp);
    double totalIdp = monto * idp; // Calcular el Total IDP

    totalController.text = total.toStringAsFixed(2);
    totalIdpController.text = totalIdp.toStringAsFixed(2); // Mostrar Total IDP
  }

  void show() {
    // Pre-poblar el valor del IDP
    idpController.text = idpAmount.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                  '$fuelType: ${_calculateTitleValue().toStringAsFixed(2)}'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: montoController,
                      decoration: const InputDecoration(
                        labelText: 'Monto',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _calculateTotal();
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: precioController,
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _calculateTotal();
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: idpController,
                      decoration: const InputDecoration(
                        labelText: 'IDP',
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true, // Campo de solo lectura
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: totalIdpController, // Campo para Total IDP
                      decoration: const InputDecoration(
                        labelText: 'Total IDP',
                      ),
                      readOnly: true, // Campo de solo lectura
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: totalController,
                      decoration: const InputDecoration(
                        labelText: 'Total',
                      ),
                      readOnly: true, // Campo de solo lectura
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.save,
                    size: 30.0,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    double newMonto =
                        double.tryParse(montoController.text) ?? 0.0;
                    double newPrecio =
                        double.tryParse(precioController.text) ?? 0.0;
                    double newTotal =
                        double.tryParse(totalController.text) ?? 0.0;

                    // Validaciones
                    if (newMonto == 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'El campo Monto es requerido y debe ser mayor que 0.'),
                        ),
                      );
                      return;
                    }

                    if (newPrecio == 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'El campo Precio es requerido y debe ser mayor que 0.'),
                        ),
                      );
                      return;
                    }

                    if (newTotal < 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El Total no puede ser negativo.'),
                        ),
                      );
                      return;
                    }

                    double newIdp = double.tryParse(idpController.text) ?? 0.0;
                    double newTotalIdp =
                        double.tryParse(totalIdpController.text) ?? 0.0;

                    onSave(); // Llama a onSave para actualizar los valores

                    await purchaseOrderController.updateDetailPurchaseOrder(
                      purchaseOrderId: purchaseOrderId,
                      fuelId: fuelId,
                      amount: newMonto,
                      price: newPrecio,
                      idpTotal: newTotalIdp, // Guardar el total IDP
                      total: newTotal,
                    );

                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 30.0,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Solo cierra el diálogo
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
