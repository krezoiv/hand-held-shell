import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/environment.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;
import 'package:hand_held_shell/models/enteties.exports.files.dart';

class ChatService extends GetxController {
  Rx<UserModel?> toUser = Rx<UserModel?>(null);

  Future<List<Message>> getChat(String userId) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');
      final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/message/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );
      final messageResponse = MessageResponse.fromJsonString(resp.body);
      return messageResponse.messages;
    } catch (e) {
      return [];
    }
  }
}
