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

  void show() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de $fuelType'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: montoController,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: idpController,
                  decoration: const InputDecoration(labelText: 'IDP'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: totalController,
                  decoration: const InputDecoration(labelText: 'Total'),
                  keyboardType: TextInputType.number,
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
                onSave();
                Navigator.of(context)
                    .pop(); // Cierra el diálogo después de guardar
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
  }
}
