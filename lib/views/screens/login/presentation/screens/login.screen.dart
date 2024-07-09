import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: BackgroundForm(
          backgroundImage: 'assets/images/fondo_shell.jpeg',
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: size.height *
                        0.30), // Ajustable según el tamaño de la pantalla
                Container(
                  height: size.height *
                      0.80, // Ajustable según el tamaño de la pantalla
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100))),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height: constraints.maxHeight * 0.05),
                          //LogoLogin(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * 0.05),
                                child: const FormLogin(),
                              ),
                            ),
                          ),
                          const LabelLogin(ruta: 'licences'),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: constraints.maxHeight * 0.15),
                            child: const Text(
                              'Version 1.0 / 2024',
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
 @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
           -- child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LogoLogin(),
                  FormLogin(),
                  LabelLogin(ruta: 'licences'),
                  Text(
                    'Version 1.0 / 2024',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }

*/

