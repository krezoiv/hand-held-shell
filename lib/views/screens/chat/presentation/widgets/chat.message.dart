import 'package:flutter/material.dart';

class ChatMessanger extends StatelessWidget {
  final String text;
  final String userId;
  final AnimationController animtationController;

  const ChatMessanger({
    super.key,
    required this.text,
    required this.userId,
    required this.animtationController,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animtationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animtationController, curve: Curves.easeOut),
        child: Container(
          child:
              userId == '123' ? _receptorHostMessage() : _senderHostMessage(),
        ),
      ),
    );
  }

  Widget _receptorHostMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          right: 5,
          left: 50,
        ),
        decoration: BoxDecoration(
            color: const Color(0xff4D9EF6),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _senderHostMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          right: 50,
          left: 5,
        ),
        decoration: BoxDecoration(
            color: const Color(0xffE4E5E8),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
