import 'dart:convert';

import 'package:get/get.dart';
import 'package:hand_held_shell/config/database/apis/person/clients.api.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

import 'package:http/http.dart' as http;

class ClientService extends GetxController {
  Future<List<Client>> getAllBanks() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse(ClientsApi.getClients()),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        final clientsListResponse = clientkListResponseFromJson(response.body);
        if (clientsListResponse.ok) {
          return clientsListResponse.clients;
        } else {
          throw Exception(clientsListResponse.message);
        }
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
            errorResponse['message'] ?? 'Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching Banks: $e');
    }
  }
}
