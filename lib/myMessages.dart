// ignore_for_file: prefer_const_constructors

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
  const MyMessages({@required this.uid});

  final String uid;

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

    img = profile['image'];
    displayName = profile['name'];
    userName = profile['userName'];
    setState(() {});
  }

  bool isTapped = true;

  @override
  void initState() {
    // TODO: implement initState
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .doc(userM['uid'])
              .collection("userMessages")
              .doc(widget.uid)
              .collection("messageList")
              .orderBy('created', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<DateTime> get;
              get.add(snapshot.data.docs[0]['created'].toDate());
              return ListTile(
                onTap: () {
                  Get.to(ChatDm(
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
                    Text(
                      // '${pro.last['created']} : ${}',
                      DateFormat('HH:mm')
                          .format(snapshot.data.docs[0]['created'].toDate()),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  snapshot.data.docs[0]['type'] == 'message'
                      ? '${snapshot.data.docs[0]['text']}'
                      : snapshot.data.docs[0]['sender'] == userM['uid']
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
            }
            return Center(
              child: SizedBox()
            );
          });
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
