import 'package:chathive/constants/color_constant.dart';
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
  String? currentMessageFuture;
  String? chatRoomId;
  @override
  void initState() {
    super.initState();

    chatRoomId = constructChatRoomId(
      adminId: 'Admin',
      appUserId: firebaseAuth.currentUser!.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Chat with admin',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: primaryColor,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<List<List<String>>>(
            future: ChatRepo().getAllSenderIdsForAdmin(widget.type),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: getLoader(),
                );
              }

              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Text('No data available.');
              }

              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data![0].length,
                  itemBuilder: (context, index) {
                  
                   
                    List<List<String>> dataList = snapshot.data!;
                    String dataTitle =
                        index < dataList[0].length ? dataList[0][index] : '';
                       
                   
                    String dataSubTitle =
                        index < dataList[4].length ? dataList[4][index] : '';
                    String uid =
                        index < dataList[1].length ? dataList[1][index] : '';
                    String imageUrl =
                        index < dataList[2].length ? dataList[2][index] : '';
                    String time =
                        index < dataList[3].length ? dataList[3][index] : '';
                    
                    
                   
                    return ListTile(
                      leading:  CircleAvatar(
                        backgroundImage: imageUrl.isNotEmpty ?
                            NetworkImage(imageUrl) : Image.asset('assets/images/profile.png').image,
                        
                      ) ,
                      title: Text(dataTitle),
                      subtitle: Text(dataSubTitle),
                      trailing: Text(time),
                      onTap: () {
                        replace(context, UserChatView(adminId: uid));
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  
}
