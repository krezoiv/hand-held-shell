import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/credits/new.credit.response.dart';
import 'package:hand_held_shell/services/accounting/credits/credits.service.dart';

class CreditsController extends GetxController {
  final CreditsService _creditService = CreditsService();

  final Rx<NewCreditResponse?> newCreditsResponse =
      Rx<NewCreditResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<bool> createCredit({
    required int creditNumber,
    required num creditAmount,
    required DateTime creditDate,
    required num regularAmount,
    required num superAmount,
    required num dieselAmount,
    required String clientId,
  }) async {
    try {
      isLoading.value = true;
      final response = await _creditService.createCredit(
        creditNumber: creditNumber,
        creditAmount: creditAmount,
        creditDate: creditDate,
        regularAmount: regularAmount,
        superAmount: superAmount,
        dieselAmount: dieselAmount,
        clientId: clientId,
      );

      if (response != null && response.ok) {
        newCreditsResponse.value = response;
        // Get.snackbar('Éxito', 'Cupón creado exitosamenteeee');
      }

      return true;
    } catch (e) {
      Get.snackbar(
          'Error', 'Ocurrió un error al crear el crédito: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
