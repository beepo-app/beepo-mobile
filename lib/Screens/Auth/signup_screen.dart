import 'package:beepo/Screens/Auth/create_acct.dart';
import 'package:beepo/Screens/Auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/login.png',
                height: 252,
                width: 252,
              ),
              const Spacer(),
              FilledButton(
                text: 'Create Account',
                onPressed: () => Get.to( CreateAccount()),
              ),
              const SizedBox(height: 35),
              const Text(
                "Already have an account?",
                style: TextStyle(
                  color: Color(0x4c0e014c),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              OutlnButton(
                text: 'Login',
                onPressed: () => Get.to(const Login()),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
