import 'package:hand_held_shell/config/global/environment.dart';

class SalesControlApi {
  static String createSalesControlApi =
      '${Environment.apiUrl}/sales/newSalesControl';

  static String updateLastSalesControlApi =
      '${Environment.apiUrl}/sales/updateSalesControl';

  static String getLastSalesControlApi =
      '${Environment.apiUrl}/sales/lastSalesControl';

  static String createSalesControl() {
    return createSalesControlApi;
  }

  static String updateLastSalesControl() {
    return updateLastSalesControlApi;
  }

  static String getLastSalesControl() {
    return getLastSalesControlApi;
  }
}
