import 'dart:convert';
import 'package:hand_held_shell/models/mappers/accounting/banks/list.bank.checks.sales.control.dart';
import 'package:http/http.dart' as http;
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';

class BankCheckService {
  static const String baseUrl = 'http://192.168.0.103:3000/api';

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

      final url = Uri.parse('$baseUrl/bankCheck/createBankCheck');
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
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }

  Future<GetBankChecksListSaleControlResponse?>
      getbankChecksSalesControl() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('$baseUrl/bankCheck/getBankChecksSalesControl');
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
}
