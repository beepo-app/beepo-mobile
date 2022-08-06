import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';
import '../components.dart';
import 'requestToken.dart';

class ChatToken extends StatefulWidget {
  ChatToken({Key key}) : super(key: key);

  @override
  State<ChatToken> createState() => _ChatTokenState();
}

class _ChatTokenState extends State<ChatToken> {
  final TextEditingController value = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (() => Get.back()),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          "Send Token",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Color(0xff0e014c)),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.asset(
                          "assets/profile2.png",
                          height: 152,
                          width: 152,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Precious",
                        style: TextStyle(
                          color: const Color(0xff0e014c),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 57),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Amount",
                          style: TextStyle(
                            color: const Color(0xe50d004c),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.phone,
                        controller: value,
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "CELO",
                                style: TextStyle(
                                  color: Color(0x7f0e014c),
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 2),
                              SizedBox(
                                width: 35,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xff0e014c),
                                    size: 30,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          isDense: true,
                          border: const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              )),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 130),
                      FilledButton(
                        text: 'Send',
                        color: blue,
                        onPressed: () => Get.to(RequestToken()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
