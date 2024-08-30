import 'package:flutter/material.dart';

class FuelDetailDialog {
  final BuildContext context;
  final String fuelType;
  final TextEditingController montoController;
  final TextEditingController idpController;
  final TextEditingController precioController;
  final TextEditingController totalController;
  final VoidCallback onSave;

  FuelDetailDialog({
    required this.context,
    required this.fuelType,
    required this.montoController,
    required this.idpController,
    required this.precioController,
    required this.totalController,
    required this.onSave,
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

    totalController.text = total.toStringAsFixed(2);
  }

  void show() {
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
                        }); // Recalcula el total y actualiza el título
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: idpController,
                      decoration: const InputDecoration(
                        labelText: 'IDP',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _calculateTotal();
                        }); // Recalcula el total y actualiza el título
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
                        }); // Recalcula el total y actualiza el título
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: totalController,
                      decoration: const InputDecoration(
                        labelText: 'Total',
                      ),
                      readOnly: true, // El campo de total es de solo lectura
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
                  onPressed: () {
                    onSave(); // Guarda los datos
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
