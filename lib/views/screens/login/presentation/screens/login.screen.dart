import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/login.controller.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: BackgroundForm(
          backgroundImage: 'assets/images/fondo_shell.jpeg',
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.30),
                Container(
                  height: Get.height * 0.80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Get.theme.scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
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
                                child: FormLogin(),
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


// import 'package:flutter/material.dart';
// import 'package:hand_held_shell/views/screens/screens.exports.files.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: Scaffold(
//         backgroundColor: const Color(0xffF2F2F2),
//         body: BackgroundForm(
//           backgroundImage: 'assets/images/fondo_shell.jpeg',
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                     height: size.height *
//                         0.30), // Ajustable según el tamaño de la pantalla
//                 Container(
//                   height: size.height *
//                       0.80, // Ajustable según el tamaño de la pantalla
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       color: scaffoldBackgroundColor,
//                       borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(100))),
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           SizedBox(height: constraints.maxHeight * 0.05),
//                           //LogoLogin(),
//                           Expanded(
//                             child: SingleChildScrollView(
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: constraints.maxWidth * 0.05),
//                                 child: FormLogin(),
//                               ),
//                             ),
//                           ),
//                           const LabelLogin(ruta: 'licences'),
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 bottom: constraints.maxHeight * 0.15),
//                             child: const Text(
//                               'Version 1.0 / 2024',
//                               style: TextStyle(fontWeight: FontWeight.w200),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
