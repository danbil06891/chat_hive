import 'package:chathive/components/message_bubble.dart';
import 'package:chathive/models/message_model.dart';
import 'package:chathive/repo/chat_repo.dart';
import 'package:chathive/repo/firebase_repo.dart';
import 'package:chathive/repo/user_repo.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:chathive/view/auth/login_view.dart';
import 'package:chathive/view/user/user_chat_home_view.dart';
import 'package:chathive/view/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChatView extends StatefulWidget {
  const UserChatView({super.key, required this.adminId});

  final String adminId;

  @override
  _UserChatViewState createState() => _UserChatViewState();
}

class _UserChatViewState extends State<UserChatView> {
  final TextEditingController _messageController = TextEditingController();

  final ChatRepo _chatRepo = ChatRepo();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatRepo.sendMessage(
          appUserId: firebaseAuth.currentUser!.uid,
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
      adminId: widget.adminId,
      appUserId: firebaseAuth.currentUser!.uid,
    );
    _messageStream = _chatRepo.getMessageStream(chatRoomId);
     FirebaseRepo().initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Admin'),
        leading: IconButton(
          onPressed: () {
            replace(context, const UserChatHomeView());
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
                      bool isMe =
                          message.senderId == firebaseAuth.currentUser!.uid;
                      
                      return MessageBubble(

                        isMe: isMe,
                        message: message,
                      );
                      
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


