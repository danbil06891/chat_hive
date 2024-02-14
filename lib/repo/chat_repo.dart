import 'dart:async';
import 'package:chathive/models/message_model.dart';
import 'package:chathive/utills/local_storage.dart';
import 'package:chathive/utills/snippets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

 

  

  Future<List<List<String>>> getAllUserAdminDetails(String type) async {
    List<List<String>> userDataList = [
      <String>[],
      <String>[],
      <String>[],
      <String>[],
      <String>[],
    ];

    QuerySnapshot? querySnapshot;

    try {
      if (type == 'Admin') {
        querySnapshot = await firebaseFirestore
            .collection('users')
            .where('type', isEqualTo: 'User')
            .get();
      } else {
        querySnapshot = await firebaseFirestore
            .collection('users')
            .where('type', isEqualTo: 'Admin')
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          String uid = doc.get('uid');

          // Add user data to respective lists
          userDataList[0].add(doc.get('name'));
          userDataList[1].add(uid); // UID
          userDataList[2].add(doc.get('imageUrl'));

          String formattedTime = '';
          String message = '';

          
          String chatRoomId = '';
          if (type == 'User') {
            chatRoomId = constructChatRoomId(
                adminId: uid, appUserId: firebaseAuth.currentUser!.uid);
          } else if (type == 'Admin') {
            chatRoomId = constructChatRoomId(
                adminId: firebaseAuth.currentUser!.uid, appUserId: uid);
          }

          
          QuerySnapshot messageSnapshot = await firebaseFirestore
              .collection('chat_rooms')
              .doc(chatRoomId)
              .collection(chatRoomId)
              .orderBy('timeStamp', descending: true)
              .limit(1)
              .get();

          if (messageSnapshot.docs.isNotEmpty) {
            Timestamp timeStamp = messageSnapshot.docs[0].get('timeStamp');
            DateTime dateTime = timeStamp.toDate();
            formattedTime = DateFormat('h:mm a').format(dateTime);
            message = messageSnapshot.docs[0].get('message');
          }

          userDataList[3].add(formattedTime);
          userDataList[4].add(message);
        }
      }
    } catch (e) {
      print('Error getting sender IDs for admin: $e');
    }
    print('listOfMessages: $userDataList');
    return userDataList;
  }
}
