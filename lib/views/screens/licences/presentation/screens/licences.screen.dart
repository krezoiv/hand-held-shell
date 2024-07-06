import 'package:flutter/material.dart';

class LicencesScreen extends StatelessWidget {
  const LicencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Licencias: KZI Technologies'),
            GestureDetector(
              child: Text(
                'Regresar',
                style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context,
                    'login'); // Asegúrate de que '/ruta' es válida en tu configuración de rutas.
              },
            ),
          ],
        ),
      ),
    );
  }
}
