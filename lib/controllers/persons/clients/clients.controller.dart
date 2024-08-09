import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/persons/cliente.service.dart';

class ClientsController extends GetxController {
  final ClientService clientService = Get.put(ClientService());
  final RxList<Client> clientsList = <Client>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllClients();
  }

  void fetchAllClients() async {
    try {
      isLoading.value = true;
      final client = await clientService.getAllBanks();
      clientsList.assignAll(client);
    } catch (e) {
      Get.snackbar('Error', e.toString()); // Muestra el mensaje del backend
    } finally {
      isLoading.value = false;
    }
  }
}
