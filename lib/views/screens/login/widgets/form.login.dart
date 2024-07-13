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
