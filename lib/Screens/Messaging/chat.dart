// ignore_for_file: unnecessary_const

import 'package:beepo/Service/encryption.dart';
import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:iconsax/iconsax.dart';

import '../../Utils/styles.dart';
import '../../components.dart';
import 'chats/search.dart';

class ChatScreen extends StatefulWidget {
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
              ontap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchUsersScreen(),
                  )),
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
          body: FutureBuilder(
              future: EncryptionService().decryptSeedPhrase(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                print(snapshot.data);
                return Container(
                  width: double.infinity,
                  color: txtColor1,
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
                      const SizedBox(height: 10),
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
                );
              }),
        ),
      ),
    );
  }
}
