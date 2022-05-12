import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components.dart';
import '../bottom_nav.dart';
import 'login_screen.dart';

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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(
                'assets/login.png',
                height: 252,
                width: 252,
              ),
              Spacer(),
              FilledButton(
                text: 'Create Account',
                onPressed: () => Get.to(Login()),
              ),
              SizedBox(height: 35),
              const Text(
                "Already have an account?",
                style: TextStyle(
                  color: Color(0x4c0e014c),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12),
              OutlnButton(
                text: 'Login',
                onPressed: () => Get.to(BottomNav()),
              ),
              SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
