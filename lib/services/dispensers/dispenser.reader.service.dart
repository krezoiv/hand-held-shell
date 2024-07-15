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
}

//192.168.0.104