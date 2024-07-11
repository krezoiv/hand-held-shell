import 'package:hand_held_shell/config/global/environment.dart';

class UserApi {
  static String getUserApi = ('${Environment.apiUrl}/user');

  static String getUser() {
    return getUserApi;
  }
}
