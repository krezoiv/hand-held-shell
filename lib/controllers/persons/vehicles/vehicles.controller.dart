import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/persons/vehicle.service.dart';

class VechicleController extends GetxController {
  final VehicleService vehicleService = Get.put(VehicleService());
  final RxList<Vehicle> vehiclesList = <Vehicle>[].obs;
  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchAllVehicles();
  }

  void fetchAllVehicles() async {
    try {
      isLoading.value = true;
      final vehicles = await vehicleService.getAllVehicles();
      vehiclesList.assignAll(vehicles);
    } catch (e) {
      Get.snackbar('Error', e.toString()); // Muestra el mensaje del backend
    } finally {
      isLoading.value = false;
    }
  }
}
