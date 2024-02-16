import 'package:chathive/constants/color_constant.dart';
import 'package:chathive/repo/auth_repo.dart';
import 'package:chathive/repo/chat_repo.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:chathive/view/admin/admin_chat_view.dart';
import 'package:chathive/view/auth/login_view.dart';
import 'package:chathive/view/widgets/custom_search_textfield.dart';
import 'package:flutter/material.dart';

class AdminChatHomeView extends StatefulWidget {
  const AdminChatHomeView({super.key, this.type = ''});
  final String type;

  @override
  State<AdminChatHomeView> createState() => _AdminChatHomeViewState();
}

class _AdminChatHomeViewState extends State<AdminChatHomeView> {
  TextEditingController searchController = TextEditingController();
  bool isClick = false;
  List<List<String>> filterList = [];
  late List<List<String>> dataList;
  List<List<String>> filterQuery(List<List<String>> dataList, String query) {
    if (query.isEmpty) {
      return dataList;
    }
    List<List<String>> filteredQuery = [
      [],
      [],
      [],
      [],
      [],
    ];
    for (int i = 0; i < dataList[0].length; i++) {
      if (dataList[0][i].toLowerCase().contains(query.toLowerCase())) {
        filteredQuery[0].add(dataList[0][i]);
        filteredQuery[1].add(dataList[1][i]);
        filteredQuery[2].add(dataList[2][i]);
        filteredQuery[3].add(dataList[3][i]);
        filteredQuery[4].add(dataList[4][i]);
      }
    }

    return filteredQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isClick
          ? PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                backgroundColor: textFieldColor,
                title: SizedBox(
                  height: 55,
                  child: CustomSearchTextField(
                    fillerColor: whiteColor,
                    prefixIcon: IconButton(
                        onPressed: () {
                          replace(context, const AdminChatHomeView());
                        },
                        icon: const Icon(Icons.arrow_back)),
                    hintText: 'search',
                    controller: searchController,
                    onChange: (value) {
                      setState(() {
                        filterList = filterQuery(dataList, value);
                      });
                    },
                  ),
                ),
              ),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'Chat with Users',
                style: TextStyle(color: whiteColor),
              ),
              backgroundColor: primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isClick = !isClick;
                      });
                    },
                    icon: const Icon(
                      Icons.search,
                      color: whiteColor,
                    )),
                IconButton(
                  onPressed: () {
                    AuthRepo().logout();
                    replace(context, const LoginView());
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: whiteColor,
                  ),
                ),
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

              dataList = snapshot.data!;

              List<List<String>> filterList =
                  filterQuery(dataList, searchController.text);

              return Expanded(
                child: ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: filterList[0].length,
                      itemBuilder: (context, index) {
                        String title = index < filterList[0].length
                            ? filterList[0][index]
                            : '';
                        String uid = index < filterList[1].length
                            ? filterList[1][index]
                            : '';
                        String imageUrl = index < filterList[2].length
                            ? filterList[2][index]
                            : '';
                        String time = index < filterList[3].length
                            ? filterList[3][index]
                            : '';
                        String currentMessage = index < filterList[4].length
                            ? filterList[4][index]
                            : '';

                        return ListTile(
                          trailing: Text(time),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl)
                                : Image.asset('assets/images/profile.png')
                                    .image,
                          ),
                          title: Text(title),
                          subtitle: Text(currentMessage),
                          onTap: () {
                            replace(context, AdminChatView(userId: uid));
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
