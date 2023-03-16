// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'Utils/functions.dart';

class ChatNotifier extends ChangeNotifier {
  List<String> _users = [];

  List<String> get chatUsers => _users;
  String chatText = "";

  String imageUrl = ' ';

  String photoUrl;
  Map userM = Hive.box('beepo').get('userData');

  Reference ref = FirebaseStorage.instance.ref();
  File selectedImage;
  File selectedImageForChat;

  // String decrypted;
  Encrypted encrypted;

  //  preload(BuildContext context, String path) {
  //   final configuration = createLocalImageConfiguration(context);
  //   return NetworkImage(path).resolve(configuration);
  // }
  Future<String> encrypt(String text) async {
    var helper = RsaKeyHelper();

    final serverPublicKey =
        await parseKeyFromFile<RSAPublicKey>('test/public.pem');

    final privateKey =
        await parseKeyFromFile<RSAPrivateKey>('test/private.pem');

    final encrypterer = Encrypter(
      RSA(
        publicKey: helper.parsePublicKeyFromPem(serverPublicKey),
        privateKey: helper.parsePrivateKeyFromPem(privateKey),
        encoding: RSAEncoding.PKCS1,
      ),
    );

    encrypted = encrypterer.encrypt(text);
    notifyListeners();

    return encrypted.base16;
  }

  decrypt(Encrypted encrypting) async {
    var helper = RsaKeyHelper();

    final serverPublicKey =
        await parseKeyFromFile<RSAPublicKey>('test/public.pem');

    final privateKey =
        await parseKeyFromFile<RSAPrivateKey>('test/private.pem');

    final encrypterer = Encrypter(
      RSA(
        publicKey: helper.parsePublicKeyFromPem(serverPublicKey),
        privateKey: helper.parsePrivateKeyFromPem(privateKey),
        encoding: RSAEncoding.PKCS1,
      ),
    );
    String decrypted = encrypterer.decrypt16(encrypting.base16);
    return decrypted;
    // notifyListeners();
  }

  pickUploadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75);
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

  pickUploadImageChat(String id, BuildContext context) async {


    List<AssetEntity> image;
    // Reference reg = FirebaseStorage.instance.ref();
    try {
      image = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.all,
          selectedAssets: [

          ]
        ),
      );

      ref = FirebaseStorage.instance.ref().child('image.png');
      notifyListeners();

      if (image != null) {
        File file = await image.first.file;

        await ref.putFile(file);
        ref.getDownloadURL().then((value) {
          print(value);
          photoUrl = value;
          notifyListeners();
          sendPhotoMsg(photoUrl, receiverId: id);
        });
      }
    } on PlatformException catch (e) {
      print(e.message);
    }

// }
  }

  sendPhotoMsg(String photoMsg, {String receiverId}) async {
    if (photoMsg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection('messages')
          .doc(userM['uid'])
          .collection('userMessages')
          .doc(receiverId)
          .collection('messageList')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref, {
          "sender": userM['uid'],
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": photoMsg,
          // "duration": dure.inSeconds.toString(),
          "type": 'photo'
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
          .doc(userM['uid'])
          .collection('messageList')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref1, {
          "sender": userM['uid'],
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": photoMsg,
          // "duration": dure.inSeconds.toString(),
          "type": 'photo'
        });
      }).then((value) {
        // setState(() {
        isSending = false;
        notifyListeners();
        // });
      });

      var ref2 = FirebaseFirestore.instance
          .collection("conversation")
          .doc(userM['uid'])
          .collection("currentConversation")
          .doc(receiverId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref2, {
          "sender": userM['uid'],
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": photoMsg,
          // "duration": dure.inSeconds.toString(),
          "type": 'photo'
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
          .doc(userM['uid']);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref3, {
          "sender": userM['uid'],
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": photoMsg,
          // "duration": dure.inSeconds.toString(),
          "type": 'photo'
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

  cameraUploadImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75);
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

  cameraUploadImageChat(String id) async {
    Reference reh = FirebaseStorage.instance.ref();

    final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75);
    reh = FirebaseStorage.instance.ref().child(image.path);
    notifyListeners();

    if (image != null) {
      File file = File(image.path);
      await ImageUtil().cropProfileImage(file).then((value) {
        if (value != null) {
          // setState(() {
          selectedImageForChat = value;
          notifyListeners();
          // });
        }
      });
    }
    await reh.putFile(File(image.path));
    reh.getDownloadURL().then((value) {
      print(value);
      photoUrl = value;
      notifyListeners();
      sendPhotoMsg(photoUrl, receiverId: id);
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
      // isPlayingMsg = true;
      // file.
      // notifyListeners();
      // print(isPlayingMsg);
      // });
      await play();
      // Future.delayed(dure);
      // isPlayingMsg = false;
      // setState(() {

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

  Future<bool> checkPermissionImage() async {
    if (!await Permission.photos.isGranted) {
      PermissionStatus status = await Permission.photos.request();
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

  void cancelRecord() {
    RecordMp3.instance.stop();
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
      // isPlayingMsg = false;
      // notifyListeners();
      // });
    }
  }

  void pauseAudio() async {
    AudioPlayer player = AudioPlayer();
    player.setUrl(recordFilePath, isLocal: true);
    await player.pause();
  }

  Duration dure = const Duration();

  durationCalc() {
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setUrl(recordFilePath, isLocal: true);
    audioPlayer.onDurationChanged.listen((Duration event) {
      dure = event;
      notifyListeners();
      print(event);
    });
  }

  String img = '';
  String displayName = '';
  String userName = '';

  void getProfileData(String usi) async {
    var profile =
        await FirebaseFirestore.instance.collection('users').doc(usi).get();

    // setState(() {
    img = profile['image'];
    notifyListeners();

    displayName = profile['name'];
    notifyListeners();
    userName = profile['userName'];
    notifyListeners();
    // });
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
          .doc(userM['uid'])
          .collection('userMessages')
          .doc(receiverId)
          .collection('messageList')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref, {
          "sender": userM['uid'],
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": audioMsg,
          "duration": dure.inSeconds > 60
              ? '${dure.inMinutes}:${dure.inSeconds - dure.inMinutes * 60}'
              : '${dure.inSeconds.toString()}s',
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
          .doc(userM['uid'])
          .collection('messageList')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref1, {
          "sender": userM['uid'],
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": audioMsg,
          "duration": dure.inSeconds > 60
              ? '${dure.inMinutes}:${dure.inSeconds - dure.inMinutes * 60}'
              : '${dure.inSeconds.toString()}s',
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
          .doc(userM['uid'])
          .collection("currentConversation")
          .doc(receiverId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref2, {
          "sender": userM['uid'],
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": audioMsg,
          "duration": dure.inSeconds > 60
              ? '${dure.inMinutes}:${dure.inSeconds - dure.inMinutes * 60}'
              : '${dure.inSeconds.toString()}s',
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
          .doc(userM['uid']);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref3, {
          "sender": userM['uid'],
          "receiver": receiverId,
          "created": Timestamp.now(),
          "content": audioMsg,
          "duration": dure.inSeconds > 60
              ? '${dure.inMinutes}:${dure.inSeconds - dure.inMinutes * 60}'
              : '${dure.inSeconds.toString()}s',
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
