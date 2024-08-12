import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/accounting/vales/new.vale.response.dart';
import 'package:hand_held_shell/services/accounting/vales/vales.service.dart';

class ValesController extends GetxController {
  final ValessService _valesService = ValessService();

  final Rx<NewValeResponse?> newValeResponse = Rx<NewValeResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<void> createVale({
    required String valeNumber,
    required DateTime valeDate,
    required num valeAmount,
    required String valeDescription,
  }) async {
    try {
      isLoading.value = true;
      final response = await _valesService.createVale(
        valeNumber: valeNumber,
        valeDate: valeDate,
        valeAmount: valeAmount,
        valeDescription: valeDescription,
      );

      if (response != null && response.ok) {
        newValeResponse.value = response;
        Get.snackbar('Éxito', 'Vale creado exitosamente');
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Ocurrió un error al crear el vale: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
