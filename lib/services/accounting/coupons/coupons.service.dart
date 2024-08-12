import 'dart:convert';
import 'package:hand_held_shell/models/mappers/accounting/coupons/new.coupons.response.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class CouponsService {
  static const String baseUrl = 'http://192.168.1.148:3000/api';
  Future<NewCouponsResponse?> createCoupons({
    required String cuponesNumber,
    required DateTime cuponesDate,
    required num cuponesAmount,
  }) async {
    try {
      final String? token = await AuthService.getToken();

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('$baseUrl/coupons/createCoupons');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'cuponesNumber': cuponesNumber,
          'cuponesDate': cuponesDate.toIso8601String(),
          'cuponesAmount': cuponesAmount,
        }),
      );

      if (response.statusCode == 201) {
        return newCouponsResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }
}
