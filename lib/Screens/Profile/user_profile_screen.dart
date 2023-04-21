// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';

import '../Messaging/media_links_docs.dart';
bool enableMedia=false;
class UserProfile extends StatefulWidget {
  // const UserProfile({Key key}) : super(key: key);
  final UserModel model;

  UserProfile({@required this.model});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool enable = false;
  bool enable2 = false;
  bool enable3 = false;

  bool isSecuredMode = false;

  Map userM = Hive.box('beepo').get('userData');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 352,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Color(0xff0e014c)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 56),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return FullScreenImage(
                          imageUrl: widget.model.image,
                          tag: "imagex",
                        );
                      }));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Hero(
                        tag: 'imagex',
                        child: CachedNetworkImage(
                          width: 110,
                          height: 110,
                          imageUrl: widget.model.image,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            color: secondaryColor,
                          ),
                          filterQuality: FilterQuality.high,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.model.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    widget.model.userName,
                    style: TextStyle(
                      color: Color(0x66ffffff),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Iconsax.message_2,
                              size: 35,
                              color: Color(0xffFF9C34),
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDm(
                                    model: UserModel(
                                        uid: widget.model.uid,
                                        name: widget.model.name,
                                        userName: widget.model.userName,
                                        image: widget.model.image,
                                        searchKeywords:
                                            widget.model.searchKeywords),
                                  ),
                                )),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Message",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.call,
                            size: 35,
                            color: Color(0xffFF9C34),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Call",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SvgPicture.asset('assets/block.svg'),
                          SizedBox(height: 12),
                          Text(
                            "Block",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Hi there, am new to Beepo and I love it",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff0e014c),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Mute notifications",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: enable,
                            activeColor: secondaryColor,
                            onChanged: (value) {
                              setState(() {
                                enable = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Allow Screenshot",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: enable2,
                            activeColor: secondaryColor,
                            onChanged: (val) {
                              setState(() {
                                enable2 = !enable2;
                                isSecuredMode = !isSecuredMode;
                              });
                              if (isSecuredMode) {
                                FlutterWindowManager.addFlags(
                                    FlutterWindowManager.FLAG_SECURE);
                              } else {
                                FlutterWindowManager.clearFlags(
                                    FlutterWindowManager.FLAG_SECURE);
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Allow media",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                            value: enable3,
                            activeColor: secondaryColor,
                            onChanged: (value) {
                              setState(() {
                                enable3 = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shared Media, Links and Docs',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: txtColor1,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MediaLinks(
                                            model: widget.model,
                                          )));
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: secondaryColor,
                              size: 15,
                            ),
                          )
                        ],
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('messages')
                              .doc(userM['uid'])
                              .collection('userMessages')
                              .doc(widget.model.uid)
                              .collection('messageList')
                              .where('type', isEqualTo: 'photo')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 20),
                                mainAxisSpacing: 20,
                                shrinkWrap: true,
                                crossAxisSpacing: 15,
                                crossAxisCount: 3,
                                children: List.generate(
                                    snapshot.data.docs.length, (index) {
                                  return GestureDetector(
                                    // onTap: () => Get.to(Store()),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 91,
                                      width: 102,
                                      decoration: BoxDecoration(
                                        // color: Colors.grey,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data.docs[index]
                                              ['content'],
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }
                            return CircularProgressIndicator(
                              color: primaryColor,
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
