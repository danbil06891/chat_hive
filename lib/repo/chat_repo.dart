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

  Future<List<String>> getCurrentMessage(String chatRoomId) async {
    List<String> messageList = [];

    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection(chatRoomId)
          .orderBy('timeStamp', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        messageList.add(querySnapshot.docs.first.get('message'));
        Timestamp timeStamp = querySnapshot.docs.first.get('timeStamp');

        DateTime dateTime = timeStamp.toDate();

        String formattedTime = DateFormat('h:mm a').format(dateTime);
        messageList.add(formattedTime);
        //  messageList.add(dateTime.toString());
      }
    } catch (e) {
      print(e);
    }
    print('Message: $messageList');
    return messageList;
  }

  void update(String val){
    print('ss');
  }

  Future<List<List<String>>> getAllSenderIdsForAdmin(String type) async {
    List<List<String>> userDataList = [
      <String>[],
      <String>[],
      <String>[],
      <String>[],
      <String>[],
    ];

    QuerySnapshot? querySnapshot;
    String chatRoomId;
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

          userDataList[0].add(doc.get('name'));
          userDataList[1].add(doc.get('uid'));
          userDataList[2].add(doc.get('imageUrl'));

          if (type == 'User') {
            chatRoomId = constructChatRoomId(
                adminId: 'Admin', appUserId: firebaseAuth.currentUser!.uid);
          } else {
            chatRoomId = constructChatRoomId(adminId: 'Admin', appUserId: uid);
          }

          QuerySnapshot querySnapshot = await firebaseFirestore
              .collection('chat_rooms')
              .doc(chatRoomId)
              .collection(chatRoomId)
              .orderBy('timeStamp', descending: true)
              .limit(1)
              .get();

          for (var element in querySnapshot.docs) {
            Timestamp timeStamp = element.get('timeStamp');
            DateTime dateTime = timeStamp.toDate();
            String formattedTime = DateFormat('h:mm a').format(dateTime);
            userDataList[3].add(formattedTime);
            userDataList[4].add(element.get('message'));
          }
        }
      }
    } catch (e) {
      print('Error getting sender IDs for admin: $e');
    }
    print('listOfMessages: $userDataList');
    return userDataList;
  }
}
