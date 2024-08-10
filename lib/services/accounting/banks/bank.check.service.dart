import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';

class BankCheckService {
  static const String baseUrl = 'http://192.168.0.100:3000/api';

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
          'Authorization': 'Bearer $token',
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
      print('Error creando cheque bancario: $e');
      return null;
    }
  }
}
