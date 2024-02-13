import 'package:chathive/constants/color_constant.dart';
import 'package:chathive/repo/auth_repo.dart';
import 'package:chathive/repo/chat_repo.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:chathive/view/admin/admin_chat_view.dart';
import 'package:chathive/view/auth/login_view.dart';
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
        title: const Text(
          'Chat with Users',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                AuthRepo().logout();
                replace(context, const LoginView());
              },
              icon: const Icon(
                Icons.logout,
                color: whiteColor,
              ))
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
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    List<List<String>> dataList = snapshot.data!;
                    List<String>? title = dataList[0];
                    List<String> userUid = dataList[1];
                    List<String> image = dataList[2];
                    List<String> timeStamp = dataList[3];
                    List<String> subtitle = dataList[4];

                    if (index < title.length &&
                        index < userUid.length &&
                        index < subtitle.length &&
                        index < image.length &&
                        index < timeStamp.length
                        ) {
                      String? dataTitle = title[index];
                      String? dataSubTitle = subtitle[index];
                      String? uid = userUid[index];
                      String? imageUrl = image[index];
                      String time = timeStamp[index];

                      return ListTile(
                        trailing: time.isNotEmpty ? Text(time) : null,
                        leading: CircleAvatar(
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl.isEmpty ? Text(dataTitle[0]) : null,
                        ),
                        title: Text(dataTitle),
                        subtitle: Text(dataSubTitle),
                        onTap: () {
                          replace(context, AdminChatView(userId: uid));
                        },
                      );
                    } else {
                      return const SizedBox();
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
}
