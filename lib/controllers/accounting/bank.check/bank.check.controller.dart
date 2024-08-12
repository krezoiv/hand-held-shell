import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/accounting/banks/bank.check.service.dart';

class BankCheckController extends GetxController {
  final BankCheckService _bankCheckService = BankCheckService();

  final Rx<NewBankCheckResponse?> newBankCheckResponse =
      Rx<NewBankCheckResponse?>(null);
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
}
