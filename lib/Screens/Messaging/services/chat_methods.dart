import 'package:beepo/Widgets/snack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class ChatMethods {
  void storeMessages({
    BuildContext context,
    String text,
    String userID,
    String receiverID,
    List searchKeywords,
    String userName,
    String img,
    String displayName,
    bool swiped,
    String replyMessage,
    String replyName,
    String replyUsername,
    encrypt.Key key,
    encrypt.IV iv,
  }) async {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(text, iv: iv);

      await FirebaseFirestore.instance
          .collection("conversation")
          .doc(userID)
          .collection("currentConversation")
          .doc(receiverID)
          .set({
        'text': encrypted.base64,
        'sender': userID,
        'receiver': receiverID,
        'name': userName,
        'displayName': displayName,
        'image': img,
        'created': Timestamp.now(),
        'searchKeywords': searchKeywords,
        'type': 'message',
        // 'key': key.base64,
        // 'iv': iv.base64,
      });
      await FirebaseFirestore.instance
          .collection("conversation")
          .doc(receiverID)
          .collection("currentConversation")
          .doc(userID)
          .set({
        'text': encrypted.base64,
        'sender': userID,
        'receiver': receiverID,
        'created': Timestamp.now(),
        'searchKeywords': searchKeywords,
        'type': 'message',

        // 'key': key.base64,
        // 'iv': iv.base64,
      });

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(userID)
          .collection('userMessages')
          .doc(receiverID)
          .collection('messageList')
          .add({
        'text': encrypted.base64,
        'sender': userID,
        'receiver': receiverID,
        'created': Timestamp.now(),
        'type': 'message',
        'swiped': swiped,
        'replyMessage' : replyMessage,
        'replyName': replyName,
        'replyUser' : replyUsername,
        // 'key': key.base64,
        // 'iv': iv.base64,
      });

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(receiverID)
          .collection('userMessages')
          .doc(userID)
          .collection('messageList')
          .add({
        'text': encrypted.base64,
        'sender': userID,
        'receiver': receiverID,
        'created': Timestamp.now(),
        'type': 'message',
        'swiped': swiped,
        'replyMessage' : replyMessage,
        'replyName': replyName,
        'replyUser' : replyUsername,
        // 'key': key.base64,
        // 'iv': iv.base64,
      });
    } catch (e) {
      displaySnack(context, "Please check your internet connection");
    }
  }

  void storeGroupMessages({
    BuildContext context,
    String text,
    String sender,
    List searchKeywords,
    String userName,
    String image,
    String displayName,
    bool swiped,
    String replyMessage,
    String replyName,
    String replyUsername,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("groups").doc('beepo').set({
        'text': text,
        'sender': sender,
        'userName': userName,
        'displayName': displayName,
        'image': image,
        'created': Timestamp.now(),
        'searchKeywords': searchKeywords,
        'type': 'message',
        'swiped': swiped,
        'replyMessage' : replyMessage,
        'replyName': replyName,
        'replyUser' : replyUsername,
      });

      await FirebaseFirestore.instance.collection('groupMessages').add({
        'text': text,
        'sender': sender,
        'created': Timestamp.now(),
        'type': 'message',
        'image': image,
        'userName': userName,
        'displayName': displayName,
        'swiped': swiped,
        'replyMessage' : replyMessage,
        'replyName': replyName,
        'replyUser' : replyUsername,
      });
    } catch (e) {
      displaySnack(context, "Please check your internet connection");
    }
  }
}
