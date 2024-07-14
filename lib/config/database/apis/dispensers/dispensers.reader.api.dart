import 'package:hand_held_shell/config/global/environment.dart';

class DispenserReaderApi {
  static String dispenserReaderApi =
      '${Environment.apiUrl}/dispenser-Reader/lastReaderNumeration';

  static String dispenserReader() {
    return dispenserReaderApi;
  }
}
