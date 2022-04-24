import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';
import '../components.dart';
import 'profile_screen.dart';
import 'user_profile_screen.dart';
import 'user_profile_screen.dart';
import 'user_profile_screen.dart';
import 'user_profile_screen.dart';
import 'user_profile_screen.dart';

class ChatDm extends StatefulWidget {
  const ChatDm({Key key}) : super(key: key);

  @override
  State<ChatDm> createState() => _ChatDmState();
}

class _ChatDmState extends State<ChatDm> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffDEEDE6),
        // color: Colors.white,
        // width: double.infinity,
        // height: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 10),
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
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
                          Icons.search,
                          color: Color(0xff908f8d),
                          size: 25,
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.more_vert_outlined,
                          color: Color(0xff908f8d),
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
                color: Color(0xffDEEDE6),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      MessageSender1(),
                      SizedBox(height: 18),
                      MessageSender2(),
                      SizedBox(height: 18),
                      MessageReceiver(),
                      SizedBox(height: 18),
                      MessageSender3(),
                      SizedBox(height: 18),
                      MessageReceiver2(),
                      SizedBox(height: 18),
                      MessageSender1(),
                      SizedBox(height: 18),
                      MessageSender2(),
                      SizedBox(height: 18),
                      MessageReceiver(),
                      SizedBox(height: 18),
                      MessageSender3(),
                      SizedBox(height: 18),
                      MessageReceiver2(),
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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: Row(
          children: [
            SizedBox(
                // width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: bg,
                suffixIcon: Icon(
                  Icons.add_circle_outline_sharp,
                  color: blue,
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            )),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(
                Icons.send,
                color: blue,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),

      // bottomNavigationBar: Container(
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(6),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Color(0x0c000234),
      //         blurRadius: 12,
      //         offset: Offset(0, 4),
      //       ),
      //     ],
      //     color: Colors.white,
      //   ),
      //   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //   child: TextField(
      //     style: TextStyle(
      //       color: Color(0xff697077),
      //       fontSize: 14,
      //     ),
      //     controller: messageController,
      //     decoration: InputDecoration(
      //       fillColor: Colors.white,
      //       hintText: 'Type a message',
      //       isDense: false,
      //       hintStyle: TextStyle(color: Color(0xff697077), fontSize: 14),
      //       prefixIcon: GestureDetector(
      //         onTap: () {
      //           setState(() {
      //             media = !media;
      //           });
      //         },
      //         child: media
      //             ? SizedBox(
      //                 width: 100,
      //                 child: Row(
      //                   children: [
      //                     IconButton(
      //                       onPressed: () {},
      //                       constraints: BoxConstraints(
      //                         maxWidth: 30,
      //                       ),
      //                       icon: Icon(
      //                         Iconsax.microphone,
      //                         size: 20,
      //                         color: Theme.of(context).primaryColor,
      //                       ),
      //                     ),
      //                     IconButton(
      //                       onPressed: () {},
      //                       constraints: BoxConstraints(
      //                         maxWidth: 30,
      //                       ),
      //                       icon: Icon(
      //                         Iconsax.emoji_happy,
      //                         size: 20,
      //                         color: Theme.of(context).primaryColor,
      //                       ),
      //                     ),
      //                     IconButton(
      //                       onPressed: () {},
      //                       constraints: BoxConstraints(
      //                         maxWidth: 30,
      //                       ),
      //                       icon: Icon(
      //                         Iconsax.gallery,
      //                         size: 20,
      //                         color: Theme.of(context).primaryColor,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               )
      //             : Container(
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   color: Color(0xffc1c7cd),
      //                 ),
      //                 margin: EdgeInsets.only(left: 10, right: 5),
      //                 child: Icon(
      //                   Iconsax.add,
      //                   size: 20,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //       ),
      //       suffixIcon: Container(
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           color: Theme.of(context).primaryColor,
      //         ),
      //         margin: EdgeInsets.only(right: 10, left: 5),
      //         child: Icon(
      //           Iconsax.send_1,
      //           size: 20,
      //           color: Colors.white,
      //         ),
      //       ),
      //       enabledBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(6),
      //         borderSide: BorderSide.none,
      //       ),
      //       focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(6),
      //         borderSide: BorderSide.none,
      //       ),
      //     ),
    );
  }
}
