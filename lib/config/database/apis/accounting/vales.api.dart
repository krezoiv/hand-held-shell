import 'package:hand_held_shell/config/global/environment.dart';

class ValesApi {
  static String createValeApi = '${Environment.apiUrl}/vales/createVales';

  static String getValesApi =
      '${Environment.apiUrl}/vales/getValesSalesControl';

  static String deleteValeApi(String valeId) {
    return '${Environment.apiUrl}/vales/deleteVale/$valeId';
  }

  static String createVale() {
    return createValeApi;
  }

  static String getVales() {
    return getValesApi;
  }

  static String deleteVale(String valeId) {
    return deleteValeApi(valeId);
  }
}
