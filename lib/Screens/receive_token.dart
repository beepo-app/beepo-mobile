import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';

class ReceiveToken extends StatefulWidget {
  ReceiveToken({Key key}) : super(key: key);

  @override
  State<ReceiveToken> createState() => _ReceiveTokenState();
}

class _ReceiveTokenState extends State<ReceiveToken> {
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
          "Request Token",
          style: TextStyle(
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
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          "assets/Celo.png",
                          height: 78,
                          width: 78,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "CELO",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/scan.png',
                        height: 242,
                        width: 243,
                      ),
                      SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "0x0E61830c8e35db159eF8",
                            style: TextStyle(
                              color: Color(0x7f0e014c),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 17),
                          IconButton(
                              // onPressed: (){},
                              icon: Icon(
                            Icons.copy_outlined,
                            color: blue,
                          ))
                        ],
                      )
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
