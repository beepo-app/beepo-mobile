import 'package:beepo/Widgets/snack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:voster/utils/snack.dart';

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
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("conversation")
          .doc(userID)
          .collection("currentConversation")
          .doc(receiverID)
          .set({
        'text': text,
        'sender': userID,
        'receiver': receiverID,
        'name': userName,
        'displayName': displayName,
        'image': img,
        'created': Timestamp.now(),
        'searchKeywords': searchKeywords,
      });
      await FirebaseFirestore.instance
          .collection("conversation")
          .doc(receiverID)
          .collection("currentConversation")
          .doc(userID)
          .set({
        'text': text,
        'sender': userID,
        'receiver': receiverID,
        'created': Timestamp.now(),
        'searchKeywords': searchKeywords,
      });

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(userID)
          .collection('userMessages')
          .doc(receiverID)
          .collection('messageList')
          .add({
        'text': text,
        'sender': userID,
        'receiver': receiverID,
        'created': Timestamp.now()
      });

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(receiverID)
          .collection('userMessages')
          .doc(userID)
          .collection('messageList')
          .add({
        'text': text,
        'sender': userID,
        'receiver': receiverID,
        'created': Timestamp.now()
      });
    } catch (e) {
      displaySnack(context, "Please check your internet connection");
    }
  }
}
