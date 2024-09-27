import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/purchases/orders/purchase.order.controller.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/side.menu.shop.dart';

class NewShopsScreen extends StatefulWidget {
  const NewShopsScreen({super.key});

  @override
  _NewShopsScreenState createState() => _NewShopsScreenState();
}

class _NewShopsScreenState extends State<NewShopsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController orderNumberController = TextEditingController();
  final PurchaseOrderController _purchaseOrderController =
      Get.put(PurchaseOrderController());

  bool isDeleteButtonEnabled = false;
  bool isActionButtonEnabled = false;
  bool isCredit = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: scaffoldKey,
        title: const Text('Nueva Compra'),
      ),
      drawer: SideMenuShop(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ingrese número de orden',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: orderNumberController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Número de orden',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () async {
                              String orderNumber = orderNumberController.text;
                              if (orderNumber.isNotEmpty) {
                                await _purchaseOrderController
                                    .getPurchaseOrderByOrderNumber(orderNumber);

                                if (_purchaseOrderController
                                        .purchaseOrder.value !=
                                    null) {
                                  setState(() {
                                    isDeleteButtonEnabled = true;
                                    isActionButtonEnabled = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Orden encontrada: ${_purchaseOrderController.purchaseOrder.value!.orderNumber}'),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    isDeleteButtonEnabled = false;
                                    isActionButtonEnabled = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'No se encontró ninguna orden con el número: $orderNumber'),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, ingrese un número de orden'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
                              ),
                            ),
                            child: const Text(
                              'Buscar',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconColumn(Icons.receipt_long, 'Factura', Colors.blue,
                    _showFacturaDialog, isActionButtonEnabled),
                _buildIconColumn(Icons.payment, 'Pagos', Colors.green,
                    _showPagosDialog, isActionButtonEnabled),
                _buildIconColumn(Icons.account_balance, 'Bancos', Colors.orange,
                    _showBancosDialog, isActionButtonEnabled),
                _buildIconColumn(Icons.card_giftcard, 'Cupones', Colors.purple,
                    _showCuponesDialog, isActionButtonEnabled),
              ],
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Detalle Orden',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigoAccent, // Color del título
                            ),
                          ),
                          Obx(
                            () =>
                                _purchaseOrderController.purchaseOrder.value !=
                                        null
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : const SizedBox(),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => _buildDetailRow(
                                    'No. de orden',
                                    _purchaseOrderController
                                            .purchaseOrder.value?.orderNumber ??
                                        'No encontrado',
                                  )),
                              Obx(() => _buildDetailRow(
                                    'Fecha de orden',
                                    _purchaseOrderController
                                                .purchaseOrder.value !=
                                            null
                                        ? "${_purchaseOrderController.purchaseOrder.value!.orderDate.day}/${_purchaseOrderController.purchaseOrder.value!.orderDate.month}/${_purchaseOrderController.purchaseOrder.value!.orderDate.year}"
                                        : 'No encontrado',
                                  )),
                              Obx(() => _buildDetailRow(
                                    'Fecha de despacho',
                                    _purchaseOrderController
                                                .purchaseOrder.value !=
                                            null
                                        ? "${_purchaseOrderController.purchaseOrder.value!.deliveryDate.day}/${_purchaseOrderController.purchaseOrder.value!.deliveryDate.month}/${_purchaseOrderController.purchaseOrder.value!.deliveryDate.year}"
                                        : 'No encontrado',
                                  )),
                              Obx(() => _buildDetailRow(
                                    'Monto de factura',
                                    _purchaseOrderController
                                                .purchaseOrder.value !=
                                            null
                                        ? "\$${(_purchaseOrderController.purchaseOrder.value!.totalIdpPurchaseOrder + _purchaseOrderController.purchaseOrder.value!.totalPurchaseOrder).toStringAsFixed(2)}"
                                        : '\$0.00',
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Detalle Factura',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigoAccent, // Color del título
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                  'Fecha de vencimiento', '25/12/2024'),
                              _buildDetailRow('Serie de factura', 'A001'),
                              _buildDetailRow('No. de factura', 'INV-12345'),
                              _buildDetailRow('Forma de pago', 'Transferencia'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Detalle Pago',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigoAccent, // Color del título
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('No. de Cheque', '1234567890'),
                              _buildDetailRow('Banco', 'Banco XYZ'),
                              _buildDetailRow('Monto Cheque', '\$500.00'),
                              _buildDetailRow(
                                  'No. documento cupones', 'CUP-2024'),
                              _buildDetailRow('Monto de cupones', '\$50.00'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isDeleteButtonEnabled
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Eliminando información...'),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDeleteButtonEnabled
                            ? Colors.red
                            : Colors.red.withOpacity(0.5),
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
                      onPressed: null, // Mantener siempre inhabilitado
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.5),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconColumn(IconData icon, String label, Color color,
      VoidCallback onPressed, bool isEnabled) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              onPressed();
            }
          : null,
      child: Column(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(isEnabled ? 0.1 : 0.05),
            ),
            child: Icon(
              icon,
              size: 30.0,
              color: color.withOpacity(isEnabled ? 1.0 : 0.5),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: isEnabled ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  void _showFacturaDialog() {
    TextEditingController serieController = TextEditingController();
    TextEditingController numeroFacturaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Detalles de Factura'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: serieController,
                    decoration:
                        const InputDecoration(labelText: 'Serie de factura'),
                  ),
                  TextField(
                    controller: numeroFacturaController,
                    decoration:
                        const InputDecoration(labelText: 'No. de Factura'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    // Guardar la información de la factura
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPagosDialog() {
    TextEditingController fechaVencimientoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Detalles de Pago'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Forma de pago'),
                      Switch(
                        value: isCredit,
                        onChanged: (value) {
                          setState(() {
                            isCredit = value;
                          });
                        },
                        activeColor: Colors.yellowAccent,
                        inactiveThumbColor: Colors.yellowAccent,
                        activeTrackColor: Colors.purple.shade300,
                        inactiveTrackColor: Colors.blueAccent,
                      ),
                      Text(isCredit ? 'Crédito' : 'Contado'),
                    ],
                  ),
                  TextField(
                    controller: fechaVencimientoController,
                    decoration: const InputDecoration(
                        labelText: 'Fecha de Vencimiento'),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          fechaVencimientoController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                    readOnly: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    // Guardar la información del pago
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBancosDialog() {
    TextEditingController numeroChequeController = TextEditingController();
    TextEditingController montoChequeController = TextEditingController();
    String selectedBanco = 'Banco A';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Detalles de Banco'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedBanco,
                    decoration: const InputDecoration(labelText: 'Banco'),
                    items: const [
                      DropdownMenuItem(
                          value: 'Banco A', child: Text('Banco A')),
                      DropdownMenuItem(
                          value: 'Banco B', child: Text('Banco B')),
                      DropdownMenuItem(
                          value: 'Banco C', child: Text('Banco C')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedBanco = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: numeroChequeController,
                    decoration:
                        const InputDecoration(labelText: 'No. de Cheque'),
                  ),
                  TextField(
                    controller: montoChequeController,
                    decoration:
                        const InputDecoration(labelText: 'Monto de Cheque'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    // Guardar la información del cheque
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCuponesDialog() {
    TextEditingController documentoController = TextEditingController();
    TextEditingController totalController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Detalles de Cupones'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: documentoController,
                    decoration:
                        const InputDecoration(labelText: 'No. de Documento'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Cantidad por denominación'),
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(100.0),
                      1: FixedColumnWidth(100.0),
                    },
                    children: [
                      _buildTableRow('10', 'Cantidad'),
                      _buildTableRow('20', 'Cantidad'),
                      _buildTableRow('50', 'Cantidad'),
                      _buildTableRow('100', 'Cantidad'),
                      _buildTableRow('200', 'Cantidad'),
                      _buildTableRow('250', 'Cantidad'),
                    ],
                  ),
                  TextField(
                    controller: totalController,
                    decoration: const InputDecoration(labelText: 'Total'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    // Guardar la información de cupones
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  TableRow _buildTableRow(String leftValue, String rightHint) {
    TextEditingController quantityController = TextEditingController();
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            leftValue,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: quantityController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: rightHint,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
