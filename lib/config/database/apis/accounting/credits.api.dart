import 'package:hand_held_shell/config/global/environment.dart';

class CreditsApi {
  static String createCreditApi = '${Environment.apiUrl}/credits/createCredits';

  static String getCreditsApi =
      '${Environment.apiUrl}/credits/getCreditsSalesControl';

  static String deleteCreditApi(String creditId) {
    return '${Environment.apiUrl}/bills/deleteBill/$creditId';
  }

  static String createCredit() {
    return createCreditApi;
  }

  static String getCredits() {
    return getCreditsApi;
  }

  static String deleteCredit(String creditId) {
    return deleteCreditApi(creditId);
  }
}
