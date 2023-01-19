// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'Models/user_model.dart';
import 'Screens/Messaging/chat_dm_screen.dart';
import 'generate_keywords.dart';

class MyMessages extends StatefulWidget {
  const MyMessages({@required this.uid, this.index, this.docu});

  final String uid;
  final int index;
  final List docu;

  @override
  State<MyMessages> createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {
  String img = '';
  String displayName = '';
  String userName = '';

  Map userM = Hive.box('beepo').get('userData');

  void getProfileData() async {
    var profile = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();


    setState(() {
      img = profile['image'];
      displayName = profile['name'];
      userName = profile['userName'];
    });
  }

  get(String receiverID) async {
    final tet = await FirebaseFirestore.instance
        .collection('messages')
        .doc(userM['uid'])
        .collection('userMessages')
        .doc(receiverID)
        .collection('messageList')
        .where('sender', isEqualTo: userM['uid'])
        .get();
    return tet.docs.isEmpty;
  }

  bool isTapped = true;

  @override
  void initState() {
    // TODO: implement initState
    getProfileData();
    // setState(() {
    //
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return ListTile(
        onTap: () async {
          final newChat = await get(widget.uid);
          newChat == true
              ? {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Accept Message Request'),
                          content: Text(
                              'This message is not from one of your friends. '
                              'Accept request or decline.'),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(ChatDm(
                                          model: UserModel(
                                            uid: widget.uid,
                                            image: img,
                                            name: displayName,
                                            userName: userName,
                                            searchKeywords:
                                                createKeywords(userName),
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Accept',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        FirebaseFirestore.instance
                                            .collection('conversation')
                                            .doc(userM['uid'])
                                            .collection("currentConversation")
                                            .doc(widget.uid)
                                            .delete();
                                        FirebaseFirestore.instance
                                            .collection('conversation')
                                            .doc(widget.uid)
                                            .collection("currentConversation")
                                            .doc(userM['uid'])
                                            .delete();
                                        var collect = await FirebaseFirestore
                                            .instance
                                            .collection('messages')
                                            .doc(userM['uid'])
                                            .collection('userMessages')
                                            .doc(widget.uid)
                                            .collection('messageList')
                                            .get();
                                        for (var doc in collect.docs) {
                                          await doc.reference.delete();
                                        }
                                        // .doc(widget.uid).delete();
                                        var collect2 = await FirebaseFirestore
                                            .instance
                                            .collection('messages')
                                            .doc(widget.uid)
                                            .collection('userMessages')
                                            .doc(userM['uid'])
                                            .collection('messageList')
                                            .get();
                                        for (var docr in collect2.docs) {
                                          await docr.reference.delete();
                                        }
                                        // .doc(userM['uid']).delete();
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        child: Text(
                                          'Decline',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      })
                }
              : Get.to(ChatDm(
                  model: UserModel(
                    uid: widget.uid,
                    image: img,
                    name: displayName,
                    userName: userName,
                    searchKeywords: createKeywords(userName),
                  ),
                ));
          // setState(() {
          isTapped = true;
          // });
          // }
        },
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl: img,
                height: 50,
                width: 50,
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                  color: secondaryColor,
                )),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  color: secondaryColor,
                ),
                filterQuality: FilterQuality.high,
              )),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  DateFormat('HH:mm')
                      .format(widget.docu[widget.index]['created'].toDate()),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('d:M:y')
                      .format(widget.docu[widget.index]['created'].toDate()),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ],
        ),
        subtitle: Text(
          widget.docu[widget.index]['type'] == 'message'
              ? '${widget.docu[widget.index]['text']}'
              : widget.docu[widget.index]['sender'] == userM['uid']
                  ? 'Media sent '
                  : 'Media recieved',
          style: isTapped == false
              ? TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )
              : TextStyle(
                  color: Color(0x82000000),
                  fontSize: 11,
                ),
        ),
      );
    } catch (e) {
      print(e);
    }
    return Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }
}
