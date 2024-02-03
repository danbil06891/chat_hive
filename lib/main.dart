import 'package:chathive/constants/theme_constant.dart';
import 'package:chathive/firebase_options.dart';
import 'package:chathive/repo/chat_repo.dart';
import 'package:chathive/repo/firebase_repo.dart';
import 'package:chathive/states/register_state.dart';
import 'package:chathive/utills/local_storage.dart';
import 'package:chathive/view/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseRepo().initNotification();
  
  LocalStorage.init();
  

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => RegisterState()),
      ChangeNotifierProvider(create: (context) => ChatRepo()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: getTheme(),
      home: const SplashView(),
    );
  }
}
