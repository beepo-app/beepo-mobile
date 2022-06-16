import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'browser.dart';
import 'Messaging/chat.dart';
import 'profile_screen.dart';
import 'wallet_screen.dart';

class BottomNav extends StatefulWidget {
  BottomNav({Key key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;
  List body = [
    ChatScreen(),
    Wallet(),
    Browser(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xffFF9C34),
        onTap: (int selectedPage) {
          setState(() => index = selectedPage);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.message),
            label: 'Chats',
          ),
          BottomNavigationBarItem(icon: Icon(Iconsax.wallet), label: 'Wallet'),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.global),
            label: 'Browser',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.security_user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
