
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String message;
  Timestamp timeStamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
    
  });

  Message copyWith({
    String? senderId,
    String? receiverId,
    String? message,
    Timestamp? timestamp
    
  
  }) { 
    return Message(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timeStamp: timeStamp,
      
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timeStamp': timeStamp,
     
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    print('senderId---------------------- ${map['senderId']}');
    print('receiverId---------------------- ${map['receiverId']}');
    print('timeStamp---------------------- ${map['timeStamp']}');
    print('message---------------------- ${map['message']}');
    

    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timeStamp: map['timeStamp'] ?? 0, 
      
    );
  }
}
