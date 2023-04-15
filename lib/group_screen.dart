// ignore_for_file: prefer_const_constructors
import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Screens/Messaging/services/chat_methods.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Widgets/toasts.dart';
import '../../bottom_nav.dart';
import '../../components.dart';
import '../../provider.dart';

import 'generate_keywords.dart';

class GroupDm extends StatefulWidget {
  final bool isMe;
  const GroupDm({Key key, @required this.isMe}) : super(key: key);

  @override
  State<GroupDm> createState() => _GroupDmState();
}

class _GroupDmState extends State<GroupDm> {
  TextEditingController messageController = TextEditingController();
  bool isTyping = true;

  Map userM = Hive.box('beepo').get('userData');
  int isPlaying;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signInAnonymously();
    isPlaying = -1;
    messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                SizedBox(
                                  height: 37,
                                  width: 37,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/group.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: const [
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
                                    Text(
                                      '12,580 members',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),

                                Spacer(),
                                Icon(
                                  Icons.more_vert_outlined,
                                  color: Colors.white,
                                  size: 23,
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
                                var year =
                                    time.toDate().toString().substring(2);
                                var date = day + '-' + month + '-' + year;
                                var hour = time.toDate().hour;
                                var min = time.toDate().minute;

                                String ampm;
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
                                      Group(
                                        isMe: userM['uid'] ==
                                            snapshot.data.docs[index]["sender"],
                                        text: snapshot.data.docs[index]["text"],
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
                                      height: 15,
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
            color: Colors.white,
            //Color(0xffECE5DD),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: context.watch<ChatNotifier>().isRecording
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
                                  icon: SvgPicture.asset('assets/camera.svg')),
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
                          ChatMethods().storeGroupMessages(
                            context: context,
                            text: context.read<ChatNotifier>().chatText,
                            sender: userM['uid'],
                            searchKeywords: createKeywords(userM['username']),
                            image: userM['profilePictureUrl'],
                            displayName: userM['displayName'],
                            userName: userM['username'],
                          );
                          context.read<ChatNotifier>().clearText();
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
