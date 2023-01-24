import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'Screens/Browser/browser.dart';
import 'Screens/Messaging/chat.dart';
import 'Screens/Profile/profile_screen.dart';
import 'Screens/Wallet/wallet_screen.dart';

class BottomNavHome extends StatefulWidget {
  const BottomNavHome({Key key}) : super(key: key);

  @override
  State<BottomNavHome> createState() => _BottomNavHomeState();
}

class _BottomNavHomeState extends State<BottomNavHome> {
  @override
  void initState() {
    super.initState();
  }

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
