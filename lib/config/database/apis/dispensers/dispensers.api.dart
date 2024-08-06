import 'package:hand_held_shell/config/global/environment.dart';

class DispensersApi {
  static String fetchDispenserReadersApi =
      ('${Environment.apiUrl}/dispenser-Reader/lastReaderNumeration');

  static String createGeneralDispenserReaderApi =
      ('${Environment.apiUrl}/generalDispenserReader/creatGeneralDispenserReader');

  static String deleteLastGeneralDispenserReaderApi =
      ('${Environment.apiUrl}/generalDispenserReader/general-dispenser-reader/last');

  static String getLastGeneralDispenserReaderApi =
      ('${Environment.apiUrl}/generalDispenserReader/lastGeneralDispenser');

  static String addNewDispenserReaderApi =
      ('${Environment.apiUrl}/dispenser-Reader/addDispenserReader');

  static String updateGeneralDispenserReaderApi =
      ('${Environment.apiUrl}/generalDispenserReader/updateGeneralDispenserReader');

  static String getDispenserReaderByIdApi =
      ('${Environment.apiUrl}/dispenser-Reader/dispenserReadarById');

  static String updateDispenserReaderApi =
      ('${Environment.apiUrl}/dispenser-reader/updateDispenserReader');

  static fetchDispenserReaders() {
    return fetchDispenserReadersApi;
  }

  static createGeneralDispenserReader() {
    return createGeneralDispenserReaderApi;
  }

  static deleteLastGeneralDispenserReader() {
    return deleteLastGeneralDispenserReaderApi;
  }

  static getLastGeneralDispenserReaderId() {
    return getLastGeneralDispenserReaderApi;
  }

  static addNewDispenserReader() {
    return addNewDispenserReaderApi;
  }

  static updateGeneralDispenserReader() {
    return updateGeneralDispenserReaderApi;
  }

  static getDispenserReaderById() {
    return getDispenserReaderByIdApi;
  }

  static updateDispenserReader() {
    return updateDispenserReaderApi;
  }
}
