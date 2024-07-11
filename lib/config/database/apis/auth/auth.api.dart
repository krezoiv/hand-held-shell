import 'package:hand_held_shell/config/global/environment.dart';

class AuthApi {
  static String loginApi = '${Environment.apiUrl}/login';
  static String loginRenewTokenApi = '${Environment.apiUrl}/login/renew';

  static String login() {
    return loginApi;
  }

  static String renewToken() {
    return loginRenewTokenApi;
  }
}
