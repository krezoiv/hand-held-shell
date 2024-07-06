import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hand_held_shell/shared/helpers/show.alert.dart';
import 'package:hand_held_shell/services/auth/auth.service.dart';
import 'package:hand_held_shell/shared/shared.exports.files.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
              icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailController),
          CustomInput(
              icon: Icons.lock_outline,
              placeholder: 'Contraseña',
              textController: passwordController,
              isPassword: true),
          CustomButton(
            text: 'Ingresar',
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final correctLogin = await authService.login(
                        emailController.text.trim(),
                        passwordController.text.trim());

                    if (correctLogin) {
                      //todo: conecto to socket server
                      //todo:navegar a otra ruta
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      //todo:mostrar mensaje de error
                      showAlert(context, 'Login incorrecto',
                          'Revise sus credenciales');
                    }
                  },
          )
        ],
      ),
    );
  }
}
