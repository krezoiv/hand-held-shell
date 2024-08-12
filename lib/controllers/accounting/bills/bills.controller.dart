import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/accounting/Bills/new.bill.response.dart';
import 'package:hand_held_shell/services/accounting/bills/bills.service.dart';

class BillsController extends GetxController {
  final BillsService _billsService = BillsService();

  final Rx<NewValesResponse?> newBillResponse = Rx<NewValesResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<void> createBill({
    required String billNumber,
    required DateTime billDate,
    required num billAmount,
    required String billDescription,
  }) async {
    try {
      isLoading.value = true;
      final response = await _billsService.createBill(
        billNumber: billNumber,
        billDate: billDate,
        billAmount: billAmount,
        billDescription: billDescription,
      );

      if (response != null && response.ok) {
        newBillResponse.value = response;
        Get.snackbar('Éxito', 'Gasto creado exitosamente');
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Ocurrió un error al crear el gasto: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
