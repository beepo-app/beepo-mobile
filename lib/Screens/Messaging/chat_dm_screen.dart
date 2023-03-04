// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:beepo/Screens/Messaging/calls/calls.dart';
import 'package:beepo/Screens/Messaging/record.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as navy;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:uuid/uuid.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../bottom_nav.dart';
import 'calls/calll_notify.dart';
import 'services/chat_methods.dart';
import '../../components.dart';
import '../../generate_keywords.dart';
import '../../provider.dart';
import '../Profile/user_profile_screen.dart';

const APP_ID = '29454d2c6f01445fbbb6db095adec156';

class ChatDm extends StatefulWidget {
  final UserModel model;

  const ChatDm({this.model});

  @override
  State<ChatDm> createState() => _ChatDmState();
}

class _ChatDmState extends State<ChatDm> with SingleTickerProviderStateMixin {
  TextEditingController messageController = TextEditingController();
  bool isTyping = true;
  AnimationController controller;
  String player;
  String tokens;

  Map userM = Hive.box('beepo').get('userData');
  int isPlaying;

  var uuid = Uuid();
  String _currentUuid;

  bool swiped = false;

  getId() async {
    final get = await FirebaseFirestore.instance
        .collection('OneSignal')
        .doc(widget.model.uid)
        .get();

    setState(() {
      player = get['playerId'];
    });
  }

