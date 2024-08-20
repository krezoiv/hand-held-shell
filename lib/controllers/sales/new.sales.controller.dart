import 'package:get/get.dart';
import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';
import 'package:hand_held_shell/services/sales/sales.control.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class SalesControlController extends GetxController {
  final SalesControlService _salesControlService =
      Get.put(SalesControlService());

  final Rx<SalesControl?> salesControl = Rx<SalesControl?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSummaryCardEnabled = true.obs;

  Future<bool> createNewSalesControl() async {
    try {
      isLoading.value = true;

      // Obtener el token y el userName desde el almacenamiento seguro
      final String? token = await AuthService.getToken();
      final String? userName = await AuthService.getFirstName();

      if (token == null || userName == null) {
        throw Exception('Token or Username is null');
      }

      // Crear un mapa con los datos necesarios
      final Map<String, dynamic> requestBody = {
        'userName': userName,
      };

      // Llamar al servicio para crear el SalesControl en el backend
      final response =
          await _salesControlService.createSalesControl(requestBody, token);

      // Actualizar el estado de salesControl y mostrar un mensaje de éxito
      salesControl.value = response.salesControl;
      Get.snackbar('Success', response.message);

      // Deshabilitar el summary card
      isSummaryCardEnabled.value = false;

      return true; // Retornar true si todo sale bien
    } catch (e) {
      // Mostrar un mensaje de error en caso de falla
      //Get.snackbar('Error', e.toString());
      Get.offAllNamed('/sales');

      return false; // Retornar false en caso de error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSalesControl(Map<String, dynamic> requestBody) async {
    try {
      isLoading.value = true;

      final String? token = await AuthService.getToken();

      if (token == null) {
        throw Exception('Token is null');
      }

      final response =
          await _salesControlService.updateLastSalesControl(requestBody, token);

      salesControl.value = response.salesControl;
      Get.snackbar('Success', response.message);
    } catch (e) {
      //  Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
