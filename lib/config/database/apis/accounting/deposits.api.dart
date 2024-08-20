import 'package:hand_held_shell/config/global/environment.dart';

class DepositsApi {
  static String createDepositsApi =
      '${Environment.apiUrl}/deposits/createDeposits';

  static String getDepositsApi =
      '${Environment.apiUrl}/deposits/getDepositsSaleControl';

  static String deleteDepositApi(String depositId) {
    return '${Environment.apiUrl}/deposits/deleteDeposit/$depositId';
  }

  static String createDeposits() {
    return createDepositsApi;
  }

  static String getDeposits() {
    return getDepositsApi;
  }

  static String deleteDeposit(String depositId) {
    return deleteDepositApi(depositId);
  }
}
