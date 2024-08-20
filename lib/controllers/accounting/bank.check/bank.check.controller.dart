import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/mappers/accounting/banks/list.bank.checks.sales.control.dart';
import 'package:hand_held_shell/services/accounting/banks/bank.check.service.dart';

class BankCheckController extends GetxController {
  final BankCheckService _bankCheckService = BankCheckService();

  final Rx<NewBankCheckResponse?> newBankCheckResponse =
      Rx<NewBankCheckResponse?>(null);

  final Rx<GetBankChecksListSaleControlResponse?> bankCheckListResponse =
      Rx<GetBankChecksListSaleControlResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<void> createBankCheck({
    required int checkNumber,
    required num checkValue,
    required DateTime checkDate,
    required String bankId,
    required String clientId,
  }) async {
    try {
      isLoading.value = true;
      final response = await _bankCheckService.createBankCheck(
        checkNumber: checkNumber,
        checkValue: checkValue,
        checkDate: checkDate,
        bankId: bankId,
        clientId: clientId,
      );

      if (response != null && response.ok) {
        newBankCheckResponse.value = response;
        Get.snackbar('Éxito', 'Cheque bancario creado exitosamente');
      }
    } catch (e) {
      Get.snackbar('Error',
          'Ocurrió un error al crear el cheque bancario: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBankCheckBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _bankCheckService.getbankChecksSalesControl();

      if (response != null && response.ok && response.bankCheck.isNotEmpty) {
        bankCheckListResponse.value = response;
        // Get.snackbar('Éxito', 'Cheques obtenidos exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar('Error', 'Error en la respuesta: ${response.bankCheck}');
      } else {
        Get.snackbar('Error', 'No se encontraron los cheques');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al obtener los cheques: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteBankCheck(String bankCheckId) async {
    try {
      isLoading.value = true;
      final success = await _bankCheckService.deleteBankCheck(bankCheckId);

      if (success) {
        return true;
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el cheque');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al eliminar el cheque: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
