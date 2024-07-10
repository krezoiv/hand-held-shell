import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';
import 'package:hand_held_shell/views/screens/chat/chat.exports.files.dart';

class ChatController extends GetxController with GetTickerProviderStateMixin {
  final ChatService chatService = Get.find<ChatService>();
  final SocketService socketService = Get.find<SocketService>();
  final AuthService authService = Get.find<AuthService>();

  final textController = TextEditingController();
  final focusNode = FocusNode();
  final RxBool isWriting = false.obs;
  final RxList<ChatMessanger> messages = <ChatMessanger>[].obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    socketService.on('message-one-to-one', _handleIncomingMessage);
    _loadChatHistory();
  }

  void _loadChatHistory() async {
    final toUser = chatService.toUser.value;
    if (toUser == null) return;
    final chat = await chatService.getChat(toUser.userId!);
    final historyMessages =
        chat.map((msg) => _createChatMessanger(msg)).toList();
    // Ordenar mensajes del más antiguo al más reciente
    historyMessages
        .sort((a, b) => b.message.createdAt.compareTo(a.message.createdAt));
    messages.assignAll(historyMessages);
    Future.delayed(Duration(milliseconds: 100), scrollToBottom);
  }

  ChatMessanger _createChatMessanger(Message msg) {
    return ChatMessanger(
      text: msg.message,
      userId: msg.from,
      message: msg,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      )..forward(),
    );
  }

  void _handleIncomingMessage(dynamic payload) {
    final message = Message.fromJson(payload);
    final newMessage = _createChatMessanger(message);
    messages.insert(0, newMessage); // Insertar al principio de la lista
    scrollToBottom();
  }

  void handleSubmit(String text) {
    if (text.isEmpty) return;
    final toUser = chatService.toUser.value;
    if (toUser == null) return;

    final newMessage = Message(
      from: authService.usuario!.userId!,
      to: toUser.userId!,
      message: text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    socketService.emit('message-one-to-one', newMessage.toJson());

    final chatMessage = _createChatMessanger(newMessage);
    messages.insert(0, chatMessage); // Insertar al principio de la lista
    scrollToBottom();

    textController.clear();
    focusNode.requestFocus();
    isWriting.value = false;
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0, // Scroll to the top, which is now the most recent message
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onClose() {
    for (var message in messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('message-one-to-one');
    textController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
