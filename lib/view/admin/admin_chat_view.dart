import 'package:chathive/constants/color_constant.dart';
import 'package:chathive/models/message_model.dart';
import 'package:chathive/repo/auth_repo.dart';
import 'package:chathive/repo/chat_repo.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:chathive/view/admin/admin_chat_home_view.dart';
import 'package:chathive/view/auth/login_view.dart';
import 'package:chathive/view/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminChatView extends StatefulWidget {
  const AdminChatView({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<AdminChatView> createState() => _AdminChatViewState();
}

class _AdminChatViewState extends State<AdminChatView> {
  final TextEditingController _messageController = TextEditingController();

  final ChatRepo _chatRepo = ChatRepo();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage()  {
    if (_messageController.text.isNotEmpty) {
       _chatRepo.sendMessage(
          appUserId: widget.userId,
          adminId: 'Admin',
          message: _messageController.text);
      _messageController.clear();
    }
  }

  Stream<List<Message>>? _messageStream;

  @override
  void initState() {
    super.initState();
    final String chatRoomId = constructChatRoomId(
      adminId: 'Admin',
      appUserId: widget.userId,
    );
    _messageStream = _chatRepo.getMessageStream(chatRoomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Users'),
        leading: IconButton(
          onPressed: () {
            replace(
                context,
                const AdminChatHomeView(
                  type: 'Admin',
                ));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthRepo().logout();
              push(context, const LoginView());
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Loading..'));
                }
                if (snapshot.hasData) {
                  List<Message> messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      bool isMe = message.senderId == widget.userId;

                      return MessageBubbleAdmin(isMe: isMe, message: message);
                    },
                  );
                } else {
                  return const Center(child: Text('No messages yet'));
                }
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              labelText: 'Message',
              hintText: 'Enter Message',
              controller: _messageController,
            ),
          ),
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class MessageBubbleAdmin extends StatelessWidget {
  const MessageBubbleAdmin({
    super.key,
    required this.isMe,
    required this.message,
  });

  final bool isMe;

  final Message message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe
            ? Alignment.topLeft
            : Alignment.topRight, // Adjusted alignment logic
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey : primaryColor,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(15))
                : const BorderRadius.only(
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
