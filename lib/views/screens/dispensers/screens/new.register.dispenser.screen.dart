import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/screens/register.dispenser.page.screen.dart';

class NewRegisterDispenserScreen extends StatelessWidget {
  const NewRegisterDispenserScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    // Asegúrate de que el controlador esté inicializado
    Get.put(DispenserController());

    return Scaffold(
      body: const DispenserPageView(),
    );
  }
}

class DispenserPageView extends StatelessWidget {
  const DispenserPageView({Key? key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return GetBuilder<DispenserController>(
      init: DispenserController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return PageView.builder(
                controller: pageController,
                itemCount: controller.dispenserReaders.length,
                itemBuilder: (context, index) {
                  return RegisterDispenserPage(
                    pageIndex: index,
                    pageController: pageController,
                    dispenserReader: controller.dispenserReaders[index],
                    totalPages: controller.dispenserReaders
                        .length, // Usar el tamaño de la lista como totalPages
                  );
                },
              );
            }
          }),
        );
      },
    );
  }
}
