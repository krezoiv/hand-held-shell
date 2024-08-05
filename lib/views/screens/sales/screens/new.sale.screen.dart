import 'package:flutter/material.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/sales/widgets/side.menu.sale.dart';

class NewSalesScreen extends StatelessWidget {
  const NewSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Cuadre DLP'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón de guardar
              },
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
      drawer: SideMenuSale(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
      body: Column(
        children: [
          buildCardSummary(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildCardInformation(),
                  const SizedBox(height: 16),
                  buildCardPayments(),
                  const SizedBox(height: 100), // Añadir más espacio al final
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        shadowColor: Colors.blue,
        child: InkWell(
          onTap: () {
            // Acción al presionar el Card Summary
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Fecha: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Venta:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Pagos:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Saldo:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('valueA'),
                    Text('valueB'),
                    Text('valueC'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        shadowColor: Colors.blue,
        child: InkWell(
          onTap: () {
            // Acción al presionar el Card Information
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text('Informacion',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Regular'),
                    Text('Super'),
                    Text('Diesel'),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(),
                const SizedBox(height: 8),
                Text('Precios',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('precioRegular'),
                    Text('precioSuper'),
                    Text('precioDiesel'),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(),
                const SizedBox(height: 8),
                Text('Ventas',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('ventaRegular'),
                    Text('ventaSuper'),
                    Text('ventaDiesel'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardPayments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        shadowColor: Colors.blue,
        child: InkWell(
          onTap: () {
            // Acción al presionar el Card Payments
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text('Payments',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                buildTextFieldRow('bills', 'vales'),
                buildTextFieldRow('cupones', 'vouchers'),
                buildTextFieldRow('deposits', 'credits'),
                buildTextFieldRow('depositSlip', 'bankCheck'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldRow(String labelA, String labelB) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                labelText: labelA,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                labelText: labelB,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabelWithValue(String label, String value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Text(value),
      ],
    );
  }
}
