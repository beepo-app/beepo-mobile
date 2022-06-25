import 'package:beepo/Utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../Utils/styles.dart';
import '../store_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key}) : super(key: key);

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
          onPressed: () {
            Get.back();
          },
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
                      bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  color: Color(0xff0e014c)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 56),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset('assets/profile.png',
                        height: 111, width: 113, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Precious",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Professional Account",
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
                          Icon(
                            Iconsax.message_2,
                            size: 35,
                            color: Color(0xffFF9C34),
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
                          SizedBox(height: 53),
                          Text(
                            "Hi there, am a blockchain developer\ni would be glad you patronize my services as listed on the store",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 37),
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
                                activeColor: blue,
                                onChanged: (value) {
                                  setState(() {
                                    enable = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 37),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Disappearing messages",
                                  style: TextStyle(
                                    color: Color(0xff0e014c),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Switch(
                                value: enable2,
                                activeColor: blue,
                                onChanged: (val) {
                                  setState(() {
                                    enable2 = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 35),
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
                                activeColor: blue,
                                onChanged: (value) {
                                  setState(() {
                                    enable3 = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 28),
                          Divider(),
                          SizedBox(height: 35),
                          Text(
                            "Store",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 22),
                          GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            mainAxisSpacing: 20,
                            shrinkWrap: true,
                            crossAxisSpacing: 15,
                            crossAxisCount: 3,
                            children: List.generate(9, (index) {
                              return GestureDetector(
                                onTap: () => Get.to(Store()),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 91,
                                  width: 102,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
