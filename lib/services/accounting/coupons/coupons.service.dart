import 'dart:convert';

import 'package:hand_held_shell/config/database/apis/accounting/coupons.api.dart';

import 'package:hand_held_shell/models/mappers/accounting/coupons/list.coupons.sales.control.response.dart';
import 'package:hand_held_shell/models/mappers/accounting/coupons/new.coupons.response.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class CouponsService {
  static const String baseUrl = 'http://192.168.0.103:3000/api';

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

      final url = Uri.parse(CouponApi.createCoupon());
      print('URL: $url');
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

  Future<GetCouponsListSaleControlResponse?> getCouponsSalesControl() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(CouponApi.getCoupons());
      print('URL: $url');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        return getCouponsListSaleControlResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteCoupon(String couponId) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse(CouponApi.deleteCoupon(couponId));
      print('URL: $url');
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
