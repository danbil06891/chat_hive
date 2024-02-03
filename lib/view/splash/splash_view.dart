import 'package:chathive/view/auth/login_view.dart';
import 'package:flutter/material.dart';
import '../../constants/color_constant.dart';
import '../../utills/snippets.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      replace(context, const LoginView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Image.asset('assets/images/logo.png', height: 200, width: 200),
      ),
    );
  }
}
