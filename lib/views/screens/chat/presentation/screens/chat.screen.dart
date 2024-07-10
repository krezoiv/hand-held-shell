import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/controllers/chat.controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final toUser = controller.chatService.toUser.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(
                  '${toUser!.firstName.substring(0, 1)}${toUser.lastName.substring(0, 1)}',
                  style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            Text('${toUser.firstName} ${toUser.lastName}',
                style: TextStyle(color: Colors.black87, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (_, i) => controller.messages[i],
                  reverse: true,
                )),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            child: _inputChat(),
          ),
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller.textController,
                onSubmitted: controller.handleSubmit,
                onChanged: (String text) {
                  controller.isWriting.value = text.trim().isNotEmpty;
                },
                decoration:
                    const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: controller.focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? Obx(() => CupertinoButton(
                        onPressed: controller.isWriting.value
                            ? () => controller.handleSubmit(
                                controller.textController.text.trim())
                            : null,
                        child: const Text('Enviar'),
                      ))
                  : Obx(() => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: const Icon(Icons.send),
                            onPressed: controller.isWriting.value
                                ? () => controller.handleSubmit(
                                    controller.textController.text.trim())
                                : null,
                          ),
                        ),
                      )),
            )
          ],
        ),
      ),
    );
  }
}
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:hand_held_shell/views/screens/chat/chat.exports.files.dart';
// import 'package:hand_held_shell/services/services.exports.files.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   ChatService? chatService;
//   late SocketService socketService;
//   AuthService? authService;
//   final _textController = TextEditingController();
//   final _focusNode = FocusNode();
//   bool _isWritting = false;
//   final List<ChatMessanger> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     chatService = Provider.of<ChatService>(context, listen: false);
//     socketService = Provider.of<SocketService>(context, listen: false);
//     authService = Provider.of<AuthService>(context, listen: false);
//     socketService.socket.on('message-one-to-one', _listeningMessage);
//     _historyChatLoad(chatService!.toUser!.userId!);
//   }

//   void _historyChatLoad(String userId) async {
//     List<Message>? chat = await chatService!.getChat(userId);

//     final histotyChat = chat?.map((msg) => ChatMessanger(
//         text: msg.message,
//         userId: msg.from,
//         animtationController: AnimationController(
//             vsync: this, duration: Duration(milliseconds: 0))
//           ..forward()));

//     setState(() {
//       _messages.insertAll(0, histotyChat!);
//     });
//   }

//   void _listeningMessage(dynamic payload) {
//     ChatMessanger message = ChatMessanger(
//       text: payload['message'],
//       userId: payload['from'],
//       animtationController: AnimationController(
//           vsync: this, duration: Duration(milliseconds: 300)),
//     );
//     setState(() {
//       _messages.insert(0, message);
//     });

//     message.animtationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final chatServices = Provider.of<ChatService>(context);
//     final toUser = chatService!.toUser;
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Column(
//             children: <Widget>[
//               CircleAvatar(
//                 backgroundColor: Colors.blue[100],
//                 maxRadius: 14,
//                 child: Text(
//                     '${toUser!.firstName.substring(0, 1)}${toUser.lastName.substring(0, 1)}',
//                     style: TextStyle(fontSize: 12)),
//               ),
//               const SizedBox(height: 3),
//               Text('${toUser.firstName} ${toUser.lastName}',
//                   style: TextStyle(color: Colors.black87, fontSize: 12)),
//             ],
//           ),
//           centerTitle: true,
//           elevation: 1,
//         ),
//         body: Column(
//           children: <Widget>[
//             Flexible(
//               child: ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: _messages.length,
//                 itemBuilder: (_, i) => _messages[i],
//                 reverse: true,
//               ),
//             ),
//             const Divider(height: 1),
//             Container(
//               color: Colors.white,
//               child: _inputChat(),
//             ),
//           ],
//         ));
//   }

//   Widget _inputChat() {
//     return SafeArea(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Row(
//           children: <Widget>[
//             Flexible(
//               child: TextField(
//                 controller: _textController,
//                 onSubmitted: _handleSubmit,
//                 onChanged: (String text) {
//                   setState(() {
//                     if (text.trim().isNotEmpty) {
//                       _isWritting = true;
//                     } else {
//                       _isWritting = false;
//                     }
//                   });
//                 },
//                 decoration:
//                     const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
//                 focusNode: _focusNode,
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: !Platform.isIOS
//                   ? CupertinoButton(
//                       onPressed: _isWritting
//                           ? () => _handleSubmit(_textController.text.trim())
//                           : null,
//                       child: const Text('Enviar'),
//                     )
//                   : Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                       child: IconTheme(
//                         data: IconThemeData(color: Colors.blue[400]),
//                         child: IconButton(
//                           highlightColor: Colors.transparent,
//                           splashColor: Colors.transparent,
//                           icon: const Icon(Icons.send),
//                           onPressed: _isWritting
//                               ? () => _handleSubmit(_textController.text.trim())
//                               : null,
//                         ),
//                       ),
//                     ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   _handleSubmit(String text) {
//     if (text.isEmpty) return;
//     _textController.clear();
//     _focusNode.requestFocus();

//     final newMessage = ChatMessanger(
//       text: text,
//       userId: authService!.usuario!.userId!,
//       animtationController: AnimationController(
//           vsync: this, duration: const Duration(milliseconds: 400)),
//     );

//     _messages.insert(0, newMessage);
//     newMessage.animtationController.forward();

//     setState(() {
//       _isWritting = false;
//     });
//     socketService.emit('message-one-to-one', {
//       'from': authService?.usuario?.userId,
//       'to': chatService?.toUser?.userId,
//       'message': text
//     });
//   }

//   @override
//   void dispose() {
//     for (ChatMessanger message in _messages) {
//       message.animtationController.dispose();
//     }

//     socketService.socket.off('message-one-to-one');
//     super.dispose();
//   }
// }
