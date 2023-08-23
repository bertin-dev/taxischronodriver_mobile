import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taxischronodriver/modeles/discutions/message.dart';

import '../../varibles/variables.dart';

class Conversation {
  // final String idSender;
  // final String destinatorId;
  final DateTime? sendTime;
  final int? unreadMessages;
  final Message lastMessage;
  final ref = datatbase.ref("Messages").child("Conversation");
  Conversation({
    // required this.idSender,
    // required this.destinatorId,
    this.sendTime,
    this.unreadMessages,
    required this.lastMessage,
  });

  // To json

  Map<String, dynamic> toMap() => {
        // 'idSender': idSender,
        // "destinatorId": destinatorId,
        "sendTime": sendTime,
        "unreadMessages": unreadMessages,
        "lastMessage": jsonEncode(lastMessage),
      };

  // create conversation
  factory Conversation.fromMap(Map<String, dynamic> conversation) =>
      Conversation(
        // idSender: conversation['idSender'],
        // destinatorId: conversation['destinatorId'],
        sendTime: (conversation['sendTime'] as Timestamp).toDate(),
        unreadMessages: conversation['unreadMessages'],
        lastMessage: Message.fromMap(
          jsonDecode(conversation['lastMessage']),
        ),
      );

  sendMessage() async {
    final youConversation = ref
        .child('${lastMessage.destinationUserId}${lastMessage.senderUserId}');
    final myConversation = ref
        .child("${lastMessage.senderUserId}${lastMessage.destinationUserId}");
    final conversation = await myConversation.get();
    if (conversation.exists) {
      await myConversation.update({
        // 'idSender': idSender,
        // "destinatorId": destinatorId,
        "sendTime": ServerValue.timestamp,
        "unreadMessages": ServerValue.increment(1),
        "lastMessage": jsonEncode(lastMessage),
      });
      await youConversation.update({
        // 'idSender': idSender,
        // "destinatorId": destinatorId,
        "sendTime": ServerValue.timestamp,
        "unreadMessages": ServerValue.increment(1),
        "lastMessage": jsonEncode(lastMessage),
      });
    } else {
      await myConversation.set({
        // 'idSender': idSender,
        // "destinatorId": destinatorId,
        "sendTime": ServerValue.timestamp,
        "unreadMessages": 1,
        "lastMessage": jsonEncode(lastMessage),
      });
      await youConversation.update({
        // 'idSender': idSender,
        // "destinatorId": destinatorId,
        "sendTime": ServerValue.timestamp,
        "unreadMessages": 1,
        "lastMessage": jsonEncode(lastMessage),
      });
    }
    lastMessage.sendMessage();
  }
}
