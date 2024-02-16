import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String message;
  Timestamp timeStamp;
  bool isSeen;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
    required this.isSeen,
  });

  Message copyWith({
    String? senderId,
    String? receiverId,
    String? message,
    Timestamp? timestamp,
    bool? isSeen,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timeStamp: timeStamp,
      isSeen: isSeen!,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timeStamp': timeStamp,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timeStamp: map['timeStamp'] ?? 0,
      isSeen: map['isSeen'] ?? '',
    );
  }
}
