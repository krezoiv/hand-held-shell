import 'package:get/get.dart';
import 'package:hand_held_shell/models/models/fuel.station/fuel.model.dart';

import 'package:hand_held_shell/services/accounting/fuels/fuels.service.dart';

class FuelController extends GetxController {
  final RxList<Fuel> fuels = <Fuel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchFuels() async {
    try {
      isLoading.value = true;
      final response = await FuelService.getAllFuels();
      if (response != null && response.ok) {
        fuels.assignAll(response.fuels);
      } else {
        throw Exception('Failed to fetch fuels');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch fuels: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
