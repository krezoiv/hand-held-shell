import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/accounting/bills/bills.controller.dart';
import 'package:intl/intl.dart';

class BillsBottomSheet extends StatefulWidget {
  final BillsController billsController;
  final Function onSave;

  const BillsBottomSheet({
    Key? key,
    required this.billsController,
    required this.onSave,
  }) : super(key: key);

  @override
  _BillsBottomSheetState createState() => _BillsBottomSheetState();
}

class _BillsBottomSheetState extends State<BillsBottomSheet> {
  late TextEditingController billNumberController;
  late TextEditingController billDateController;
  late TextEditingController billAmountController;
  late TextEditingController billDescriptionController;

  @override
  void initState() {
    super.initState();
    billNumberController = TextEditingController();
    billDateController = TextEditingController();
    billAmountController = TextEditingController();
    billDescriptionController = TextEditingController();
    _fetchBills();
  }

  Future<void> _fetchBills() async {
    await widget.billsController.fetchBillsBySalesControl();
  }

  @override
  void dispose() {
    billNumberController.dispose();
    billDateController.dispose();
    billAmountController.dispose();
    billDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
            _buildDataTab(),
            _buildTableTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('Número Correlativo',
                controller: billNumberController),
            buildTextField('Fecha',
                inputType: TextInputType.datetime,
                controller: billDateController),
            buildTextField('Monto', controller: billAmountController),
            buildTextField('Descripción',
                controller: billDescriptionController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveBill,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label,
      {TextInputType inputType = TextInputType.text,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: inputType,
      ),
    );
  }

  Widget _buildTableTab() {
    return Obx(() {
      if (widget.billsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final bills = widget.billsController.billsListResponse.value?.bills ?? [];

      if (bills.isEmpty) {
        return const Center(child: Text('No hay facturas disponibles'));
      }

      return RefreshIndicator(
        onRefresh: _fetchBills,
        child: ListView.builder(
          itemCount: bills.length,
          itemBuilder: (context, index) {
            final bill = bills[index];
            return ListTile(
              title: Text('Número: ${bill.billNumber}'),
              subtitle: Text('Monto: ${bill.billAmount}'),
              trailing: Text(DateFormat('dd-MM-yyyy').format(bill.billDate)),
            );
          },
        ),
      );
    });
  }

  void _saveBill() async {
    final billNumber = billNumberController.text;
    final billDate = DateFormat('yyyy-MM-dd').parse(billDateController.text);
    final billAmount =
        num.tryParse(billAmountController.text.replaceAll(',', ''));
    final billDescription = billDescriptionController.text;

    if (billNumber.isEmpty || billAmount == null || billDescription.isEmpty) {
      Get.snackbar('Error', 'Por favor, complete todos los campos');
      return;
    }

    await widget.billsController.createBill(
      billNumber: billNumber,
      billDate: billDate,
      billAmount: billAmount,
      billDescription: billDescription,
    );

    // Actualizar la lista de facturas
    await _fetchBills();

    // Llamar a la función onSave
    widget.onSave();

    // Limpiar los campos
    billNumberController.clear();
    billDateController.clear();
    billAmountController.clear();
    billDescriptionController.clear();

    // Mostrar mensaje de éxito
    Get.snackbar('Éxito', 'Factura guardada exitosamente');
  }
}
