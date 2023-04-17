// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:beepo/mic_anime.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../Widgets/toasts.dart';
import '../../../../bottom_nav.dart';
import '../../../../components.dart';
import '../../../../provider.dart';
import '../../generate_keywords.dart';
import 'services/chat_methods.dart';

class GroupDm extends StatefulWidget {
  const GroupDm({Key key}) : super(key: key);

  @override
  State<GroupDm> createState() => _GroupDmState();
}

class _GroupDmState extends State<GroupDm> {
  TextEditingController messageController = TextEditingController();
  bool isTyping = true;

  Map userM = Hive.box('beepo').get('userData');
  int isPlaying;

  String replyMessage = '';
  String uName = '';
  String dName = '';
  bool swiped = false;
  List<String> players = [];

  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("OneSignal").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      players.add(a.toString());
    }
  }

  // var isReplying = replyMessage != '';
  bool rightSwiped = false;
  bool leftSwiped = false;

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

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signInAnonymously();
    isPlaying = -1;
    messageController.addListener(() {
      setState(() {});
    });
    getDocs();
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
                              '@$username',
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

  var selectedValue = "";

  @override
  Widget build(BuildContext context) {
    var isReplying = replyMessage != '';

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
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 5, right: 13),
                        height: 120,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Color(0xff0e014c),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
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
                                          builder: (context) =>
                                              BottomNavHome())),
                                ),
                                SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {},
                                  child: SizedBox(
                                    height: 37,
                                    width: 37,
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/group.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupProfile(
                                                  image: 'assets/group.jpg',
                                                )));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Beepo Public Chat',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                '${snapshot.data.docs.length} members',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w100,
                                                ),
                                              );
                                            }
                                            return SizedBox();
                                          }),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                // Icon(
                                //   Icons.more_vert_outlined,
                                //   color: Colors.white,
                                //   size: 23,
                                // ),
                                // SizedBox(width: 8),
                                PopupMenuButton(
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.white),
                                  color: Colors.white,
                                  onSelected: (value) {
                                    setState(() {
                                      selectedValue = value.toString();
                                    });
                                    print(value);
                                    Navigator.pushNamed(
                                        context, value.toString());
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        child: Text("Group info"),
                                        value: '/group info',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupProfile(
                                                image: 'assets/group.jpg',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: Text("Leave group"),
                                        value: '/leave group',
                                        onTap: () {},
                                      ),
                                      PopupMenuItem(
                                        child: Text("Mute"),
                                        value: '/notificaton',
                                        onTap: () {},
                                      )
                                    ];
                                  },
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.white,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('groupMessages')
                            .orderBy("created", descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              reverse: true,
                              controller:
                                  context.read<ChatNotifier>().scrollController,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                Timestamp time =
                                    snapshot.data.docs[index]['created'];
                                var day = time.toDate().day.toString();
                                var month = time.toDate().month.toString();
                                var year =
                                    time.toDate().toString().substring(2);
                                var date = day + '-' + month + '-' + year;
                                var hour = time.toDate().hour;
                                var min = time.toDate().minute;

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
                                              snapshot.data.docs[index]["text"],
                                              snapshot.data.docs[index]
                                                  ["userName"],
                                              snapshot.data.docs[index]["displayName"],
                                            );
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
                                              snapshot.data.docs[index]["text"],
                                              '',
                                              userM['displayName'],
                                            );
                                          }

                                          focusNode.requestFocus();
                                        },
                                        child: Group(
                                          isMe: userM['uid'] ==
                                              snapshot.data.docs[index]
                                                  ["sender"],
                                          text: snapshot.data.docs[index]
                                              ["text"],
                                          time: snapshot.data.docs[index]
                                              ["created"],
                                          user: UserModel(
                                            uid: snapshot.data.docs[index]
                                                ["sender"],
                                            name: snapshot.data.docs[index]
                                                ["displayName"],
                                            image: snapshot.data.docs[index]
                                                ["image"],
                                            userName: snapshot.data.docs[index]
                                                ["userName"],
                                          ),
                                          sameUser: snapshot.data.docs[index]
                                                      ["sender"] !=
                                                  snapshot
                                                      .data.docs.last["sender"]
                                              ? (snapshot.data.docs[index + 1]
                                                      ["sender"] ==
                                                  snapshot.data.docs[index]
                                                      ["sender"])
                                              : false,
                                          onSwipedMessage: snapshot
                                              .data.docs[index]["swiped"],
                                          replyMessage: snapshot
                                              .data.docs[index]["replyMessage"],
                                          replyName: snapshot.data.docs[index]
                                              ["replyName"],
                                          replyUsername: snapshot
                                              .data.docs[index]["replyUser"],
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
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: (snapshot.data.docs[index]
                                                        ['sender'] !=
                                                    userM['uid'])
                                                ? Color(0xffc4c4c4)
                                                : Color(0xff0E014C),
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  (snapshot.data.docs[index]
                                                              ['sender'] ==
                                                          userM['uid'])
                                                      ? Radius.circular(12)
                                                      : Radius.circular(0),
                                              topRight:
                                                  (snapshot.data.docs[index]
                                                              ['sender'] ==
                                                          userM['uid'])
                                                      ? Radius.circular(0)
                                                      : Radius.circular(12),
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  isPlaying != -1
                                                      ? GestureDetector(
                                                          child: Icon(
                                                            Icons.cancel,
                                                            color: Colors.white,
                                                          ),
                                                          onTap: () {
                                                            // context.read<ChatNotifier>().isPlayingMsg = false;
                                                            context
                                                                .read<
                                                                    ChatNotifier>()
                                                                .pauseAudio();
                                                            setState(() {
                                                              isPlaying = -1;
                                                            });
                                                          },
                                                        )
                                                      : GestureDetector(
                                                          child: Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.white,
                                                          ),
                                                          onTap: () async {
                                                            setState(() {
                                                              isPlaying = index;
                                                            });
                                                            await context
                                                                .read<
                                                                    ChatNotifier>()
                                                                .loadFile(snapshot
                                                                            .data
                                                                            .docs[
                                                                        index][
                                                                    'content']);
                                                          },
                                                        ),
                                                  Center(
                                                    child: Lottie.asset(
                                                      'assets/lottie/waves.json',
                                                      height: 30,
                                                      width: 100,
                                                      animate: isPlaying != -1
                                                          ? true
                                                          : false,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${snapshot.data.docs[index]['duration']}',
                                                    style: (snapshot.data
                                                                    .docs[index]
                                                                ['sender'] ==
                                                            userM['uid'])
                                                        ? TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          )
                                                        : TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                          ),
                                                  ),
                                                  Text(
                                                    // date +
                                                    //     " " +
                                                    hour.toString() +
                                                        ":" +
                                                        min.toString() +
                                                        ampm,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
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
                                      height: 3,
                                    ),
                                    // for(var i=index; i< (snapshot.data.docs.length-1); i++)
                                    if (index != 0)
                                      if (snapshot.data.docs[index - 1]
                                              ["sender"] !=
                                          snapshot.data.docs[index]["sender"])
                                        SizedBox(
                                          height: 14,
                                        ),
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
            width: double.infinity,
            color: Colors.white,
            //Color(0xffECE5DD),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              minLines: 1,
                              style: TextStyle(
                                color: Color(0xff697077),
                                fontSize: 15,
                              ),
                              controller: messageController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                fillColor: Color(0xFFE6E9EE),
                                hintText: 'Message',
                                isDense: false,
                                hintStyle: TextStyle(
                                    color: Color(0xff697077), fontSize: 15),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isTyping = !isTyping;
                                    });
                                  },
                                  child: IconButton(
                                      onPressed: () {
                                        // context
                                        //     .read<ChatNotifier>()
                                        //     .cameraUploadImageChat(widget.model.uid);
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
                                      // IconButton(
                                      //   onPressed: () {},
                                      //   constraints: const BoxConstraints(
                                      //     maxWidth: 30,
                                      //   ),
                                      //   icon: Icon(
                                      //     Iconsax.dollar_circle,
                                      //     size: 21,
                                      //     color: secondaryColor,
                                      //   ),
                                      // ),
                                      IconButton(
                                        onPressed: () {
                                          // context
                                          //     .read<ChatNotifier>()
                                          //     .pickUploadImageChat(widget.model.uid);
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
                                      SizedBox(width: 15),
                                    ],
                                  ),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                context.watch<ChatNotifier>().isRecording
                    ? SizedBox(
                        // child:
                        height: 5,
                        width: 40,
                      )
                    : SizedBox(),
                messageController.text.isEmpty
                    ? GestureDetector(
                        onLongPress: () {
                          context.read<ChatNotifier>().startRecord();
                          setState(() {
                            context.read<ChatNotifier>().isRecording = true;
                            showToast('Recording!');
                          });
                        },
                        onLongPressEnd: (hey) {
                          // context
                          //     .read<ChatNotifier>()
                          //     .stopRecord(widget.model.uid);
                          setState(() {
                            context.read<ChatNotifier>().isRecording = false;
                            showToast('Sent!');
                          });
                          context.read<ChatNotifier>().durationCalc();
                        },
                        child: context.watch<ChatNotifier>().isRecording
                            ? SizedBox()
                            : SvgPicture.asset(
                                'assets/microphone.svg',
                                width: 27,
                                height: 27,
                              ))
                    : IconButton(
                        onPressed: () async {
                          context
                              .read<ChatNotifier>()
                              .storeText(messageController.text.trim());
                          messageController.clear();

                          sendNotification(
                            tokenIdList: players,
                            heading: userM['displayName'],
                            contents: context.read<ChatNotifier>().chatText,
                          );

                          ChatMethods().storeGroupMessages(
                            context: context,
                            text: context.read<ChatNotifier>().chatText,
                            sender: userM['uid'],
                            searchKeywords: createKeywords(userM['username']),
                            image: userM['profilePictureUrl'],
                            displayName: userM['displayName'],
                            userName: userM['username'],
                            replyMessage: replyMessage,
                            replyName: dName,
                            replyUsername: uName,
                            swiped: swiped,
                          );
                          context.read<ChatNotifier>().clearText();

                          setState(() {
                            isReplying = false;
                            replyMessage = '';
                          });
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
