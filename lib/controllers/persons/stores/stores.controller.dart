import 'package:get/get.dart';

import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/persons/stores.service.dart';

class StoresController extends GetxController {
  final StroresService storesService = Get.put(StroresService());
  final RxList<Store> storesList = <Store>[].obs;
  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchAllStores();
  }

  void fetchAllStores() async {
    try {
      isLoading.value = true;
      final stores = await storesService.getAllStores();
      storesList.assignAll(stores);
    } catch (e) {
      Get.snackbar('Error', e.toString()); // Muestra el mensaje del backend
    } finally {
      isLoading.value = false;
    }
  }
}
