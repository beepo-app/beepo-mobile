import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/styles.dart';
import 'signup_screen.dart';
import 'package:lottie/lottie.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key key}) : super(key: key);

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

  List<Map<String, String>> body = [
    {
      'image': 'assets/onboard1.png',
      'text':
          'Beepo  is a decentralized social media platform that prioritizes anonymity with small-scale business capabilities.'
    },
    {
      'image': 'assets/onboard2.png',
      'text':
          'Beepo enables seamless communication and media sharing with family and friends using an enhanced E2EE protocol.'
    },
    {
      'image': 'assets/onboard3.png',
      'text':
          'Beepo is designed to meet the needs of small scale business owners and freelancers for secured and decentralized transactions'
    }
  ];

  List titles = [
    "Welcome to Beepo",
    "E2EE Security",
    "Scale Your Business",
  ];

  List lotties = [
    'assets/lottie/lott_2.json',
    'assets/lottie/lott_3.json',
    'assets/lottie/lott_4.json',
    'assets/lottie/lottie_1.json',
  ];

  // static get image => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: bg,
          padding: const EdgeInsets.all(21),
          child: Column(
            children: [
              Expanded(
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
                        const Spacer(),
                        Lottie.asset(lotties[index]),
                        const SizedBox(height: 30),
                        Text(
                          titles[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          body[index]['text'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: 237,
                height: 42,
                child: TextButton(
                  onPressed: () {
                    if (check == body.length - 1) {
                      Get.to(const SignUp());
                    } else {
                      controller.animateToPage(
                        check + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }

                    controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: Text(
                    check == body.length - 1 ? 'Completed' : 'Next',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      check == body.length - 1 ? secondaryColor : primaryColor,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
