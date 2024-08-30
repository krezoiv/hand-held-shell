import 'dart:convert';
import 'package:hand_held_shell/config/database/apis/accounting/banks.checks.api.dart';
import 'package:hand_held_shell/models/mappers/accounting/banks/list.bank.checks.sales.control.dart';
import 'package:http/http.dart' as http;
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';

class BankCheckService {
  Future<NewBankCheckResponse?> createBankCheck({
    required int checkNumber,
    required num checkValue,
    required DateTime checkDate,
    required String bankId,
    required String clientId,
  }) async {
    try {
      final String? token = await AuthService.getToken();

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(BanksChecksApi.createBankCheck());
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'checkNumber': checkNumber,
          'checkValue': checkValue,
          'checkDate': checkDate.toIso8601String(),
          'bankId': bankId,
          'clientId': clientId,
        }),
      );

      if (response.statusCode == 201) {
        return newBankCheckResponseFromJson(response.body);
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

  Future<GetBankChecksListSaleControlResponse?>
      getbankChecksSalesControl() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(BanksChecksApi.getBankCheck());
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        return getBankChecksListSaleControlResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteBankCheck(String bankCheckId) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(BanksChecksApi.deleteBankCheck(bankCheckId));
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
