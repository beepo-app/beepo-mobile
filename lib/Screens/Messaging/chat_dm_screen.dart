// ignore_for_file: prefer_const_constructors

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Widgets/toasts.dart';
import '../../bottom_nav.dart';
import '../../chat_methods.dart';
import '../../components.dart';
import '../../generate_keywords.dart';
import '../../provider.dart';
import '../Profile/user_profile_screen.dart';

class ChatDm extends StatefulWidget {
  final UserModel model;

  const ChatDm({this.model});

  @override
  State<ChatDm> createState() => _ChatDmState();
}

class _ChatDmState extends State<ChatDm> {
  TextEditingController messageController = TextEditingController();
  bool isTyping = true;

  Map userM = Hive.box('beepo').get('userData');
  int isPlaying;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.signInAnonymously();
    isPlaying = -1;
    messageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onPanUpdateDownDirection],
      child: Scaffold(
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
                                      builder: (context) => BottomNavHome())),
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
                                    if (snapshot.data.docs[index]["type"] ==
                                        'message')
                                      MessageSender(
                                        isMe: userM['uid'] ==
                                            snapshot.data.docs[index]["sender"],
                                        displayname: widget.model.name,
                                        text: snapshot.data.docs[index]["text"],
                                        time: snapshot.data.docs[index]
                                            ["created"],
                                      )
                                    else if (snapshot.data.docs[index]["type"] ==
                                        'audio')
                                      Align(
                                        alignment: (snapshot.data.docs[index]
                                                    ['sender'] ==
                                                userM['uid'])
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width *
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
                                              topLeft: (snapshot.data.docs[index]
                                                          ['sender'] ==
                                                      userM['uid'])
                                                  ? Radius.circular(12)
                                                  : Radius.circular(0),
                                              topRight: (snapshot.data.docs[index]
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
                                                                        index]
                                                                    ['content']);
                                                            //  Future.delayed(context.read<ChatNotifier>().dure, (){
                                                            //   setState(() {
                                                            //     isPlaying = -1;
                                                            //
                                                            //   });
                                                            // });
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
                                                  MaterialPageRoute(builder: (_) {
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
                  child:  context.watch<ChatNotifier>().isRecording
                      ? Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Lottie.asset(
                              'assets/lottie/recording.json',
                              height: 40,
                              width: 27,
                              fit: BoxFit.fitHeight
                            ),
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
                      :TextField(
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
                            onPressed: () {
                              context
                                  .read<ChatNotifier>()
                                  .cameraUploadImageChat(widget.model.uid);
                            },
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
                                    onPressed: () {
                                      context
                                          .read<ChatNotifier>()
                                          .pickUploadImageChat(widget.model.uid);
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
                          ChatMethods().storeMessages(
                            context: context,
                            text: context.read<ChatNotifier>().chatText,
                            userID: userM['uid'],
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
