import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/persons/stores/stores.controller.dart';
import 'package:hand_held_shell/controllers/persons/vehicles/vehicles.controller.dart';
import 'package:intl/intl.dart';

class OrderDetailsDialog {
  final BuildContext context;
  final TextEditingController orderDateController;
  final TextEditingController dispatchDateController;
  final TextEditingController shiftTimeController;
  final VechicleController vehicleController;
  final StoresController storesController;
  final Function(
    String orderDate,
    String dispatchDate,
    String orderNumber,
    String storeName,
    String storeId,
    String vehicleName,
    String vehicleId,
    String shiftTime,
  ) onSave;

  String selectedStore;
  String selectedStoreId;
  String selectedVehicle;
  String selectedVehicleId;

  OrderDetailsDialog({
    required this.context,
    required this.vehicleController,
    required this.storesController,
    required this.orderDateController,
    required this.dispatchDateController,
    required this.shiftTimeController,
    required this.selectedStore,
    required this.selectedStoreId,
    required this.selectedVehicle,
    required this.selectedVehicleId,
    required this.onSave,
  });

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      controller.text = formattedDate;
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute));
      controller.text = formattedTime;
    }
  }

  void _saveOrderDetails() {
    onSave(
      orderDateController.text,
      dispatchDateController.text,
      shiftTimeController.text,
      selectedStore,
      selectedStoreId,
      selectedVehicle,
      selectedVehicleId,
      shiftTimeController.text,
    );
    Navigator.of(context).pop(); // Cierra el diálogo después de guardar
  }

  void show() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Detalles de la Orden'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: orderDateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Orden',
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate(orderDateController);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: dispatchDateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Despacho',
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate(dispatchDateController);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'No. de Orden',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    Obx(() {
                      if (storesController.isLoading.value) {
                        return const CircularProgressIndicator();
                      }
                      return DropdownButtonFormField<String>(
                        value: selectedStoreId.isEmpty ? null : selectedStoreId,
                        decoration: const InputDecoration(
                          labelText: 'Planta',
                        ),
                        items: storesController.storesList.map((store) {
                          return DropdownMenuItem<String>(
                            value: store.storeId,
                            child: Text(store.storeName),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedStore = storesController.storesList
                                  .firstWhere(
                                      (store) => store.storeId == newValue)
                                  .storeName;
                              selectedStoreId = newValue;
                            });
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 16.0),
                    Obx(() {
                      if (vehicleController.isLoading.value) {
                        return const CircularProgressIndicator();
                      }
                      return DropdownButtonFormField<String>(
                        value: selectedVehicleId.isEmpty
                            ? null
                            : selectedVehicleId,
                        decoration: const InputDecoration(
                          labelText: 'Vehículo',
                        ),
                        items: vehicleController.vehiclesList.map((vehicle) {
                          return DropdownMenuItem<String>(
                            value: vehicle.vehicleId,
                            child: Text(vehicle.vehicleName),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedVehicle = vehicleController.vehiclesList
                                  .firstWhere((vehicle) =>
                                      vehicle.vehicleId == newValue)
                                  .vehicleName;
                              selectedVehicleId = newValue;
                            });
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: shiftTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Turno',
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectTime(shiftTimeController);
                      },
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
                    _saveOrderDetails();
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
