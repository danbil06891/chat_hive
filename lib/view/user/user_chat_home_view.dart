import 'package:chathive/repo/auth_repo.dart';
import 'package:chathive/repo/chat_repo.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:chathive/view/auth/login_view.dart';
import 'package:chathive/view/user/user_chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChatHomeView extends StatefulWidget {
  const UserChatHomeView({super.key, this.type = ''});
  final String type;
  @override
  State<UserChatHomeView> createState() => _UserChatHomeViewState();
}

class _UserChatHomeViewState extends State<UserChatHomeView> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late Future<String> currentMessageFuture;

  @override
  void initState() {
    super.initState();
    currentMessageFuture = fetchCurrentMessage();
  }

  Future<String> fetchCurrentMessage() async {
    String chatRoomId = constructChatRoomId(
      adminId: 'Admin',
      appUserId: firebaseAuth.currentUser!.uid,
    );
    String message = await ChatRepo().getCurrentMessage(chatRoomId);
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat with admin'),
        actions: [
          IconButton(
            onPressed: ()  {
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
            child: FutureBuilder<String>(
              future: currentMessageFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return _buildUserList(snapshot.data);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(String? currentMessage) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatRepo().getUserByType(widget.type),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isNotEmpty) {
          return ListView(
            children: snapshot.data!.docs
                .map((e) => _buildUserItem(e, currentMessage))
                .toList(),
          );
        } else {
          return const Center(
            child: Text('No admin found!'),
          );
        }
      },
    );
  }

  Widget _buildUserItem(DocumentSnapshot document, String? currentMessage) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    String firstLetter = ChatRepo().getFirstLetter(data['name']);

    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage:
            data['imageUrl'].isNotEmpty ? NetworkImage(data['imageUrl']) : null,
        child: data['imageUrl'].isEmpty ? Text(firstLetter) : null,
      ),
      title: Row(
        children: [
          Text(data['type']),
          const SizedBox(
            width: 5,
          ),
          Text(data['name']),
        ],
      ),
      subtitle: Row(
        children: [
          Text(currentMessage ?? ''), // Use currentMessage if available
          const SizedBox(
            width: 5,
          ),
          Text(data['name']),
        ],
      ),
      onTap: () {
        replace(
          context,
          UserChatView(
            adminId: data['uid'],
          ),
        );
      },
    );
  }
}


  // Rest of your widget code...

