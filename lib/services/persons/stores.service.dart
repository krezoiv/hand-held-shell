import 'dart:convert';

import 'package:hand_held_shell/config/database/apis/person/stores.apr.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class StroresService extends GetxController {
  Future<List<Store>> getAllStores() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse(StoresApi.getStores()),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        try {
          final storesListResponse = storesListResponseFromJson(response.body);
          if (storesListResponse.ok) {
            return storesListResponse.stores;
          } else {
            throw Exception(storesListResponse.message);
          }
        } catch (e) {
          throw Exception('Error parsing stores: $e');
        }
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
            errorResponse['message'] ?? 'Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching Stores: $e');
    }
  }
}
