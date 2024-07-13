import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/controllers/chat.controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final toUser = controller.chatService.toUser.value;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
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
                style: TextStyle(
                  // color: Colors.black87,
                  fontSize: 20,
                )),
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
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                  // Establece el estilo del texto del input
                  hintStyle: TextStyle(color: Colors.black),
                ),
                focusNode: controller.focusNode,
                style: TextStyle(
                    color: Colors.black), // Color del texto del TextField
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Builder(
                builder: (BuildContext context) {
                  final TargetPlatform platform = Theme.of(context).platform;
                  // Mantén esta línea para depuración
                  return Obx(() {
                    if (platform == TargetPlatform.iOS) {
                      // CupertinoButton para iOS
                      return CupertinoButton(
                        onPressed: controller.isWriting.value
                            ? () => controller.handleSubmit(
                                controller.textController.text.trim())
                            : null,
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.paperplane,
                          size: 35,
                          color: CupertinoColors.activeBlue,
                        ),
                      );
                    } else {
                      // Botón "Enviar" para Android y otras plataformas
                      return TextButton(
                        onPressed: controller.isWriting.value
                            ? () => controller.handleSubmit(
                                controller.textController.text.trim())
                            : null,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue[400],
                        ),
                        child: const Icon(
                          CupertinoIcons.paperplane,
                          size: 35,
                          color: CupertinoColors.activeBlue,
                        ),
                      );
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
