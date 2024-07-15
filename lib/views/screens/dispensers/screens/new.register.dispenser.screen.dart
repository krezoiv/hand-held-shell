import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/screens/register.dispenser.page.screen.dart';

class NewRegisterDispenserScreen extends StatelessWidget {
  const NewRegisterDispenserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final dispenserController = Get.put(DispenserController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Digitar Bombas'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.save),
        //     onPressed: () => dispenserController.saveAllData(),
        //   ),
        // ],
      ),
      body: const DispenserPageView(),
    );
  }
}

class DispenserPageView extends StatelessWidget {
  const DispenserPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final DispenserController controller = Get.find<DispenserController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return PageView.builder(
          controller: pageController,
          itemCount: controller.dispenserReaders.length,
          itemBuilder: (context, index) {
            return RegisterDispenserPage(
              pageIndex: index,
              mainPageController: pageController,
              dispenserReader: controller.dispenserReaders[index],
              totalPages: controller.dispenserReaders.length,
            );
          },
        );
      }
    });
  }
}
