import 'dart:convert';
import 'package:hand_held_shell/config/database/apis/fuel.station/fuels.api.dart';
import 'package:hand_held_shell/models/mappers/fuel.station/fuels.response.dart';
import 'package:hand_held_shell/models/mappers/fuel.station/update.fuel.price.response.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class FuelService {
  static Future<FuelsDataResponse?> getAllFuels() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse(FuelsApi.getFuels()),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        return fuelsDataResponseFromJson(response.body);
      } else {
        throw Exception(
            'Failed to get fuels - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      return null;
    }
  }

  // Nuevo método para obtener los FuelIds
  static Future<Map<String, String>?> getFuelIds() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse(FuelsApi.getFuelsIds()),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Map<String, String>.from(data['fuelIds']);
      } else {
        throw Exception(
            'Failed to get fuel ids - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching fuel IDs: $e');
      return null;
    }
  }

  Future<UpdateFuelPriceResponse?> updateFuelPrices({
    required num regularPrice,
    required num superPrice,
    required num dieselPrice,
  }) async {
    final url = Uri.parse(FuelsApi.updateFuelPrices());

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'regularPrice': regularPrice,
        'superPrice': superPrice,
        'dieselPrice': dieselPrice,
      }),
    );

    if (response.statusCode == 200) {
      return UpdateFuelPriceResponse.fromJson(json.decode(response.body));
    } else {
      print(
          'Error al actualizar los precios de los combustibles: ${response.statusCode}');
      return null;
    }
  }
}
