import 'package:hand_held_shell/config/global/environment.dart';

class DispensersApi {
  static String fetchDispenserReadersApi =
      ('${Environment.apiUrl}/dispenser-Reader/lastReaderNumeration');

  static String createGeneralDispenserReaderApi =
      ('${Environment.apiUrl}/generalDispenserReader/creatGeneralDispenserReader');

  static String deleteLastGeneralDispenserReaderApi =
      ('${Environment.apiUrl}/generalDispenserReader/general-dispenser-reader/last');

  static String deleteLastGeneralDispenserReaderIdApi =
      ('${Environment.apiUrl}/generalDispenserReader/lastGeneralDispenserId');

  static String getLastGeneralDispenserReaderIdApi =
      ('${Environment.apiUrl}/generalDispenserReader/lastGeneralDispenserId');

  static String addNewDispenserReaderApi =
      ('${Environment.apiUrl}/dispenser-Reader/addDispenserReader');

  static String updateGeneralDispenserReaderApi =
      ('${Environment.apiUrl}/generalDispenserReader/updateGeneralDispenserReader');

  static String getDispenserReaderByIdApi(String dispenserReaderId) {
    return '${Environment.apiUrl}/dispenser-Reader/dispenserReadarById/$dispenserReaderId';
  }

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

  static deleteLastGeneralDispenserReaderId() {
    return deleteLastGeneralDispenserReaderIdApi;
  }

  static getLastGeneralDispenserReaderId() {
    return getLastGeneralDispenserReaderIdApi;
  }

  static addNewDispenserReader() {
    return addNewDispenserReaderApi;
  }

  static updateGeneralDispenserReader() {
    return updateGeneralDispenserReaderApi;
  }

  static getDispenserReaderById(String dispenserReaderId) {
    return getDispenserReaderByIdApi(dispenserReaderId);
  }

  static updateDispenserReader() {
    return updateDispenserReaderApi;
  }
}
