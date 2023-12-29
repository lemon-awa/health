import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool receiverOrSender; //sender is true, receiver is false
  const ChatBubble(
      {super.key, required this.message, required this.receiverOrSender});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: receiverOrSender
              ? Colors.blue
              : Color.fromARGB(255, 102, 100, 100)),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
