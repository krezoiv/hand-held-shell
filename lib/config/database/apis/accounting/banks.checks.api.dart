import 'package:hand_held_shell/config/global/environment.dart';

class BanksChecksApi {
  static String createBankCheckApi =
      '${Environment.apiUrl}/bankCheck/createBankCheck';

  static String getBankCheckApi =
      '${Environment.apiUrl}/bankCheck/getBankChecksSalesControl';

  static String deleteBankCheckApi(String bankCheckId) {
    return '${Environment.apiUrl}/bankCheck/deleteBankCheck/$bankCheckId';
  }

  static String createBankCheck() {
    return createBankCheckApi;
  }

  static String getBankCheck() {
    return getBankCheckApi;
  }

  static String deleteBankCheck(String bankCheckId) {
    return deleteBankCheckApi(bankCheckId);
  }
}
