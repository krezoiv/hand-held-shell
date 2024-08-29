import 'dart:convert';

import 'package:hand_held_shell/config/database/apis/person/vehicles.api.dart';
import 'package:http/http.dart' as http;

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class VehicleService extends GetxController {
  Future<List<Vehicle>> getAllVehicles() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse(VehiclesApi.getVehicles()),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        try {
          final vehicleListResponse =
              vehiclesListResponseFromJson(response.body);
          if (vehicleListResponse.ok) {
            return vehicleListResponse.vehicles;
          } else {
            throw Exception(vehicleListResponse.message);
          }
        } catch (e) {
          throw Exception('Error parsing vehicles: $e');
        }
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
            errorResponse['message'] ?? 'Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching Vehicles: $e');
    }
  }
}
