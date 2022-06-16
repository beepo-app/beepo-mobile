import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../components.dart';
import '../user_profile_screen.dart';

class ChatDm extends StatefulWidget {
  const ChatDm({Key key}) : super(key: key);

  @override
  State<ChatDm> createState() => _ChatDmState();
}

class _ChatDmState extends State<ChatDm> {
  TextEditingController messageController = TextEditingController();
  bool isTyping = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Color(0xffECE5DD),
        body: Container(
          color: Color(0xffECE5DD),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 10),
                  height: 120,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xff0e014c),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
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
                            onPressed: () => Get.back(),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Get.to(UserProfile());
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19),
                              child: Image.asset(
                                'assets/profile_img.png',
                                height: 35,
                                width: 35,
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Get.to(UserProfile());
                            },
                            child: Text(
                              "Precious ",
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
                          Icon(
                            Icons.video_call,
                            color: Colors.white,
                            size: 25,
                          ),
                          SizedBox(width: 15),
                          Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 25,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        MessageSender(),
                        SizedBox(height: 18),
                        SizedBox(height: 18),
                        MessageReceiver(),
                        SizedBox(height: 18),
                        MessageSender(),
                        SizedBox(height: 18),
                        MessageReceiver(),
                        SizedBox(height: 18),
                        MessageReceiver(),
                      ],
                    ),
                  ),
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
                    hintStyle: TextStyle(color: Color(0xff697077), fontSize: 14),
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
                        icon: Icon(
                          Iconsax.microphone,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
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
                              Iconsax.emoji_happy,
                              size: 20,
                              color: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).primaryColor,
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
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.mic),
              )
            ],
          ),
        ),
      ),
    );
  }
}
