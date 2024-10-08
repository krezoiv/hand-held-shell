import 'dart:convert';

import 'package:hand_held_shell/config/database/apis/accounting/deposits.api.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/mappers/accounting/deposits/list.deposits.sales.control.response.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class DepositsService {
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

      final url = Uri.parse(DepositsApi.createDeposits());
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
      } else if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      } else {
        throw Exception('Error desconocido');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GetDepositsListSaleControlResponse?> getDepositsSalesControl() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(DepositsApi.getDeposits());
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        return getDepositsListSaleControlResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteDeposit(String depositId) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(DepositsApi.deleteDeposit(depositId));
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
