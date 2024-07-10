import 'package:get/get.dart';
import 'package:hand_held_shell/services/auth/users.service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/views/entities/models/user.model.dart';

class UserController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final AuthService authService = Get.find<AuthService>();
  final SocketService socketService = Get.find<SocketService>();
  final ChatService chatService = Get.find<ChatService>();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<UserModel> get users => userService.users;
  bool get isLoading => userService.isLoading.value;
  String get error => userService.error.value;

  @override
  void onInit() {
    super.onInit();
    userLoad();
    socketService.on('user-status-changed', _handleUserStatusChange);
  }

  Future<void> userLoad() async {
    await userService.getUsers();
    refreshController.refreshCompleted();
    update();
  }

  void _handleUserStatusChange(dynamic data) {
    final userId = data['userId'] as String;
    final isOnline = data['online'] as bool;
    final index = users.indexWhere((user) => user.userId == userId);
    if (index != -1) {
      final updatedUser = users[index].copyWith(online: isOnline);
      userService.users[index] = updatedUser;
      update();
    }
  }

  void navigateToChat(UserModel user) {
    chatService.toUser.value = user;
    Get.toNamed('/chat');
  }

  void logout() {
    socketService.disconnect();
    AuthService.deleteToken();
    Get.offAllNamed('login');
  }

  @override
  void onClose() {
    socketService.socket.off('user-status-changed');
    super.onClose();
  }
}
