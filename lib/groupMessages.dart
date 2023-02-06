// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:beepo/Utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'group_screen.dart';

class GroupMessages extends StatefulWidget {
  const GroupMessages({Key key, @required this.uid, this.index, this.docu})
      : super(key: key);

  final String uid;
  final int index;
  final List docu;

  @override
  State<GroupMessages> createState() => _GroupMessagesState();
}

class _GroupMessagesState extends State<GroupMessages> {
  Map userM = Hive.box('beepo').get('userData');

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return ListTile(
        onTap: () async {
          Get.to(GroupDm());
          isTapped = true;
        },
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              "assets/group.jpg",
              // width: 25,
              // height: 25,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Beepo",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            if (DateTime.now()
                    .difference(widget.docu[widget.index]['created'].toDate())
                    .inHours <
                24)
              Text(
                DateFormat('HH:mm')
                    .format(widget.docu[widget.index]['created'].toDate()),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (DateTime.now()
                    .difference(widget.docu[widget.index]['created'].toDate())
                    .inHours >
                48)
              Text(
                DateFormat('d:M:y')
                    .format(widget.docu[widget.index]['created'].toDate()),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                ),
              ),
            if (DateTime.now()
                        .difference(
                            widget.docu[widget.index]['created'].toDate())
                        .inHours >
                    24 &&
                DateTime.now()
                        .difference(
                            widget.docu[widget.index]['created'].toDate())
                        .inHours <
                    48)
              Text(
                'Yesterday',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        subtitle: Text(
          widget.docu[widget.index]['type'] == 'message'
              ? widget.docu[widget.index]['sender'] == userM['uid']
                  ? 'you: ${widget.docu[widget.index]['text']}'
                  : '${widget.docu[widget.index]['displayName']}:${widget.docu[widget.index]['text']}'
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
