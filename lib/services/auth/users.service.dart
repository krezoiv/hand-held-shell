import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/environment.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/views/entities/mappers/users.response.dart';
import 'package:http/http.dart' as http;
import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';

class UserService extends GetxService {
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<UserService> init() async => this;

  Future<List<UserModel>> getUsers() async {
    isLoading.value = true;
    error.value = '';

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
        final userResponse = UserResponse.fromJsonString(resp.body);
        users.assignAll(userResponse.users);
        return userResponse.users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      error.value = e.toString();
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}
