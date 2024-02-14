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
            future: ChatRepo().getAllUserAdminDetails(widget.type),
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
                    print('index: $index');
                    print('subTitle: $dataSubTitle');
                    return ListTile(
                      trailing:  Text(time) ,
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : Image.asset('assets/images/profile.png').image,
                      ),
                      title: Text(dataTitle),
                      subtitle: Text(dataSubTitle),
                      onTap: () {
                        replace(context, AdminChatView(userId: uid));
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
