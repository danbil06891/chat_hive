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
import 'package:intl/intl.dart';

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

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _chatRepo.sendMessage(
        appUserId: widget.userId,
        adminId: firebaseAuth.currentUser!.uid,
        message: _messageController.text,
        isSeen: false,
      );
      _messageController.clear();
    }
  }

  Stream<List<Message>>? _messageStream;

  @override
  void initState() {
    super.initState();
    final String chatRoomId = constructChatRoomId(
      adminId: firebaseAuth.currentUser!.uid,
      appUserId: widget.userId,
    );

    _messageStream = _chatRepo.getMessageStream(chatRoomId);

    _messageStream!.listen((List<Message> messages) {
      for (Message message in messages) {
        if (message.receiverId == firebaseAuth.currentUser!.uid &&
            !message.isSeen) {
          _chatRepo.setMessageSeen(chatRoomId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat with Users',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            replace(
                context,
                const AdminChatHomeView(
                  type: 'Admin',
                ));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthRepo().logout();
              push(context, const LoginView());
            },
            icon: const Icon(
              Icons.logout,
              color: whiteColor,
            ),
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
                      DateTime dateTime = message.timeStamp.toDate();
                      String formattedTime =
                          DateFormat('h:mm a').format(dateTime);
                      bool isSeen = message.isSeen;
                      return MessageBubbleAdmin(
                        isMe: isMe,
                        message: message,
                        time: formattedTime,
                        isSeen: isSeen,
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

class MessageBubbleAdmin extends StatelessWidget {
  const MessageBubbleAdmin({
    super.key,
    required this.isMe,
    required this.message,
    required this.time,
    this.isSeen = false,
  });

  final bool isMe;
  final String time;
  final Message message;
  final bool isSeen;
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
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    time,
                    style: const TextStyle(color: whiteColor, fontSize: 10),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  isMe == false?
                    Row(
                      children: [
                        isSeen == true
                            ? const Icon(
                                Icons.done_all,
                                color: doubleTickIconColor,
                              )
                            : const Icon(
                                Icons.done,
                                color: whiteColor,
                                size: 20,
                              ),
                      ],
                    ) : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      );
}
