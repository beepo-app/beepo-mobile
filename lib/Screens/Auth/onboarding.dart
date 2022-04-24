import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Utils/styles.dart';
import 'signup_screen.dart';

class Onboarding extends StatefulWidget {
  Onboarding({Key key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int check = 0;
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // int index = 0;

  // List body = [
  List<Map<String, String>> body = [
    {
      'image': 'assets/onboard1.png',
      'text':
          'Access an easy-to-use Chat platform that does not track or store your personal information.'
    },
    {
      'image': 'assets/onboard2.png',
      'text':
          'Web3 wallet that is multi-chain, non-custodial, NFT integrated, and communications enabled. \nSend and receive messages and notifications, make audio and video calls, \ntransfer funds, and purchase and store NFTs in a non-custodial blockchain wallet.'
    },
    {
      'image': 'assets/onboard3.png',
      'text':
          'Scanning user codes is a simple way to send tips and interact with people all around the world.'
    }
  ];

  // static get image => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: bg,
      //   elevation: 0,
      // ),
      body: Container(
        color: bg,
        padding: EdgeInsets.all(21),
        child: Column(
          children: [
            SizedBox(height: 60),
            Expanded(
              // flex: 3,
              child: PageView.builder(
                controller: controller,
                onPageChanged: (int index) {
                  setState(() {
                    check = index;
                  });
                },
                itemCount: body.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(
                        body[index]['image'],
                        height: 376,
                        width: 293,
                      ),
                      SizedBox(height: 18),
                      Text(
                        body[index]['text'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff0e014c),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 40)
                    ],
                  );
                },
              ),
            ),
            Container(
              height: 42,
              child: SizedBox(
                width: 237,
                height: 42,
                child: TextButton(
                  onPressed: () {
                    if (check == body.length - 1) {
                      Get.to(SignUp());
                    } else {
                      controller.animateToPage(check + 1,
                          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                    }

                    controller.nextPage(
                        duration: Duration(milliseconds: 500), curve: Curves.easeIn);

                    //     Get.to(
                    //       Chart(),
                    //     );
                    //   } else {
                    //     Get.to(Onboard(value: check + 1));
                    //   }
                  },
                  child: Text(
                    check == body.length - 1 ? 'Completed' : 'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      check == body.length - 1 ? blue : primaryColor,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
      // bottomNavigationBar: FilledButton(
      //   text: 'continue',
      //   onPressed: () => Get.to(Chart()),
      // ),
    );
  }
}
