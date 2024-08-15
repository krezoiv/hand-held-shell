import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/accounting/Bills/new.bill.response.dart';
import 'package:hand_held_shell/models/mappers/accounting/vales/list.vales.sales.control.response.dart';
import 'package:hand_held_shell/models/mappers/accounting/vales/new.vale.response.dart';
import 'package:hand_held_shell/services/accounting/vales/vales.service.dart';

class ValesController extends GetxController {
  final ValessService _valesService = ValessService();
  final Rx<NewValesResponse?> newVoucherResponse = Rx<NewValesResponse?>(null);
  final Rx<GetValesListSaleControlResponse?> valesListResponse =
      Rx<GetValesListSaleControlResponse?>(null);
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
}
