// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:iconsax/iconsax.dart';

import '../../Utils/styles.dart';
import '../../Widgets/components.dart';
import 'chats/check_address.dart';
import 'chats/search.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  // ChatScreen({Key key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: HawkFabMenu(
          icon: AnimatedIcons.menu_close,
          fabColor: txtColor1,
          items: [
            HawkFabMenuItem(
              label: 'New Chat',
              ontap: () {
                Get.dialog(Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButtons(
                          text: 'Search username on Beepo',
                          onPressed: () => Get.off(SearchUsersScreen()),
                        ),
                        const SizedBox(height: 30),
                        FilledButtons(
                          text: 'Chat with an ETH address',
                          onPressed: () => Get.off(const CheckAddress())
                              .then((value) => setState(() {})),
                        ),
                      ],
                    ),
                  ),
                ));
                // return Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => SearchUsersScreen(),
                //     ));
              },
              icon: const Icon(Icons.add),
              color: txtColor1,
              labelColor: Colors.white,
              labelBackgroundColor: txtColor1,
            ),
            HawkFabMenuItem(
              label: 'Join Public Chat',
              ontap: () {},
              icon: const Icon(Iconsax.people),
              color: txtColor1,
              labelColor: Colors.white,
              labelBackgroundColor: txtColor1,
            ),
            HawkFabMenuItem(
              label: 'Share',
              ontap: () {},
              icon: const Icon(Icons.share),
              color: txtColor1,
              labelColor: Colors.white,
              labelBackgroundColor: txtColor1,
            ),
          ],
          body: Container(
            width: double.infinity,
            color: txtColor1,
            child: Column(
              children: const [
                SizedBox(height: 50),
                TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text(
                        "Chats",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Calls",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      ChatTab(),
                      CallTab(),
                    ],
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
