import 'dart:async';
import 'package:chathive/models/message_model.dart';
import 'package:chathive/utills/local_storage.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRepo extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static final firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      {required String appUserId,
      required String adminId,
      required String message}) async {
    String rol = LocalStorage.getString(key: 'role');

    final Timestamp timestamp = Timestamp.now();
    int now = DateTime.now().millisecondsSinceEpoch;
    Message newMessage = Message(
      senderId: rol == 'Admin' ? adminId : appUserId,
      message: message,
      timeStamp: timestamp,
      receiverId: rol == 'Admin' ? appUserId : adminId,
    );

    String chatRoomId =
        constructChatRoomId(adminId: adminId, appUserId: appUserId);

    await firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection(chatRoomId)
        .doc(now.toString())
        .set(newMessage.toMap());
  }

  Stream<List<Message>> getMessageStream(String chatRoomId) {
    return firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection(chatRoomId)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message(
          senderId: doc['senderId'],
          message: doc['message'],
          timeStamp: doc['timeStamp'],
          receiverId: doc['receiverId'],
        );
      }).toList();
    });
  }

  Stream<QuerySnapshot> getUserByType(
    String type,
  ) {
    try {
      if (type == 'Admin') {
        return firebaseFirestore
            .collection('users')
            .where('type', isEqualTo: 'User')
            .snapshots();
      } else {
        return firebaseFirestore
            .collection('users')
            .where('type', isEqualTo: 'Admin')
            .snapshots();
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<String> getCurrentMessage(String chatRoomId) async {
    String currentMessage = '';

    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection(chatRoomId)
          .orderBy('timeStamp', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        currentMessage = querySnapshot.docs.first.get('message');
      }
    } catch (e) {
      print(e);
    }
    print('Message: $currentMessage');
    return currentMessage;
  }

  String getFirstLetter(String str) {
    String result = '';

    if (str.isNotEmpty) {
      result = str[0];
    } else {
      result = '';
    }

    return result.toString();
  }
}
