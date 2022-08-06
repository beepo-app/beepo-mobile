import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'Screens/browser.dart';
import 'Screens/Messaging/chat.dart';
import 'Screens/profile_screen.dart';
import 'Screens/wallet_screen.dart';

class BottomNavHome extends StatefulWidget {
  BottomNavHome({Key key}) : super(key: key);

  @override
  State<BottomNavHome> createState() => _BottomNavHomeState();
}

class _BottomNavHomeState extends State<BottomNavHome> {
  int index = 0;
  List body = [
    ChatScreen(),
    WalletScreen(),
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
