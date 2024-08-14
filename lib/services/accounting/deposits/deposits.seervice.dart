import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class DepositsService {
  static const String baseUrl = 'http://192.168.1.148:3000/api';
  Future<NewDepositsResponse?> createDeposits({
    required int depositNumber,
    required num depositAmount,
    required DateTime depositDate,
    required String bankId,
  }) async {
    try {
      final String? token = await AuthService.getToken();

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('$baseUrl/deposits/createDeposits');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'depositNumber': depositNumber,
          'depositDate': depositDate.toIso8601String(),
          'depositAmount': depositAmount,
          'bankId': bankId,
        }),
      );

      if (response.statusCode == 201) {
        return newDepositsResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }
}
