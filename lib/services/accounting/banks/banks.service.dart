import 'dart:convert';

import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class BanksService extends GetxController {
  static const String baseUrl = 'http://192.168.0.100:3000/api';

  Future<List<Bank>> getAllBanks() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse('$baseUrl/banks/getAllBanks'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        final bankListResponse = bankListResponseFromJson(response.body);
        if (bankListResponse.ok) {
          return bankListResponse.banks;
        } else {
          throw Exception(bankListResponse.message);
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
