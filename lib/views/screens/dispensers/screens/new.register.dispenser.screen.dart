import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/shared/widgets/custom.bottom.navigation.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';

class NewRegisterDispenserScreen extends StatelessWidget {
  const NewRegisterDispenserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Nuevo Registro'),
      ),
      body: Container(
        //color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Ingrese numeración de la bomba',
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              // Acción cuando se presiona el botón
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors
                                  .deepPurpleAccent, // Color de fondo morado
                              elevation: 5, // Añadir sombra
                              shadowColor: Colors.deepPurpleAccent
                                  .withOpacity(0.5), // Color de la sombra
                            ),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.arrowshape_turn_up_left,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Espacio entre los botones
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              // Acción cuando se presiona el botón
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.red[400], // Color de fondo rojo
                              elevation: 5, // Añadir sombra
                              shadowColor: Colors.red[400]!
                                  .withOpacity(0.5), // Color de la sombra
                            ),
                            child: Center(
                              child: Icon(Icons.clear),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Espacio entre los botones
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              // Acción cuando se presiona el botón
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.green[600], // Color de fondo verde
                              elevation: 5, // Añadir sombra
                              shadowColor: Colors.green[600]!
                                  .withOpacity(0.5), // Color de la sombra
                            ),
                            child: Center(
                              child: Icon(Icons.save_outlined),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Espacio entre los botones
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              // Acción cuando se presiona el botón
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors
                                  .deepPurpleAccent, // Color de fondo morado
                              elevation: 5, // Añadir sombra
                              shadowColor: Colors.deepPurpleAccent
                                  .withOpacity(0.5), // Color de la sombra
                            ),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.arrowshape_turn_up_right,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
