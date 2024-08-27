import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/credits/list.credits.sales.control.response.dart';
import 'package:hand_held_shell/models/mappers/credits/new.credit.response.dart';
import 'package:hand_held_shell/services/accounting/credits/credits.service.dart';

class CreditsController extends GetxController {
  final CreditsService _creditService = CreditsService();

  final Rx<NewCreditResponse?> newCreditsResponse =
      Rx<NewCreditResponse?>(null);

  final Rx<GetCreditsListSaleControlResponse?> creditsListResponse =
      Rx<GetCreditsListSaleControlResponse?>(null);
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
        Get.snackbar('Éxito', 'Crédito creado exitosamente');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e.toString().contains('Ya existe una crédito con este número')) {
        Get.snackbar('Error', 'Ya existe una crédito con este número');
      } else {
        Get.snackbar(
            'Error', 'Ocurrió un error al crear el crédito: ${e.toString()}');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCreditsBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _creditService.getCreditsSalesControl();

      if (response != null && response.ok && response.credits.isNotEmpty) {
        creditsListResponse.value = response;
        Get.snackbar('Éxito', 'Créditos obtenidos exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar('Error', 'Error en la respuesta: ${response.credits}');
      } else {
        Get.snackbar('Error', 'No se encontraron los créditos');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al obtener los créditos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCredit(String creditId) async {
    try {
      isLoading.value = true;
      final success = await _creditService.deleteCredit(creditId);

      if (success) {
        Get.snackbar('Éxito', 'Crédito eliminado exitosamente');
        return true;
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el crédito');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al eliminar el crédito: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
