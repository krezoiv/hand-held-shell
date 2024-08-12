import 'dart:convert';
import 'package:hand_held_shell/models/mappers/accounting/Bills/new.bill.response.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class BillsService {
  static const String baseUrl = 'http://192.168.0.100:3000/api';

  Future<NewValesResponse?> createBill({
    required String billNumber,
    required DateTime billDate,
    required num billAmount,
    required String billDescription,
  }) async {
    try {
      final String? token = await AuthService.getToken();

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('$baseUrl/bills/createBills');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'billNumber': billNumber,
          'billDate': billDate.toIso8601String(),
          'billAmount': billAmount,
          'billDescription': billDescription,
        }),
      );

      if (response.statusCode == 400) {
        return newBillResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      print('Error al crear gasto: $e');
      return null;
    }
  }
}
