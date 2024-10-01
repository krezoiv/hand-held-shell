import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/accounting/banks/bank.controller.dart';
import 'package:hand_held_shell/controllers/purchases/orders/purchase.order.controller.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/shop/widgets/side.menu.shop.dart';

class NewShopsScreen extends StatefulWidget {
  NewShopsScreen({super.key});

  final NewShopsController controller = Get.put(NewShopsController());

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
                                    'purchaseOrderID',
                                    _purchaseOrderController.purchaseOrder.value
                                            ?.purchaseOrderId ??
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Detalle Factura',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigoAccent,
                            ),
                          ),
                          Obx(
                            () => widget.controller.isFacturaComplete
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
                              // Muestra la fecha de vencimiento desde el controlador
                              Obx(() => _buildDetailRow('Fecha de vencimiento',
                                  widget.controller.fechaVencimiento.value)),

                              // Muestra la serie de factura desde el controlador
                              Obx(() => _buildDetailRow('Serie de factura',
                                  widget.controller.serieFactura.value)),

                              // Muestra el número de factura desde el controlador
                              Obx(() => _buildDetailRow('No. de factura',
                                  widget.controller.numeroFactura.value)),

                              // Muestra la forma de pago desde el controlador
                              Obx(() => _buildDetailRow('Forma de pago',
                                  widget.controller.formaDePago.value)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Detalle Pago',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigoAccent,
                            ),
                          ),
                          Obx(
                            () => widget.controller.isCuponesComplete
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
                              // Muestra el número de cheque desde el controlador
                              Obx(() => _buildDetailRow('No. de Cheque',
                                  widget.controller.numeroCheque.value)),

                              // Muestra el banco desde el controlador
                              Obx(() => _buildDetailRow(
                                  'Banco', widget.controller.banco.value)),

                              // Muestra el monto de cheque desde el controlador
                              Obx(() => _buildDetailRow('Monto Cheque',
                                  widget.controller.montoCheque.value)),

                              // Muestra el número de documento de cupones desde el controlador
                              Obx(() => _buildDetailRow('No. documento cupones',
                                  widget.controller.documentoCupones.value)),

                              // Muestra el monto de cupones desde el controlador
                              Obx(() => _buildDetailRow('Monto de cupones',
                                  widget.controller.montoCupones.value)),
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
    TextEditingController serieController =
        TextEditingController(text: widget.controller.serieFactura.value);
    TextEditingController numeroFacturaController =
        TextEditingController(text: widget.controller.numeroFactura.value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                decoration: const InputDecoration(labelText: 'No. de Factura'),
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
                setState(() {
                  widget.controller.updateFacturaDetails(
                      serieController.text, numeroFacturaController.text);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showPagosDialog() {
    TextEditingController fechaVencimientoController =
        TextEditingController(text: widget.controller.fechaVencimiento.value);

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
                    // Guardar la información del pago en el controlador
                    setState(() {
                      widget.controller
                          .updateFormaDePago(isCredit ? 'Crédito' : 'Contado');
                      widget.controller.updateFechaVencimiento(
                          fechaVencimientoController.text);
                    });
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
    // Controladores de texto
    TextEditingController numeroChequeController =
        TextEditingController(text: widget.controller.numeroCheque.value);
    TextEditingController montoChequeController =
        TextEditingController(text: widget.controller.montoCheque.value);

    // Controlador de bancos (BankController)
    final BankController bankController = Get.put(BankController());

    // Valor inicial del banco seleccionado
    String selectedBanco = widget.controller.banco.value.isNotEmpty
        ? widget.controller.banco.value
        : '';

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
                  // Obx para observar la lista de bancos mientras se carga
                  Obx(() {
                    if (bankController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (bankController.bankList.isEmpty) {
                      return const Text("No se encontraron bancos.");
                    } else {
                      // Asegurarse de que el valor seleccionado esté presente en la lista de bancos
                      if (!bankController.bankList
                          .any((bank) => bank.bankName == selectedBanco)) {
                        selectedBanco =
                            ''; // Opción predeterminada si no coincide
                      }

                      return DropdownButtonFormField<String>(
                        value: selectedBanco.isNotEmpty ? selectedBanco : null,
                        decoration: const InputDecoration(labelText: 'Banco'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('Selecciona un banco'),
                          ),
                          ...bankController.bankList.map((bank) {
                            return DropdownMenuItem<String>(
                              value: bank.bankName,
                              child: Text(bank.bankName),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedBanco = value ?? '';
                          });
                        },
                      );
                    }
                  }),
                  const SizedBox(height: 10),
                  TextField(
                    controller: numeroChequeController,
                    decoration: const InputDecoration(
                      labelText: 'No. de Cheque',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: montoChequeController,
                    decoration: const InputDecoration(
                      labelText: 'Monto de Cheque',
                      border: OutlineInputBorder(),
                    ),
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
                ElevatedButton(
                  onPressed: () {
                    // Guardar la información del banco en el controlador
                    setState(() {
                      widget.controller.updateBancoDetails(
                        selectedBanco,
                        numeroChequeController.text,
                        montoChequeController.text,
                      );
                    });
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
    TextEditingController documentoController =
        TextEditingController(text: widget.controller.documentoCupones.value);
    TextEditingController totalController =
        TextEditingController(text: widget.controller.montoCupones.value);

    // Controladores para cada denominación
    TextEditingController cantidad10Controller = TextEditingController();
    TextEditingController cantidad20Controller = TextEditingController();
    TextEditingController cantidad50Controller = TextEditingController();
    TextEditingController cantidad100Controller = TextEditingController();
    TextEditingController cantidad200Controller = TextEditingController();
    TextEditingController cantidad250Controller = TextEditingController();

    // Función para calcular el total
    void calcularTotal() {
      double total = 0.0;

      total += (10 * (double.tryParse(cantidad10Controller.text) ?? 0));
      total += (20 * (double.tryParse(cantidad20Controller.text) ?? 0));
      total += (50 * (double.tryParse(cantidad50Controller.text) ?? 0));
      total += (100 * (double.tryParse(cantidad100Controller.text) ?? 0));
      total += (200 * (double.tryParse(cantidad200Controller.text) ?? 0));
      total += (250 * (double.tryParse(cantidad250Controller.text) ?? 0));

      setState(() {
        totalController.text =
            total.toStringAsFixed(2); // Actualiza el total con el resultado
      });
    }

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
                    decoration: InputDecoration(
                      labelText: 'No. de Documento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Denominacion x Cantidad',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(
                          1), // Columna más pequeña para la denominación
                      1: FlexColumnWidth(
                          3), // Columna más grande para los TextFields
                    },
                    children: [
                      _buildTableRow('10', cantidad10Controller, calcularTotal),
                      _buildTableRow('20', cantidad20Controller, calcularTotal),
                      _buildTableRow('50', cantidad50Controller, calcularTotal),
                      _buildTableRow(
                          '100', cantidad100Controller, calcularTotal),
                      _buildTableRow(
                          '200', cantidad200Controller, calcularTotal),
                      _buildTableRow(
                          '250', cantidad250Controller, calcularTotal),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: totalController,
                    decoration: InputDecoration(
                      labelText: 'Total',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    readOnly: true, // Hace que el campo sea solo de lectura
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
                    // Guardar la información de cupones en el controlador
                    setState(() {
                      widget.controller.updateCuponesDetails(
                        documentoController.text,
                        totalController.text,
                      );
                    });
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

// Método modificado _buildTableRow
  TableRow _buildTableRow(
    String denominacion,
    TextEditingController cantidadController,
    Function calcularTotal,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              denominacion,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: cantidadController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: 'Cantidad',
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ), // Aumenta el tamaño interno del TextField
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              calcularTotal(); // Llama a la función para calcular el total
            },
          ),
        ),
      ],
    );
  }
}

class NewShopsController extends GetxController {
  var serieFactura = ''.obs;
  var numeroFactura = ''.obs;
  var formaDePago = ''.obs;
  var fechaVencimiento = ''.obs;

  var banco = ''.obs;
  var numeroCheque = ''.obs;
  var montoCheque = ''.obs;

  var documentoCupones = ''.obs;
  var montoCupones = '0.00'.obs;

  void updateFacturaDetails(String serie, String numero) {
    serieFactura.value = serie;
    numeroFactura.value = numero;
  }

  void updateFormaDePago(String formaDePagoValue) {
    formaDePago.value = formaDePagoValue;
  }

  void updateFechaVencimiento(String fecha) {
    fechaVencimiento.value = fecha;
  }

  void updateBancoDetails(
      String bancoValue, String numeroChequeValue, String montoChequeValue) {
    banco.value = bancoValue;
    numeroCheque.value = numeroChequeValue;
    montoCheque.value = montoChequeValue;
  }

  void updateCuponesDetails(String documento, String monto) {
    documentoCupones.value = documento;
    montoCupones.value = monto;
  }

  // Verifica si todos los campos de Detalle Factura están llenos
  bool get isFacturaComplete {
    return serieFactura.value.isNotEmpty &&
        numeroFactura.value.isNotEmpty &&
        formaDePago.value.isNotEmpty &&
        fechaVencimiento.value.isNotEmpty;
  }

  // Verifica si todos los campos de Detalle Pago están llenos
  bool get isPagoComplete {
    return banco.value.isNotEmpty &&
        numeroCheque.value.isNotEmpty &&
        montoCheque.value.isNotEmpty;
  }

  // Verifica si todos los campos de Detalle Cupones están llenos
  bool get isCuponesComplete {
    return documentoCupones.value.isNotEmpty && montoCupones.value.isNotEmpty;
  }
}

//2096582