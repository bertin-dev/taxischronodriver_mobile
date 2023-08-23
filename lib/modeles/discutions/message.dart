import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../varibles/variables.dart';

class Message {
  final String senderUserId;
  final String destinationUserId;
  final String libelle;
  final String type;
  final DateTime? sendTime;
  final bool isRead;
  final String messageId;
  final ref = datatbase.ref("Messages").child("Conversation");
  Message({
    required this.senderUserId,
    required this.destinationUserId,
    required this.libelle,
    required this.messageId,
    required this.type,
    this.sendTime,
    required this.isRead,
  });

// FromMap methode
  factory Message.fromMap(Map<String, dynamic> message) => Message(
        senderUserId: message['senderUserId'],
        destinationUserId: message['destinationUserId'],
        libelle: message['libelle'],
        type: message['type'],
        sendTime: (message['sendTime'] as Timestamp).toDate(),
        isRead: message['isRead'],
        messageId: message['messageId'],
      );

  sendMessage() async {
    final myMessages =
        ref.child("$senderUserId$destinationUserId").child("Tchats");
    final yourMessages =
        ref.child("$destinationUserId$senderUserId").child("Tchats");
    await myMessages.child(messageId).set({
      'senderUserId': senderUserId,
      'destinationUserId': destinationUserId,
      "libelle": libelle,
      'type': type,
      "sendTime": ServerValue.timestamp,
      "isRead": false,
      "messageId": messageId,
    });
    await yourMessages.child(messageId).set({
      'senderUserId': senderUserId,
      'destinationUserId': destinationUserId,
      "libelle": libelle,
      'type': type,
      "sendTime": ServerValue.timestamp,
      "isRead": false,
      "messageId": messageId,
    });
  }
}
