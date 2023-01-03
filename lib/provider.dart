import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

import 'Service/auth.dart';
import 'Utils/functions.dart';

class ChatNotifier extends ChangeNotifier {
  List<String> _users = [];

  List<String> get chatUsers => _users;

  String chatText = "";

  String imageUrl = ' ';

  Reference ref = FirebaseStorage.instance.ref();
  File selectedImage;

  pickUploadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 75);
    ref = FirebaseStorage.instance.ref().child(image.path);
    notifyListeners();

    if (image != null) {
      ImageUtil().cropProfileImage(image as File).then((value) {
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
        source: ImageSource.camera, maxWidth: 512, maxHeight: 512, imageQuality: 75);
    ref = FirebaseStorage.instance.ref().child(image.path);
    notifyListeners();

    if (image != null) {
      ImageUtil().cropProfileImage(image as File).then((value) {
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
    final snap =
        await FirebaseFirestore.instance.collection('users').doc(model.uid).get();
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



  bool isPlayingMsg = false, isRecording = false, isSending = false;

  Future loadFile(String url) async {
    final bytes = await readBytes(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    file.length();
    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      // setState(() {
        recordFilePath = file.path;
        notifyListeners();
        isPlayingMsg = true;
        notifyListeners();
        print(isPlayingMsg);
      // });
      await play();

      // setState(() {
        isPlayingMsg = false;
        notifyListeners();
      //   print(isPlayingMsg);
      // });
    }
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();

      RecordMp3.instance.start(recordFilePath, (type) {
        // setState(() {});
        notifyListeners();
      });
    } else {}
    // setState(() {});
    notifyListeners();
  }

  void stopRecord(String receiverId) async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      // setState(() {
        isSending = true;
        notifyListeners();
      // });
      await uploadAudio(receiverId);

      // setState(() {
        isPlayingMsg = false;
        notifyListeners();
      // });
    }
  }

  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        recordFilePath,
        isLocal: true,
      );
      // setState(() {
      //   isPlayingMsg = false;
      // });
      // audioPlayer;
    }
  }

  String recordFilePath;
  ScrollController scrollController = ScrollController();


  // = ScrollController();

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  sendAudioMsg(String audioMsg, {String receiverId}) async {
    if (audioMsg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection('messages')
          .doc(AuthService().uid)
          .collection('userMessages')
          .doc(receiverId)
          .collection('messageList')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          "sender": AuthService().uid,
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": audioMsg,
          "type": 'audio'
        });
      }).then((value) {
        // setState(() {
          isSending = false;
          notifyListeners();
        // });
      });

      var ref1 = FirebaseFirestore.instance
          .collection('messages')
          .doc(receiverId)
          .collection('userMessages')
          .doc(AuthService().uid)
          .collection('messageList')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref1, {
          "sender": AuthService().uid,
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": audioMsg,
          "type": 'audio'
        });
      }).then((value) {
        // setState(() {
        isSending = false;
        notifyListeners();
        // });
      });

      var ref2 = FirebaseFirestore.instance
          .collection("conversation")
          .doc(AuthService().uid)
          .collection("currentConversation")
          .doc(receiverId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref2, {
          "sender": AuthService().uid,
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": audioMsg,
          "type": 'audio'
        });
      }).then((value) {
        // setState(() {
        isSending = false;
        notifyListeners();
        // });
      });

      var ref3 = FirebaseFirestore.instance
          .collection("conversation")
          .doc(receiverId)
          .collection("currentConversation")
          .doc(AuthService().uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref3, {
          "sender": AuthService().uid,
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": audioMsg,
          "type": 'audio'
        });
      }).then((value) {
        // setState(() {
        isSending = false;
        notifyListeners();
        // });
      });
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print("Hello");
    }
  }

  uploadAudio(String id) {
    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}}.jpg');

    UploadTask task = firebaseStorageRef.putFile(File(recordFilePath));
    task.then((value) async {
      print('##############done#########');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      await sendAudioMsg(strVal, receiverId: id);
    }).catchError((e) {
      print(e);
    });
  }
}
