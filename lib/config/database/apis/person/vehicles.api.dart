import 'package:hand_held_shell/config/global/environment.dart';

class VehiclesApi {
  static String getVehiclesApi =
      '${Environment.apiUrl}/vehicles/getAllVehicles';

  static String getVehicles() {
    return getVehiclesApi;
  }
}
