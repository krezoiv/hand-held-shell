import 'dart:convert';

import 'package:get/get.dart';
import 'package:hand_held_shell/config/database/apis/accounting/banks.api.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class BanksService extends GetxController {
  Future<List<Bank>> getAllBanks() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse(BanksApi.getBanksApi),
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
