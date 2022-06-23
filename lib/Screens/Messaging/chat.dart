// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:iconsax/iconsax.dart';

import '../../Utils/styles.dart';
import '../../components.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

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
          fabColor: blue,
          items: [
            HawkFabMenuItem(
              label: 'New Chat',
              ontap: () {},
              icon: const Icon(Icons.add),
              color: blue,
              labelColor: Colors.white,
              labelBackgroundColor: blue,
            ),
            HawkFabMenuItem(
              label: 'Join Public Chat',
              ontap: () {},
              icon: const Icon(Iconsax.people),
              color: blue,
              labelColor: Colors.white,
              labelBackgroundColor: blue,
            ),
            HawkFabMenuItem(
              label: 'Share',
              ontap: () {},
              icon: const Icon(Icons.share),
              color: blue,
              labelColor: Colors.white,
              labelBackgroundColor: blue,
            ),
          ],
          body: Container(
            width: double.infinity,
            color: blue,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const TabBar(
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
                    const Tab(
                      child: const Text(
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
                const SizedBox(height: 25),
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
