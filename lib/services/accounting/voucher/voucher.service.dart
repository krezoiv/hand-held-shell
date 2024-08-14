import 'package:hand_held_shell/models/mappers/accounting/vouchers/list.voucher.sales.control.response.dart';
import 'package:hand_held_shell/models/mappers/accounting/vouchers/new.voucher.response.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoucherService {
  static const String baseUrl = 'http://192.168.1.148:3000/api';
  Future<NewVoucherResponse?> createVoucher({
    required String authorizationCode,
    required String posId,
    required num voucherAmount,
    required DateTime voucherDate,
  }) async {
    try {
      final String? token = await AuthService.getToken();

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('$baseUrl/vouchers/createVouchers');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: json.encode({
          'authorizationCode': authorizationCode,
          'voucherDate': voucherDate.toIso8601String(),
          'posId': posId,
          'voucherAmount': voucherAmount,
        }),
      );

      if (response.statusCode == 201) {
        return newVoucherResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }

  Future<GetVoucherListSaleControlResponse?> getVoucherSalesControl() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('$baseUrl/vouchers/getVouchersSaleControl');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        return getVoucherListSaleControlResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }
}
