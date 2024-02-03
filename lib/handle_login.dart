import 'package:chathive/repo/user_repo.dart';
import 'package:chathive/view/admin/admin_CHAT_home_view.dart';
import 'package:chathive/view/auth/login_view.dart';
import 'package:chathive/view/user/user_chat_home_view.dart';
import 'package:flutter/material.dart';

class HandleLogin extends StatefulWidget {
  const HandleLogin({super.key});

  @override
  State<HandleLogin> createState() => _HandleLoginState();
}

class _HandleLoginState extends State<HandleLogin> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: AuthRepo.instance.isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginView();
        } else if (snapshot.data == 'User') {
          return const UserChatHomeView(type: 'User',);
        } else if (snapshot.data == 'Admin') {
          return const AdminChatHomeView(type: 'Admin',);
        } else {
          return const LoginView();
        }
      },
    );
  }
}
