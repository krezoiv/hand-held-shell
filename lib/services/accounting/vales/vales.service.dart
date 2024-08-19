import 'dart:convert';

import 'package:hand_held_shell/models/mappers/accounting/vales/list.vales.sales.control.response.dart';
import 'package:hand_held_shell/models/mappers/accounting/vales/new.vale.response.dart';

import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class ValessService {
  static const String baseUrl = 'http://192.168.0.103:3000/api';
  Future<NewValeResponse?> createVale({
    required String valeNumber,
    required DateTime valeDate,
    required num valeAmount,
    required String valeDescription,
  }) async {
    try {
      final String? token = await AuthService.getToken();

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('$baseUrl/vales/createVales');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'valeNumber': valeNumber,
          'valeDate': valeDate.toIso8601String(),
          'valeAmount': valeAmount,
          'valeDescription': valeDescription,
        }),
      );

      if (response.statusCode == 201) {
        // Cambiado de 400 a 201
        return newValeResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }

  Future<GetValesListSaleControlResponse?> getValesSalesControl() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('$baseUrl/vales/getValesSalesControl');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        return getValesListSaleControlResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }
}
