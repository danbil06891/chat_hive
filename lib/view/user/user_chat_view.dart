import 'package:chathive/constants/color_constant.dart';
import 'package:chathive/models/message_model.dart';
import 'package:chathive/repo/auth_repo.dart';
import 'package:chathive/repo/chat_repo.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:chathive/view/auth/login_view.dart';
import 'package:chathive/view/user/user_chat_home_view.dart';
import 'package:chathive/view/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserChatView extends StatefulWidget {
  const UserChatView({super.key, required this.adminId});

  final String adminId;

  @override
  State<UserChatView> createState() => _UserChatViewState();
}

class _UserChatViewState extends State<UserChatView> {
  final TextEditingController _messageController = TextEditingController();

  final ChatRepo _chatRepo = ChatRepo();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _chatRepo.sendMessage(
          appUserId: firebaseAuth.currentUser!.uid,
          adminId: widget.adminId,
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
      adminId: widget.adminId,
      appUserId: firebaseAuth.currentUser!.uid,
    );
    _messageStream = _chatRepo.getMessageStream(chatRoomId);

    _messageStream!.listen((List<Message> messages) {
      for(Message message in messages){
        if(message.receiverId == firebaseAuth.currentUser!.uid && !message.isSeen){
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
          'Chat with Admin',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            replace(
                context,
                const UserChatHomeView(
                  type: 'User',
                ));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthRepo().logout();

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
                      DateTime dateTime = message.timeStamp.toDate();
                      String formattedTime =
                          DateFormat('h:mm a').format(dateTime);
                      bool isMe =
                          message.senderId == firebaseAuth.currentUser!.uid;
                      bool isSeen = message.isSeen;
                      return MessageBubbleUser(
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

class MessageBubbleUser extends StatelessWidget {
  const MessageBubbleUser({
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
            ? Alignment.topRight
            : Alignment.topLeft, // Adjusted alignment logic
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? primaryColor : Colors.grey,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(15)),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,

            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start, // Adjusted crossAxisAlignment
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
                 isMe == true?
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
