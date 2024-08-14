import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DispenserReaderService {
  static const String baseUrl = 'http://192.168.0.100:3000/api';

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
      return null;
    }
  }

  static Future<GeneralReaderDispenserDataResponse?>
      getLastGeneralDispenserReader() async {
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
        return generalReaderDispenserDataResponseFromJson(response.body);
      } else {
        throw Exception(
            'Failed to get last GeneralDispenserReader - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> addNewDispenserReader(
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
        return {
          'success': responseData['ok'] ?? false,
          'dispenserReaderId': responseData['dispenserReaderId'],
        };
      } else {
        return {'success': false, 'dispenserReaderId': null};
      }
    } catch (e) {
      return {'success': false, 'dispenserReaderId': null};
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
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getDispenserReaderById(
      String dispenserReaderId) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse(
            '$baseUrl/dispenser-Reader/dispenserReadarById/$dispenserReaderId'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['dispenserReader'];
      } else {
        throw Exception(
            'Failed to load dispenser reader - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load dispenser reader: $e');
    }
  }

  static Future<UpdateReaderDispenserResponse> updateDispenserReader(
    String dispenserReaderId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.put(
        Uri.parse('$baseUrl/dispenser-reader/updateDispenserReader'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'dispenserReaderId': dispenserReaderId,
          ...updateData,
        }),
      );

      if (response.statusCode == 200) {
        return updateReaderDispenserResponseFromJson(response.body);
      } else {
        throw Exception('Failed to update dispenser reader: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating dispenser reader: $e');
    }
  }
}
