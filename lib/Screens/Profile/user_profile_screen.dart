// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../Models/user_model.dart';
import '../../Utils/styles.dart';
import '../store_screen.dart';

class UserProfile extends StatefulWidget {
  // const UserProfile({Key key}) : super(key: key);
  final UserModel model;

  UserProfile({@required this.model});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool enable = false;
  bool enable2 = true;
  bool enable3 = false;

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      width: 110,
                      height: 110,
                      imageUrl: widget.model.image,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.person, color: secondaryColor,),
filterQuality: FilterQuality.high,
                      // fit: BoxFit.cover,
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
                          Icon(
                            Icons.forward,
                            size: 35,
                            color: Color(0xffFF9C34),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Share",
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
                                    enable2 = val;
                                  });
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
                          SizedBox(height: 20),
                          // Text(
                          //   "Store",
                          //   style: TextStyle(
                          //     color: Color(0xff0e014c),
                          //     fontSize: 14,
                          //   ),
                          // ),
                          SizedBox(height: 22),
                          // GridView.count(
                          //   physics: NeverScrollableScrollPhysics(),
                          //   padding: const EdgeInsets.only(bottom: 20),
                          //   mainAxisSpacing: 20,
                          //   shrinkWrap: true,
                          //   crossAxisSpacing: 15,
                          //   crossAxisCount: 3,
                          //   children: List.generate(9, (index) {
                          //     return GestureDetector(
                          //       onTap: () => Get.to(Store()),
                          //       child: Container(
                          //         padding: const EdgeInsets.all(10),
                          //         height: 91,
                          //         width: 102,
                          //         decoration: BoxDecoration(
                          //           color: Colors.grey,
                          //           borderRadius: BorderRadius.circular(15),
                          //         ),
                          //       ),
                          //     );
                          //   }),
                          // ),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
