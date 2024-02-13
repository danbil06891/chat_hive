import 'dart:io';

import 'package:chathive/repo/auth_repo.dart';
import 'package:chathive/repo/chat_repo.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:chathive/view/admin/admin_chat_view.dart';
import 'package:chathive/view/auth/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminChatHomeView extends StatefulWidget {
  const AdminChatHomeView({super.key, this.type = ''});
  final String type;

  @override
  State<AdminChatHomeView> createState() => _AdminChatHomeViewState();
}

class _AdminChatHomeViewState extends State<AdminChatHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat with Users'),
        actions: [
          IconButton(
              onPressed: () {
                AuthRepo().logout();
                replace(context, const LoginView());
              },
              icon: const Icon(Icons.logout))
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
                return const Center(
                  child: CircularProgressIndicator(),
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
                    List<String> subtitle = dataList[3];

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

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          child: imageUrl.isEmpty ? Text(dataTitle[0]) : null,
                        ),
                        title: Text(dataTitle),
                        subtitle: Text(dataSubTitle),
                        onTap: () {
                          replace(context, AdminChatView(userId: uid));
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

  // Widget _buildUserList(List<String>? adminChatList) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: ChatRepo().getUserByType(
  //       widget.type,
  //     ),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Text('Error');
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: Text('Loadding..'));
  //       }
  //       var data = snapshot.data;
  //       if (data!.docs.isNotEmpty) {
  //         return ListView(
  //           children: snapshot.data!.docs
  //               .map((e) => _buildUserItem(e, adminChatList))
  //               .toList(),
  //         );
  //       } else {
  //         return const Center(child: Text('No user found!'));
  //       }
  //     },
  //   );
  // }

  // Widget _buildUserItem(
  //     DocumentSnapshot document, List<String>? adminChatList) {
  //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  //   String firstLetter = ChatRepo().getFirstLetter(data['name']);

  //   return ListTile(
  //     leading: CircleAvatar(
  //         backgroundImage: data['imageUrl'].isNotEmpty
  //             ? NetworkImage(data['imageUrl'])
  //             : null,
  //         child: data['imageUrl'].isEmpty ? Text(firstLetter) : null),
  //     title: Row(
  //       children: [
  //         Text(data['type']),
  //         const SizedBox(
  //           width: 5,
  //         ),
  //         Text(data['name']),
  //       ],
  //     ),
  //     subtitle: adminChatList != null
  //         ? ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: adminChatList.length,
  //             itemBuilder: (context, index) {
  //               return Text(adminChatList[index]);
  //             },
  //           )
  //         : const SizedBox(),
  //     // trailing: Text(adminChatList!.isNotEmpty ? adminChatList[1] : ''),
  //     onTap: () {
  //       replace(
  //           context,
  //           AdminChatView(
  //             userId: data['uid'],
  //           ));
  //     },
  //   );
  // }
}
