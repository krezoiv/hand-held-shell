import 'package:hand_held_shell/config/global/environment.dart';

class ClientsApi {
  static String getClientsApi = '${Environment.apiUrl}/clients/getAllClients';

  static String getClients() {
    return getClientsApi;
  }
}
