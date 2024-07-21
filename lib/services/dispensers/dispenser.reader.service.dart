import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DispenserReaderService {
  static const String baseUrl = 'http://192.168.0.104:3000/api';

  static Future<List<dynamic>> fetchDispenserReaders(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dispenser-Reader/lastReaderNumeration'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['dispenserReaders'];
      } else {
        throw Exception(
            'Failed to load dispenser readers - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load dispenser readers: $e');
    }
  }

  static Future<void> createGeneralDispenserReader() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.post(
        Uri.parse(
            '$baseUrl/generalDispenserReader/creatGeneralDispenserReader'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          // Aquí puedes agregar cualquier otro dato necesario
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Failed to create GeneralDispenserReader - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create GeneralDispenserReader: $e');
    }
  }

  static Future<void> deleteLastGeneralDispenserReader() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.delete(
        Uri.parse(
            '$baseUrl/generalDispenserReader/general-dispenser-reader/last'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete last GeneralDispenserReader - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete last GeneralDispenserReader: $e');
    }
  }

  static Future<String?> getLastGeneralDispenserReaderId() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse('$baseUrl/generalDispenserReader/lastGeneralDispenserId'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['generalDispenserReader']['generalDispenserReaderId'];
      } else {
        throw Exception(
            'Failed to get last GeneralDispenserReader - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error getting last GeneralDispenserReader: $e');
      return null;
    }
  }

  static Future<String?> addNewDispenserReader(
    String previousNoGallons,
    String actualNoGallons,
    String totalNoGallons,
    String previousNoMechanic,
    String actualNoMechanic,
    String totalNoMechanic,
    String previousNoMoney,
    String actualNoMoney,
    String totalNoMoney,
    String assignmentHoseId,
    String generalDispenserReaderId,
  ) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.post(
        Uri.parse('$baseUrl/dispenser-Reader/addDispenserReader'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'previousNoGallons': double.parse(previousNoGallons),
          'actualNoGallons': double.parse(actualNoGallons),
          'totalNoGallons': double.parse(totalNoGallons),
          'previousNoMechanic': double.parse(previousNoMechanic),
          'actualNoMechanic': double.parse(actualNoMechanic),
          'totalNoMechanic': double.parse(totalNoMechanic),
          'previousNoMoney': double.parse(previousNoMoney),
          'actualNoMoney': double.parse(actualNoMoney),
          'totalNoMoney': double.parse(totalNoMoney),
          'assignmentHoseId': assignmentHoseId,
          'generalDispenserReaderId': generalDispenserReaderId,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['newDispenserReader']['dispenserReaderId'];
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in addNewDispenserReader: $e');
      return null;
    }
  }

  static Future<bool> updateGeneralDispenserReader(
    String totalNoGallons,
    String totalNoMechanic,
    String totalNoMoney,
    String assignmentHoseId,
    String generalDispenserReaderId,
  ) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.put(
        Uri.parse(
            '$baseUrl/generalDispenserReader/updateGeneralDispenserReader'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'totalNoGallons': totalNoGallons,
          'totalNoMechanic': totalNoMechanic,
          'totalNoMoney': totalNoMoney,
          'assignmentHoseId': assignmentHoseId,
          'generalDispenserReaderId': generalDispenserReaderId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['ok'] ?? false;
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in updateGeneralDispenserReader: $e');
      return false;
    }
  }

  // static Future<bool> updateDispenserReader(
  //   String dispenserReaderId,
  //   String actualNoGallons,
  //   String actualNoMechanic,
  //   String actualNoMoney,
  // ) async {
  //   try {
  //     final String? token = await AuthService.getToken();
  //     if (token == null) throw Exception('Token is null');

  //     final response = await http.put(
  //       Uri.parse('$baseUrl/dispenser-Reader/updateDispenserReader'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'x-token': token,
  //       },
  //       body: json.encode({
  //         'dispenserReaderId': dispenserReaderId,
  //         'actualNoGallons': double.parse(actualNoGallons),
  //         'actualNoMechanic': double.parse(actualNoMechanic),
  //         'actualNoMoney': double.parse(actualNoMoney),
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       return responseData['ok'] ?? false;
  //     } else {
  //       print('Server responded with status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error in updateDispenserReader: $e');
  //     return false;
  //   }
  // }

  static Future<bool> updateDispenserReader(
    String dispenserReaderId,
    String newPreviousNoGallons,
    String newActualNoGallons,
    String newPreviousNoMechanic,
    String newActualNoMechanic,
    String newPreviousNoMoney,
    String newActualNoMoney,
  ) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.put(
        Uri.parse('$baseUrl/dispenser-Reader/updateDispenserReader'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'dispenserReaderId': dispenserReaderId,
          'newPreviousNoGallons': newPreviousNoGallons,
          'newActualNoGallons': newActualNoGallons,
          'newPreviousNoMechanic': newPreviousNoMechanic,
          'newActualNoMechanic': newActualNoMechanic,
          'newPreviousNoMoney': newPreviousNoMoney,
          'newActualNoMoney': newActualNoMoney,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Request body:');
      print(json.encode({
        'dispenserReaderId': dispenserReaderId,
        'newPreviousNoGallons': newPreviousNoGallons,
        'newActualNoGallons': newActualNoGallons,
        'newPreviousNoMechanic': newPreviousNoMechanic,
        'newActualNoMechanic': newActualNoMechanic,
        'newPreviousNoMoney': newPreviousNoMoney,
        'newActualNoMoney': newActualNoMoney,
      }));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['ok'] ?? false;
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in updateDispenserReader: $e');
      return false;
    }
  }
}
