import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/accounting/Bills/new.bill.response.dart';
import 'package:hand_held_shell/services/accounting/bills/bills.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class BillsController extends GetxController {
  final BillsService _billsService = BillsService();

  final Rx<NewValesResponse?> newBillResponse = Rx<NewValesResponse?>(null);
  final Rx<GetBillsListSaleControlResponse?> billsListResponse =
      Rx<GetBillsListSaleControlResponse?>(null);
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

  Future<void> fetchBillsBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _billsService.getBillsBySalesControl();

      if (response != null && response.ok && response.bills.isNotEmpty) {
        billsListResponse.value = response;
        // Get.snackbar('Éxito', 'Facturas obtenidas exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar('Error', 'Error en la respuesta: ${response.bills}');
      } else {
        Get.snackbar('Error', 'No se encontraron facturas');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al obtener las facturas: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