  getToken() async {
    final get = await FirebaseFirestore.instance
        .collection('FCMToken')
        .doc(widget.model.uid)
        .get();

    setState(() {
      tokens = get['token'];
    });
  }

//One Signal
  Future<Response> sendNotification(
      {List<String> tokenIdList, String contents, String heading}) async {
    String _debugLabelString = "";

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: $event');

      /// Display Notification, send null to not display
      // event.notification.
      event.complete(OSNotification({
        "app_id": "8f26effe-fda3-4034-a262-be12f4c5c47e",
        //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,
        //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FFFF9C34",

        "small_icon": "ic_launcher",

        "large_icon": userM['profilePictureUrl'],

        "headings": {"en": heading},

        "contents": {"en": contents},
        "android_background_layout": {
          "image": "https://domain.com/background_image.jpg",
          "headings_color": "FFFF0000",
          "contents_color": "FF0d004c"
        }
      }));
      setState(() {
        _debugLabelString =
            "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
      print(_debugLabelString);
    });
    // OneSignal.shared.
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "8f26effe-fda3-4034-a262-be12f4c5c47e",
        //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,
        //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FFFF9C34",

        "small_icon": "ic_launcher",

        "large_icon": userM['profilePictureUrl'],

        "headings": {"en": heading},

        "contents": {"en": contents},
        "android_background_layout": {
          "image": "https://domain.com/background_image.jpg",
          "headings_color": "FFFF0000",
          "contents_color": "FF0d004c"
        }
      }),
    );
  }

  int _messageCount = 0;

  String constructFCMPayload(String token, bool video) {
    _messageCount++;
    return jsonEncode({
      "to": token,
      "collapse_key": "New Message",
      "priority": "high",
      "notification": {
        "title": "Title of Your Notification",
        "body": "Body of Your Notification",
      },
      "data": {
        "name": userM['displayName'],
        "uid": userM['uid'],
        // model: widget.model,
        "hasVideo": "$video",
        "userName": userM['username'],
        "image": userM['profilePictureUrl'],
        "channelName": userM['uid'],
        // context: context,
      }
    });
  }

  Future<void> sendPushMessage(bool video) async {
    if (tokens == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAI_k21-0:APA91bEhToRGxcNDYLkqXBBxhVWFBnrq7qeHc0bh3DE_w1cOzp39rjXTDW8J3mql7UI-LWuAzWi7Vh4ifvT0zz1pRqLZSldLuEshgxSjqEwvJAnO0P1zUjPfNwOBx6hm_xRGN9N1CM9s'
        },
        body: constructFCMPayload(tokens, video),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  checkAndNavigationCallingPage(bool video, String channel) async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      navy.Get.to(
        VideoCall(
          channelName: channel,
          // channelName: '${userM['displayName'] + widget.model.name}',
          role: ClientRole.Broadcaster,
          name: widget.model,
          isVideo: video,
        ),
      );
      // NavigationService.instance
      //     .pushNamedIfNotCurrent(AppRoute.callingPage, args: currentCall);
    }
  }

  // @override
  Future<void> didChangeAppLifecycleState(
      AppLifecycleState state, String channel) async {
    print(state);
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      checkAndNavigationCallingPage(false, channel);
    }
  }

  @override
  void initState() {
    // initFirebase(true);
    controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 100000),
      reverseDuration: Duration(microseconds: 100000),
    );
    FirebaseAuth.instance.signInAnonymously();
    isPlaying = -1;
    getId();
    getToken();

    messageController.addListener(() {
      setState(() {});
    });
    //
    // FlutterIncomingCall.onEvent.listen((event) {
    //   setState(() {
    //     _lastEvent = event;
    //   });
    //   if (event is CallEvent) {
    //     setState(() {
    //       _lastCallEvent = event;
    //     });
    //   } else if (event is HoldEvent) {
    //     setState(() {
    //       _lastHoldEvent = event;
    //     });
    //   } else if (event is MuteEvent) {
    //     setState(() {
    //       _lastMuteEvent = event;
    //     });
    //   } else if (event is DmtfEvent) {
    //     setState(() {
    //       _lastDmtfEvent = event;
    //     });
    //   } else if (event is AudioSessionEvent) {
    //     setState(() {
    //       _lastAudioSessionEvent = event;
    //     });
    //   }
    // });
    // initFirebase();
    super.initState();
  }

  String replyMessage = '';
  String uName = '';
  String dName = '';

  final focusNode = FocusNode();

  void replyToMessage(String message, String userName, String name) {
    setState(() {
      replyMessage = message;
      uName = userName;
      dName = name;
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var isReplying = replyMessage != '';
    bool rightSwiped = false;
    bool leftSwiped = false;

    return KeyboardDismisser(
      gestures: const [GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: Scaffold(
          backgroundColor: Colors.white,
          //const Color(0xffECE5DD),
          body: Container(
            color: Colors.white,
            //const Color(0xffECE5DD),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5, right: 13),
                    height: 110,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xff0e014c),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_outlined,
                                size: 28,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomNavHome())),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProfile(
                                              model: UserModel(
                                                  uid: widget.model.uid,
                                                  name: widget.model.name,
                                                  userName:
                                                      widget.model.userName,
                                                  image: widget.model.image,
                                                  searchKeywords: widget
                                                      .model.searchKeywords),
                                            )));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(19),
                                child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: CachedNetworkImage(
                                    height: 35,
                                    width: 35,
                                    imageUrl: widget.model.image,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      color: secondaryColor,
                                    ),
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProfile(
                                              model: UserModel(
                                                  uid: widget.model.uid,
                                                  name: widget.model.name,
                                                  userName:
                                                      widget.model.userName,
                                                  image: widget.model.image,
                                                  searchKeywords: widget
                                                      .model.searchKeywords),
                                            )));
                              },
                              child: Text(
                                widget.model.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff08aa48),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                Calls().startCall(
                                    uid: uuid.v4(),
                                    name: widget.model.name,
                                    userName: widget.model.userName,
                                    hasVideo: true,
                                    model: widget.model,
                                    channel: userM['uid']);
                                await sendPushMessage(true);

                                checkAndNavigationCallingPage(
                                    true, userM['uid']);
                              },
                              child: SizedBox(
                                  height: 23,
                                  width: 23,
                                  child: SvgPicture.asset(
                                      'assets/video_call.svg')),
                            ),
                            SizedBox(width: 17),
                            GestureDetector(
                              onTap: () async {
                                Calls().startCall(
                                    uid: uuid.v4(),
                                    name: widget.model.name,
                                    userName: widget.model.userName,
                                    hasVideo: false,
                                    model: widget.model,
                                    channel: userM['uid']);
                                await sendPushMessage(false);
                                checkAndNavigationCallingPage(
                                    false, userM['uid']);
                              },
                              child: Icon(
                                Icons.call,
                                size: 23,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(
                              Icons.more_vert_outlined,
                              color: Colors.white,
                              size: 23,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.white,
                    //Color(0xffECE5DD),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .doc(userM['uid'])
                            .collection("userMessages")
                            .doc(widget.model.uid)
                            .collection("messageList")
                            .orderBy("created", descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              reverse: true,
                              controller:
                                  context.read<ChatNotifier>().scrollController,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                Timestamp time =
                                    snapshot.data.docs[index]['created'];
                                // var day = time.toDate().day.toString();
                                // var month = time.toDate().month.toString();
                                // var year =
                                //     time.toDate().toString().substring(2);
                                // var date = day + '-' + month + '-' + year;
                                var hour = time.toDate().hour;
                                // var min = time.toDate().minute;
                                final encrypter = enc.Encrypter(
                                    enc.AES(enc.Key.fromLength(32)));

                                var ampm;
                                if (hour > 12) {
                                  hour = hour % 12;
                                  ampm = 'pm';
                                } else if (hour == 12) {
                                  ampm = 'pm';
                                } else if (hour == 0) {
                                  hour = 12;
                                  ampm = 'am';
                                } else {
                                  ampm = 'am';
                                }
                                return Column(
                                  children: [
                                    if (snapshot.data.docs[index]["type"] ==
                                        'message')
                                      SwipeTo(
                                        onRightSwipe: () {
                                          rightSwiped = true;
                                          swiped = true;
                                          if (userM['uid'] !=
                                              snapshot.data.docs[index]
                                                  ["sender"]) {
                                            replyToMessage(
                                                encrypter.decrypt64(
                                                    snapshot.data.docs[index]
                                                        ["text"],
                                                    iv: enc.IV.fromLength(16)),
                                                widget.model.userName,
                                                widget.model.name);
                                          }

                                          focusNode.requestFocus();
                                        },
                                        onLeftSwipe: () {
                                          leftSwiped = true;
                                          swiped = true;
                                          if (userM['uid'] ==
                                              snapshot.data.docs[index]
                                                  ["sender"]) {
                                            replyToMessage(
                                              encrypter.decrypt64(
                                                  snapshot.data.docs[index]
                                                      ["text"],
                                                  iv: enc.IV.fromLength(16)),
                                              '',
                                              userM['displayName'],
                                            );
                                          }

                                          focusNode.requestFocus();
                                        },
                                        child: MessageReply(
                                          isMe: userM['uid'] ==
                                              snapshot.data.docs[index]
                                                  ["sender"],
                                          // displayname: widget.model.name,
                                          text: encrypter.decrypt64(
                                            snapshot.data.docs[index]["text"],
                                            iv: enc.IV.fromLength(16),
                                          ),
                                          time: snapshot.data.docs[index]
                                              ["created"],
                                          onSwipedMessage: snapshot
                                              .data.docs[index]["swiped"],
                                          replyUsername: snapshot
                                              .data.docs[index]["replyUser"],
                                          replyName: snapshot.data.docs[index]
                                              ["replyName"],
                                          replyMessage: snapshot
                                              .data.docs[index]["replyMessage"],
                                        ),
                                      )
                                    else if (snapshot.data.docs[index]
                                            ["type"] ==
                                        'audio')
                                      Align(
                                        alignment: (snapshot.data.docs[index]
                                                    ['sender'] ==
                                                userM['uid'])
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: VoiceMessage(
                                          audioSrc: snapshot.data.docs[index]
                                              ['content'],
                                          me: snapshot.data.docs[index]
                                                  ['sender'] ==
                                              userM['uid'],
                                          meBgColor: secondaryColor,
                                          contactBgColor: Color(0xffc4c4c4),
                                          contactPlayIconColor: Colors.black,
                                          contactFgColor: Colors.white,
                                        ),
                                      )
                                    else
                                      Align(
                                        alignment: (snapshot.data.docs[index]
                                                    ['sender'] ==
                                                userM['uid'])
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 150,
                                          height: 150,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return FullScreenImage(
                                                  imageUrl: snapshot.data
                                                      .docs[index]["content"],
                                                  tag: "image",
                                                );
                                              }));
                                            },
                                            child: ClipRRect(
                                              child: Hero(
                                                tag: 'image$index',
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: snapshot.data
                                                      .docs[index]["content"],
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(
                                                    Icons.person,
                                                    color: secondaryColor,
                                                  ),
                                                  filterQuality:
                                                      FilterQuality.high,
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 7,
                                    )
                                  ],
                                );
                              },
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE6E9EE),
              borderRadius: BorderRadius.circular(12),
            ),
            //Color(0xffECE5DD),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (isReplying == true)
                        buildReply(replyMessage, uName, dName, isReplying),
                      context.watch<ChatNotifier>().isRecording
                          ? Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Lottie.asset(
                                          'assets/lottie/recording.json',
                                          height: 40,
                                          width: 27,
                                          fit: BoxFit.fitHeight),
                                    ),
                                    Expanded(
                                      child: Lottie.asset(
                                        'assets/lottie/Linear_determinate.json',
                                        height: double.infinity,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              height: 40,
                              // width: 20,
                            )
                          : TextField(
                              style: TextStyle(
                                color: Color(0xff697077),
                                fontSize: 15,
                              ),
                              focusNode: focusNode,
                              controller: messageController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(1, 2, 1, 2),
                                fillColor: Color(0xFFE6E9EE),
                                hintText: 'Type a message',
                                isDense: false,
                                hintStyle: TextStyle(
                                  color: Color(0xff697077),
                                  fontSize: 15,
                                ),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isTyping = !isTyping;
                                    });
                                  },
                                  child: IconButton(
                                      onPressed: () {
                                        context
                                            .read<ChatNotifier>()
                                            .cameraUploadImageChat(
                                                widget.model.uid);
                                      },
                                      constraints: BoxConstraints(
                                        maxWidth: 30,
                                      ),
                                      icon: SvgPicture.asset(
                                          'assets/camera.svg')),
                                ),
                                suffixIcon: FittedBox(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        constraints: const BoxConstraints(
                                          maxWidth: 30,
                                        ),
                                        icon: Icon(
                                          Iconsax.dollar_circle,
                                          size: 21,
                                          color: secondaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<ChatNotifier>()
                                              .pickUploadImageChat(
                                                  widget.model.uid);
                                        },
                                        constraints: const BoxConstraints(
                                          maxWidth: 30,
                                        ),
                                        icon: Icon(
                                          Iconsax.gallery,
                                          size: 20,
                                          color: secondaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              // expands: true,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                context.watch<ChatNotifier>().isRecording
                    ? SizedBox(
                        height: 5,
                        width: 40,
                      )
                    : SizedBox(),
                messageController.text.isEmpty
                    ? RecordButton(
                        controller: controller,
                        model: widget.model,
                      )
                    : IconButton(
                        onPressed: () async {
                          context
                              .read<ChatNotifier>()
                              .storeText(messageController.text.trim());
                          messageController.clear();

                          ChatMethods().storeMessages(
                            context: context,
                            text: context.read<ChatNotifier>().chatText,
                            userID: userM['uid'],
                            receiverID: widget.model.uid,
                            searchKeywords:
                                createKeywords(widget.model.userName),
                            img: widget.model.image,
                            displayName: widget.model.name,
                            userName: widget.model.userName,
                            key: enc.Key.fromLength(32),
                            iv: enc.IV.fromLength(16),
                            swiped: swiped,
                            replyMessage: replyMessage,
                            replyName: dName,
                            replyUsername: uName,
                          );
                          sendNotification(
                            tokenIdList: [player],
                            heading: userM['displayName'],
                            contents: context.read<ChatNotifier>().chatText,
                          );
                          // // var status = await OneSignal.shared.getDeviceState();
                          // //
                          // // var playerId = status.userId;
                          // await OneSignal.shared
                          //     .postNotification(OSCreateNotification(
                          //   playerIds: [player],
                          //   content: context.read<ChatNotifier>().chatText,
                          //   heading: 'Beepo',
                          //   subtitle: userM['displayName'],
                          //   sendAfter: DateTime.now(),
                          //   buttons: [
                          //     OSActionButton(text: "test1", id: "id1"),
                          //     OSActionButton(text: "test2", id: "id2"),
                          //   ],
                          //   androidSound:
                          //       'assets/mixkit-interface-hint-notification-911.wav',
                          //   androidSmallIcon: 'assets/beepo_img.png',
                          //
                          // )
                          // );
                          context.read<ChatNotifier>().clearText();

                          setState(() {
                            isReplying = false;
                            replyMessage = '';
                          });
                          // EncryptData.encryptFernet(context.read<ChatNotifier>().chatText);
                          // OneSignal.shared.
                        },
                        icon: const Icon(
                          Icons.send,
                          color: secondaryColor,
                          size: 35,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReply(String message, String username, String displayName,
          bool isReplying) =>
      Container(
        decoration: BoxDecoration(
          color: Color(0xff697077).withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.only(
          // left: 14,
          right: 10,
          top: 5,
          bottom: 5,
        ),
        margin: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Row(
            children: [
              VerticalDivider(
                thickness: 2,
                // width: 10,
                // indent: 12,
                color: secondaryColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffc82513),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '@${username}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffc82513),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.close,
                                size: 18,
                              ),
                              onTap: () {
                                cancelReply();
                                setState(() {
                                  isReplying = false;
                                });
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff120b0b),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const FullScreenImage({Key key, this.imageUrl, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(
                Icons.person,
                color: secondaryColor,
              ),
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
