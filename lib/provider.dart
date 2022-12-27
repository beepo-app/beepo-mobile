import 'dart:io';

import 'package:beepo/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'Utils/functions.dart';

class ChatNotifier extends ChangeNotifier {
  List<String> _users = [];

  List<String> get chatUsers => _users;

  String chatText = "";

  String imageUrl = ' ';

  Reference ref = FirebaseStorage.instance.ref().child('profilepic.jpg');
  File selectedImage;

   pickUploadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75);
    ref = FirebaseStorage.instance.ref().child(image.path);
    notifyListeners();

    if (image != null) {
      ImageUtil()
          .cropProfileImage(image)
          .then((value) {
        if (value != null) {
          // setState(() {
            selectedImage = value;
            notifyListeners();
          // });
        }
      });

      await ref.putFile(File(image.path));
      ref.getDownloadURL().then((value) {
        print(value);
        imageUrl = value;
        notifyListeners();

      });
    }

  }
  cameraUploadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75);
    ref = FirebaseStorage.instance.ref().child(image.path);
    notifyListeners();

    if (image != null) {
      ImageUtil()
          .cropProfileImage(image)
          .then((value) {
        if (value != null) {
          // setState(() {
            selectedImage = value;
            notifyListeners();
          // });
        }
      });
    }
    await ref.putFile(File(image.path));
    ref.getDownloadURL().then((value) {
      print(value);
      imageUrl = value;
      notifyListeners();

    });
  }


  void storeText(newText) {
    chatText = newText;
    notifyListeners();
  }

  void clearText() {
    chatText = "";
    notifyListeners();
  }

  Map chosen = {};

  getUsers(UserModel model) async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(model.uid)
        .get();
    //
    // snap.listen((event) {
    //   _users.clear();
    //   for(var element in event.docs) {
    //     _users.add(element.data()['name']);
    //   }
    //   notifyListeners();
    // });
    chosen = (snap.data() as dynamic);
  }
}
