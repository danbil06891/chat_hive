import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseRepo {
  final _firebaseMessaging = FirebaseMessaging.instance;
   
  // Future<void> handleBackgroundMessage(RemoteMessage message) async{
  //   print('Title: ${message.notification?.title}');
  //   print('Body: ${message.notification?.body}');
  //   print('Payload: ${message.data}');
  // }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();

    print('Token: $fcmToken');

     //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
