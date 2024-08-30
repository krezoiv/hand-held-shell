import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/fuel.station/update.fuel.price.response.dart';
import 'package:hand_held_shell/models/models/fuel.station/fuel.model.dart';
import 'package:hand_held_shell/services/accounting/fuels/fuels.service.dart';

class FuelController extends GetxController {
  final RxList<Fuel> fuels = <Fuel>[].obs;
  final FuelService fuelService =
      Get.put(FuelService()); // Aquí se instancia correctamente
  Rx<UpdateFuelPriceResponse?> updateFuelPriceResponse =
      Rx<UpdateFuelPriceResponse?>(null);
  final RxBool isLoading = false.obs;

  // Añadir variable para guardar los Fuel IDs
  final RxMap<String, String> fuelIds = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFuelIds(); // Llama al método para obtener los Fuel IDs al iniciar
  }

  Future<void> fetchFuels() async {
    try {
      isLoading.value = true;
      final response = await FuelService.getAllFuels();
      if (response != null && response.ok) {
        fuels.assignAll(response.fuels);
      } else {
        throw Exception('Failed to fetch fuels');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch fuels: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Nuevo método para obtener los Fuel IDs
  Future<void> fetchFuelIds() async {
    try {
      isLoading.value = true;
      final ids = await FuelService.getFuelIds();
      if (ids != null) {
        fuelIds.assignAll(ids);
      } else {
        throw Exception('Failed to fetch fuel IDs');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch fuel IDs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFuelPrices({
    required num regularPrice,
    required num superPrice,
    required num dieselPrice,
  }) async {
    try {
      isLoading.value = true;
      updateFuelPriceResponse.value = await fuelService.updateFuelPrices(
        regularPrice: regularPrice,
        superPrice: superPrice,
        dieselPrice: dieselPrice,
      );

      if (updateFuelPriceResponse.value != null &&
          updateFuelPriceResponse.value!.ok) {
        Get.snackbar('Éxito', 'Precios actualizados correctamente');
      } else {
        Get.snackbar('Error', 'No se pudo actualizar los precios');
      }
    } catch (e) {
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
