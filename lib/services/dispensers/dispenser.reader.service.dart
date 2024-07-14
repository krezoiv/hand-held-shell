import 'package:http/http.dart' as http;
import 'dart:convert';

class DispenserReaderService {
  static Future<List<dynamic>> fetchDispenserReaders(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/dispenser-Reader/lastReaderNumeration'),
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
            'Failed to load dispenser readers - ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load dispenser readers');
    }
  }
}
