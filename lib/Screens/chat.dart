// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

import '../components.dart';

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
        body: Container(
          height: 700,
          width: double.infinity,
          color: const Color(0xff0e014c),
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
                  children: [ChatTab(), CallTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
