import 'dart:convert';

import 'package:hand_held_shell/config/database/apis/accounting/credits.api.dart';
import 'package:hand_held_shell/models/mappers/credits/list.credits.sales.control.response.dart';
import 'package:hand_held_shell/models/mappers/credits/new.credit.response.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class CreditsService {
  Future<NewCreditResponse?> createCredit({
    required int creditNumber,
    required num creditAmount,
    required DateTime creditDate,
    required num regularAmount,
    required num superAmount,
    required num dieselAmount,
    required String clientId,
  }) async {
    try {
      final String? token = await AuthService.getToken();

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(CreditsApi.createCredit());
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'creditNumber': creditNumber,
          'creditDate': creditDate.toIso8601String(),
          'creditAmount': creditAmount,
          'regularAmount': regularAmount,
          'superAmount': superAmount,
          'dieselAmount': dieselAmount,
          'clientId': clientId,
        }),
      );

      if (response.statusCode == 201) {
        return newCreditResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }

  Future<GetCreditsListSaleControlResponse?> getCreditsSalesControl() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(CreditsApi.getCredits());
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        return getCreditsListSaleControlResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteCredit(String creditId) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(CreditsApi.deleteCredit(creditId));
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        // Verificar si la eliminación fue exitosa
        final responseBody = json.decode(response.body);
        return responseBody['ok'] == true;
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      // Manejar errores y devolver false en caso de error
      return false;
    }
  }
}
