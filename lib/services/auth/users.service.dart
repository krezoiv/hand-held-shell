import 'package:hand_held_shell/global/environment.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/views/entities/mappers/users.response.dart';
import 'package:http/http.dart' as http;
import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';

class UserService {
  Future<List<UserModel>> getUsers() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/user'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (resp.statusCode == 200) {
        final userResponse = userResponseFromJson(resp.body);
        return userResponse.users;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
