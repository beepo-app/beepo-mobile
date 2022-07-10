import 'package:beepo/Screens/Auth/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components.dart';
import 'create_acct.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.black,
              size: 30,
            )),
        title: const Text(
          "Enter  your secret phrase below to login",
          style: TextStyle(
            color: const Color(0xb20e014c),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Phrase",
                  style: TextStyle(
                    color: Color(0x660e014c),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 315,
                height: 192,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff0e014c),
                    width: 1,
                  ),
                  color: const Color(0x00c4c4c4),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "This is usually a 12 word phrase",
                style: TextStyle(
                  color: Color(0x4c0e014c),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              FilledButton(
                text: 'Login',
                onPressed: () => Get.to(const PinCode()),
              ),
              const Spacer()
            ],
          )),
    );
  }
}
