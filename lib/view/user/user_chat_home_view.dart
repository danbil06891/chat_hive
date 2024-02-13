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
        title: const Text('Chat with admin', style: TextStyle(color: whiteColor),),
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
                return  Center(
                  child: getLoader(),
                );
              }

              // Debugging: Print the contents of snapshot.data
              print('snapshot.data: ${snapshot.data}');

              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Text('No data available.');
              }

              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    List<List<String>> dataList = snapshot.data!;
                    List<String>? title = dataList[0];
                    List<String> userUid = dataList[1];
                    List<String> image = dataList[2];
                    List<String> timeStamp = dataList[3];
                    List<String> subtitle = dataList[4];
                    
                    // Debugging: Print the contents of title, userUid, subtitle
                    print('title: $title');
                    print('userUid: $userUid');
                    print('subtitle: $subtitle');

                    // Check if index is within bounds
                    if (index < title.length &&
                        index < userUid.length &&
                        index < subtitle.length &&
                        index < image.length) {
                      String? dataTitle = title[index];
                      String? dataSubTitle = subtitle[index];
                      String? uid = userUid[index];
                      String? imageUrl = image[index];
                      String? time = timeStamp[index];
                      print('subTitle: $dataSubTitle');
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                          child: imageUrl.isEmpty ? Text(dataTitle[0]) : null,
                        ),
                        title: Text(dataTitle),
                        subtitle: Text(dataSubTitle),
                        trailing: time.isNotEmpty ? Text(time) : null,
                        onTap: () {
                          replace(context, UserChatView(adminId: uid));
                        },
                      );
                    } else {
                      return const SizedBox(); // Return an empty container if index is out of bounds
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildUserList(List<String> userChatList) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: ChatRepo().getUserByType(widget.type),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       }

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       if (snapshot.data!.docs.isNotEmpty) {
  //         return ListView(
  //           children: snapshot.data!.docs
  //               .map((e) => _buildUserItem(e, userChatList))
  //               .toList(),
  //         );
  //       } else {
  //         return const Center(
  //           child: Text('No admin found!'),
  //         );
  //       }
  //     },
  //   );
  // }

  // Widget _buildUserItem(DocumentSnapshot document, List<String> userChatList) {
  //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  //   String firstLetter = ChatRepo().getFirstLetter(data['name']);

  //   return ListTile(
  //     leading: CircleAvatar(
  //       radius: 25,
  //       backgroundImage:
  //           data['imageUrl'].isNotEmpty ? NetworkImage(data['imageUrl']) : null,
  //       child: data['imageUrl'].isEmpty ? Text(firstLetter) : null,
  //     ),
  //     title: Row(
  //       children: [
  //         Text(data['type']),
  //         const SizedBox(
  //           width: 5,
  //         ),
  //         Text(data['name']),
  //       ],
  //     ),
  //     subtitle: Row(
  //       children: [
  //         Text(userChatList.isNotEmpty ? userChatList[0] : ''),
  //       ],
  //     ),
  //     trailing: Text(userChatList.isNotEmpty ? userChatList[1] : ''),
  //     onTap: () {
  //       replace(
  //         context,
  //         UserChatView(
  //           adminId: data['uid'],
  //         ),
  //       );
  //     },
  //   );
  // }
}
