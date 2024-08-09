import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/accounting/pos/pos.service.dart';

class PosController extends GetxController {
  final PosService posService = Get.put(PosService());

  final RxList<Pos> posList = <Pos>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPOS(); // Cargar todos los POS cuando el controlador se inicializa
  }

  void fetchAllPOS() async {
    try {
      isLoading.value = true;
      final pos = await posService.getAllPOS();
      posList.assignAll(pos);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los POS');
    } finally {
      isLoading.value = false;
    }
  }
}
