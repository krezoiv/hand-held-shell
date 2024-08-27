import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/mappers/accounting/deposits/list.deposits.sales.control.response.dart';
import 'package:hand_held_shell/services/accounting/deposits/deposits.seervice.dart';

class DepositsController extends GetxController {
  final DepositsService _depostisService = DepositsService();
  final Rx<NewDepositsResponse?> newDepositsResponse =
      Rx<NewDepositsResponse?>(null);
  final Rx<GetDepositsListSaleControlResponse?> depositsitsListResponse =
      Rx<GetDepositsListSaleControlResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<bool> createDeposits({
    required int depositNumber,
    required num depositAmount,
    required DateTime depositDate,
    required String bankId,
  }) async {
    try {
      isLoading.value = true;
      final response = await _depostisService.createDeposits(
        depositNumber: depositNumber,
        depositAmount: depositAmount,
        depositDate: depositDate,
        bankId: bankId,
      );

      if (response != null && response.ok) {
        newDepositsResponse.value = response;
        Get.snackbar('Éxito', 'Depósito creado exitosamente');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e.toString().contains('Ya existe una depósito con este número')) {
        Get.snackbar('Error', 'Ya existe una depósito con este número');
      } else {
        Get.snackbar(
            'Error', 'Ocurrió un error al crear el depósito: ${e.toString()}');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDepositsBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _depostisService.getDepositsSalesControl();

      if (response != null && response.ok && response.deposits.isNotEmpty) {
        depositsitsListResponse.value = response;
        // Get.snackbar('Éxito', 'Depósitos obtenidos exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar('Error', 'Error en la respuesta: ${response.deposits}');
      } else {
        Get.snackbar('Error', 'No se encontraron los depósitos');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al obtener los depósitos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteDeposit(String creditId) async {
    try {
      isLoading.value = true;
      final success = await _depostisService.deleteDeposit(creditId);

      if (success) {
        Get.snackbar('Éxito', 'Depósito eliminado exitosamente');
        return true;
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el depósito');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al eliminar el depósito: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
