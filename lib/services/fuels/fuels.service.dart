import 'package:hand_held_shell/models/mappers/fuel.station/fuels.response.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class FuelService {
  static const String baseUrl = 'http://192.168.1.148:3000/api';

  static Future<FuelsDataResponse?> getAllFuels() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse('$baseUrl/fuels/getFuels'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        return fuelsDataResponseFromJson(response.body);
      } else {
        throw Exception(
            'Failed to get fuels - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching fuels: $e');
      return null;
    }
  }
}
