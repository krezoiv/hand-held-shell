import 'package:hand_held_shell/config/global/environment.dart';

class BanksApi {
  static String getBanksApi = '${Environment.apiUrl}/banks/getAllBanks';

  static String getBanks() {
    return getBanksApi;
  }
}
