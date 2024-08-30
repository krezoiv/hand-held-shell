import 'package:hand_held_shell/config/global/environment.dart';

class FuelsApi {
  static String getFuelsApi = '${Environment.apiUrl}/fuels/getFuels';

  static String updateFuelPricesApi =
      '${Environment.apiUrl}/fuels/updatePrices';

  static String deleteDepositApi(String depositId) {
    return '${Environment.apiUrl}/fuels/updatePrices';
  }

  static String getFuelsIdsApi = '${Environment.apiUrl}/fuels/fuelIds';

  static String getFuels() {
    return getFuelsApi;
  }

  static String updateFuelPrices() {
    return updateFuelPricesApi;
  }

  static String getFuelsIds() {
    return getFuelsIdsApi;
  }
}
