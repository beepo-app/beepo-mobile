import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:beepo/Service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

class VoiceNote extends StatefulWidget {
  ScrollController scrollController;
  VoiceNote(this.scrollController);
  // const VoiceNote({Key? key}) : super(key: key);

  @override
  State<VoiceNote> createState() => _VoiceNoteState();
}

class _VoiceNoteState extends State<VoiceNote> {

  bool isPlayingMsg = false, isRecording = false, isSending = false;
  Future _loadFile(Uri url) async {
    final bytes = await readBytes(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        recordFilePath = file.path;
        isPlayingMsg = true;
        print(isPlayingMsg);
      });
      await play();
      setState(() {
        isPlayingMsg = false;
        print(isPlayingMsg);
      });
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
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isSending = true;
      });
      await uploadAudio();

      setState(() {
        isPlayingMsg = false;
      });
    }
  }

  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        recordFilePath,
        isLocal: true,
      );
    }
  }

  String recordFilePath;
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
          "senderId": AuthService().uid,
          "receiverUserId": receiverId,
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "content": audioMsg,
          "type": 'audio'
        });
      }).then((value) {
        setState(() {
          isSending = false;
        });
      });
      widget.scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print("Hello");
    }
  }

  uploadAudio() {
    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(
        'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}}.jpg');

    UploadTask task = firebaseStorageRef.putFile(File(recordFilePath));
    task.then((value) async {
      print('##############done#########');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      await sendAudioMsg(strVal);
    }).catchError((e) {
      print(e);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
