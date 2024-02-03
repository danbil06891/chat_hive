import 'package:chathive/constants/color_constant.dart';
import 'package:chathive/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
  });

  final bool isMe;

  final Message message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe
            ? Alignment.topRight
            : Alignment.topLeft, // Adjusted alignment logic
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? primaryColor : Colors.grey,
            borderRadius: isMe
                ? const  BorderRadius.only(
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(15)
                  ),
          ),
          margin: const EdgeInsets.symmetric(
                               vertical: 5, horizontal: 10),
                           padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,

            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start, // Adjusted crossAxisAlignment
            children: [
              Text(
                message.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
}
