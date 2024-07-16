import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DispenserReaderService {
  static const String baseUrl = 'http://192.168.1.148:3000/api';

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

  static Future<void> saveDispenserReadings(
      List<Map<String, dynamic>> readings) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.post(
        Uri.parse('$baseUrl/dispenser-Reader/saveReadings'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({'readings': readings}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to save dispenser readings - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to save dispenser readings: $e');
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

  static Future<DispenserReader?> addDispenserReader(
      DispenserReader reading) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.post(
        Uri.parse('$baseUrl/dispenser-Reader/addDispenserReader'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode(reading.toJson()),
      );

      if (response.statusCode == 201) {
        return DispenserReader.fromJson(
            json.decode(response.body)['newDispenserReader']);
      } else {
        throw Exception(
            'Failed to add dispenser reader - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add dispenser reader: $e');
    }
  }
}

//192.168.0.104