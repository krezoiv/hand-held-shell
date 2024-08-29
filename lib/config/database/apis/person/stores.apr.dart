import 'package:hand_held_shell/config/global/environment.dart';

class StoresApi {
  static String getStroresApi = '${Environment.apiUrl}/stores/getAllStores';

  static String getStores() {
    return getStroresApi;
  }
}
