import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/login.controller.dart';

import 'package:hand_held_shell/shared/shared.exports.files.dart';

class FormLogin extends GetView<LoginController> {
  const FormLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: controller.emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: controller.passwordController,
            isPassword: true,
          ),
          Obx(() => CustomButton(
                text: 'Ingresar',
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        controller.login();
                      },
              )),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:hand_held_shell/services/services.exports.files.dart';
// import 'package:hand_held_shell/shared/helpers/show.alert.dart';
// import 'package:hand_held_shell/shared/shared.exports.files.dart';

// class FormLogin extends StatefulWidget {
//   const FormLogin({super.key});

//   @override
//   State<FormLogin> createState() => _FormLoginState();
// }

// class _FormLoginState extends State<FormLogin> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     final socketService = Provider.of<SocketService>(context);

//     return Container(
//       margin: const EdgeInsets.only(top: 70),
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         children: <Widget>[
//           CustomInput(
//               icon: Icons.mail_outline,
//               placeholder: 'Emailsss',
//               keyboardType: TextInputType.emailAddress,
//               textController: emailController),
//           CustomInput(
//               icon: Icons.lock_outline,
//               placeholder: 'Contraseña',
//               textController: passwordController,
//               isPassword: true),
//           CustomButton(
//             text: 'Ingresar',
//             onPressed: authService.autenticando
//                 ? null
//                 : () async {
//                     FocusScope.of(context).unfocus();
//                     final correctLogin = await authService.login(
//                         emailController.text.trim(),
//                         passwordController.text.trim());

//                     if (correctLogin) {
//                       socketService.connect();

//                       Navigator.pushReplacementNamed(context, 'users');
//                     } else {
//                       //todo:mostrar mensaje de error
//                       showAlert(context, 'Login incorrecto',
//                           'Revise sus credenciales');
//                     }
//                   },
//           )
//         ],
//       ),
//     );
//   }
// }
