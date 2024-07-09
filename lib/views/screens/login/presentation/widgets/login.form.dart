import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/shared/helpers/show.alert.dart';
import 'package:hand_held_shell/shared/shared.exports.files.dart';

import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 20),
          CustomInput(
              icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailController),
          const SizedBox(height: 10),
          CustomInput(
              icon: Icons.lock_outline,
              placeholder: 'Contraseña',
              textController: passwordController,
              isPassword: true),
          const SizedBox(height: 20),
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
                      socketService.connect();

                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      //todo:mostrar mensaje de error
                      showAlert(context, 'Login incorrecto',
                          'Revise sus credenciales');
                    }
                  },
          ),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Crea una aquí'))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
