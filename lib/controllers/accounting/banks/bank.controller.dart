import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class BankController extends GetxController {
  final BanksService bankService = Get.put(BanksService());
  final RxList<Bank> bankList = <Bank>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllBanks();
  }

  void fetchAllBanks() async {
    try {
      isLoading.value = true;
      final banks = await bankService.getAllBanks();
      bankList.assignAll(banks);
    } catch (e) {
      Get.snackbar('Error', e.toString()); // Muestra el mensaje del backend
    } finally {
      isLoading.value = false;
    }
  }
}
