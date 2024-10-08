import 'package:hand_held_shell/config/database/apis/accounting/pos.api.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/mappers/accounting/pos/pos.list.response.dart';

import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class PosService extends GetxController {
  Future<List<Pos>> getAllPOS() async {
    try {
      final String? token = await AuthService
          .getToken(); // Asegúrate de que AuthService tenga el método para obtener el token.
      if (token == null) throw Exception('Token is null');

      final response = await http.get(
        Uri.parse(PosApi.getPos()), // Asegúrate de que esta ruta sea correcta.
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        final posListResponse = posListResponseFromJson(response.body);
        if (posListResponse.ok) {
          return posListResponse.pos;
        } else {
          throw Exception('Failed to fetch POS');
        }
      } else {
        throw Exception('Failed to fetch POS: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching POS: $e');
    }
  }
}
