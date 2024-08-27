import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/accounting/Bills/new.bill.response.dart';
import 'package:hand_held_shell/models/mappers/accounting/vales/list.vales.sales.control.response.dart';
import 'package:hand_held_shell/models/mappers/accounting/vales/new.vale.response.dart';
import 'package:hand_held_shell/services/accounting/vales/vales.service.dart';

class ValesController extends GetxController {
  final ValessService _valesService = ValessService();
  final Rx<NewBillsResponse?> newVoucherResponse = Rx<NewBillsResponse?>(null);
  final Rx<GetValesListSaleControlResponse?> valesListResponse =
      Rx<GetValesListSaleControlResponse?>(null);
  final Rx<NewValeResponse?> newValeResponse = Rx<NewValeResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<bool> createVale({
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e.toString().contains('Ya existe un vale con este número')) {
        Get.snackbar('Error', 'Ya existe una vale con este número');
      } else {
        Get.snackbar(
            'Error', 'Ocurrió un error al crear el vale: ${e.toString()}');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchValesBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _valesService.getValesSalesControl();

      if (response != null && response.ok && response.vales.isNotEmpty) {
        valesListResponse.value = response;
        Get.snackbar('Éxito', 'Vales obtenidas exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar('Error', 'Error en la respuesta: ${response.vales}');
      } else {
        Get.snackbar('Error', 'No se encontraron los vales');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al obtener los vales: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteVale(String billId) async {
    try {
      isLoading.value = true;
      final success = await _valesService.deleteVale(billId);

      if (success) {
        // Get.snackbar('Éxito', 'Vale eliminado exitosamente');
        return true;
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el vale');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al eliminar el vale: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
