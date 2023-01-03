// ignore_for_file: prefer_const_constructors

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Service/auth.dart';
import '../../Widgets/toasts.dart';
import '../../chat_methods.dart';
import '../../components.dart';
import '../../generate_keywords.dart';
import '../../provider.dart';
import '../Profile/user_profile_screen.dart';
import 'chat.dart';

class ChatDm extends StatefulWidget {
  final UserModel model;

  const ChatDm({this.model});

  @override
  State<ChatDm> createState() => _ChatDmState();
}

class _ChatDmState extends State<ChatDm> {
  TextEditingController messageController = TextEditingController();
  bool isTyping = true;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.signInAnonymously();
    messageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: const Color(0xffECE5DD),
        body: Container(
          color: const Color(0xffECE5DD),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 10),
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
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen())),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Get.to(UserProfile(
                                model: UserModel(
                                    uid: widget.model.uid,
                                    name: widget.model.name,
                                    userName: widget.model.userName,
                                    image: widget.model.image,
                                    searchKeywords:
                                        widget.model.searchKeywords),
                              ));
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
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Get.to(UserProfile(
                                model: UserModel(
                                    uid: widget.model.uid,
                                    name: widget.model.name,
                                    userName: widget.model.userName,
                                    image: widget.model.image,
                                    searchKeywords:
                                        widget.model.searchKeywords),
                              ));
                            },
                            child: Text(
                              widget.model.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff08aa48),
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset('assets/video_call.svg'),
                          SizedBox(width: 15),
                          Icon(
                            Icons.call,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 15),
                          Icon(
                            Icons.more_vert_outlined,
                            color: Colors.white,
                            size: 25,
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
                  color: Color(0xffECE5DD),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('messages')
                          .doc(AuthService().uid)
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
                              var day = time.toDate().day.toString();
                              var month = time.toDate().month.toString();
                              var year = time.toDate().toString().substring(2);
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
                                  snapshot.data.docs[index]["type"] != 'audio'
                                      ? MessageSender(
                                          isMe: AuthService().uid ==
                                              snapshot.data.docs[index]
                                                  ["sender"],
                                          displayname: widget.model.name,
                                          text: snapshot.data.docs[index]
                                              ["text"],
                                          time: snapshot.data.docs[index]
                                              ["created"],
                                        )
                                      : Align(
                                          alignment: (snapshot.data.docs[index]
                                                      ['sender'] ==
                                                  AuthService().uid)
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
                                                      AuthService().uid)
                                                  ? Color(0xffc4c4c4)
                                                  : Color(0xff0E014C),
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    (snapshot.data.docs[index]
                                                                ['sender'] ==
                                                            AuthService().uid)
                                                        ? Radius.circular(12)
                                                        : Radius.circular(0),
                                                topRight:
                                                    (snapshot.data.docs[index]
                                                                ['sender'] ==
                                                            AuthService().uid)
                                                        ? Radius.circular(0)
                                                        : Radius.circular(12),
                                                bottomLeft: Radius.circular(12),
                                                bottomRight:
                                                    Radius.circular(12),
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
                                                    context
                                                            .watch<
                                                                ChatNotifier>()
                                                            .isPlayingMsg
                                                        ? GestureDetector(
                                                            child: Icon(
                                                              Icons.cancel,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onTap: () {
                                                              // context.read<ChatNotifier>().isPlayingMsg = false;
                                                              context
                                                                  .read<
                                                                      ChatNotifier>()
                                                                  .stopRecord(
                                                                      widget
                                                                          .model
                                                                          .uid);
                                                            },
                                                          )
                                                        : GestureDetector(
                                                            child: Icon(
                                                              Icons.play_arrow,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onTap: () async {
                                                              context
                                                                  .read<
                                                                      ChatNotifier>()
                                                                  .isPlayingMsg = true;
                                                              await context
                                                                  .read<
                                                                      ChatNotifier>()
                                                                  .loadFile(snapshot
                                                                          .data
                                                                          .docs[index]
                                                                      [
                                                                      'content']);
                                                              // Future.delayed(duration)
                                                              context
                                                                  .read<
                                                                      ChatNotifier>()
                                                                  .isPlayingMsg = false;
                                                              // notifyListeners();
                                                            },
                                                          ),

                                                    Center(
                                                      child: Lottie.asset(
                                                        'assets/lottie/waves.json',
                                                        height: 30,
                                                        width: 100,
                                                        animate: context
                                                                .watch<
                                                                    ChatNotifier>()
                                                                .isPlayingMsg
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
                                                      '${snapshot.data.docs[index]['duration']} seconds',
                                                      style: (snapshot.data.docs[index]
                                                      ['sender'] ==
                                                          AuthService().uid)? TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ): TextStyle(
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
                                        ),
                                  SizedBox(
                                    height: 5,
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
          width: double.infinity,
          color: Color(0xffECE5DD),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: Color(0xff697077),
                    fontSize: 14,
                  ),
                  controller: messageController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Message',
                    isDense: false,
                    hintStyle:
                        TextStyle(color: Color(0xff697077), fontSize: 14),
                    prefixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isTyping = !isTyping;
                        });
                      },
                      child: IconButton(
                          onPressed: () {},
                          constraints: BoxConstraints(
                            maxWidth: 30,
                          ),
                          icon: SvgPicture.asset('assets/camera.svg')),
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
                              size: 20,
                              color: secondaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            constraints: const BoxConstraints(
                              maxWidth: 30,
                            ),
                            icon: Icon(
                              Iconsax.gallery,
                              size: 20,
                              color: secondaryColor,
                            ),
                          ),
                          SizedBox(width: 10),
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
              ),
              SizedBox(
                width: 10,
              ),
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
                        context
                            .read<ChatNotifier>()
                            .stopRecord(widget.model.uid);
                        setState(() {
                          context.read<ChatNotifier>().isRecording = false;
                          showToast('Sent!');
                        });
                        context.read<ChatNotifier>().durationCalc();
                      },
                      child: context.watch<ChatNotifier>().isRecording
                          ? Lottie.asset(
                              'assets/lottie/mic.json',
                              height: 47,
                              width: 27,
                            )
                          : SvgPicture.asset(
                              'assets/microphone.svg',
                              width: 27,
                              height: 27,
                            ),
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
                          userID: AuthService().uid,
                          receiverID: widget.model.uid,
                          searchKeywords: createKeywords(widget.model.userName),
                          img: widget.model.image,
                          displayName: widget.model.name,
                          userName: widget.model.userName,
                        );
                        context.read<ChatNotifier>().clearText();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: secondaryColor,
                        size: 30,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
