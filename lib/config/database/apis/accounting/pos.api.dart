import 'package:hand_held_shell/config/global/environment.dart';

class PosApi {
  static String getPosApi = '${Environment.apiUrl}/pos/getAllPos';

  static String getPos() {
    return getPosApi;
  }
}
