import 'package:beepo/Service/auth.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:beepo/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Utils/styles.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key key}) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Image.asset(
              'assets/logo2.png',
              height: 127,
              width: 127,
            ),
            const SizedBox(height: 70),
            const Text(
              'Enter your PIN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.size.width * 0.6,
              child: PinCodeTextField(
                appContext: context,
                keyboardType: TextInputType.number,
                length: 4,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.circle,
                  fieldHeight: 30,
                  fieldWidth: 30,
                  activeColor: primaryColor,
                  inactiveFillColor: Colors.white,
                  inactiveColor: Colors.grey,
                  borderWidth: 3,
                  fieldOuterPadding: EdgeInsets.zero,
                  activeFillColor: Colors.white,
                  selectedColor: primaryColor,
                  selectedFillColor: Colors.white,
                ),
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: otp,
                onCompleted: (v) {
                  if (v == AuthService().userPin) {
                    Get.offAll(BottomNavHome());
                  } else {
                    showToast('Invalid PIN');
                  }
                },
                onChanged: (String value) {},
              ),
            ),
            const SizedBox(height: 40, width: double.infinity),
            const Text(
              'Or use biometrics',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                LocalAuthentication().authenticate(localizedReason: ' ').then(
                  (val) {
                    if (val) {
                      Get.offAll(BottomNavHome());
                    } else {
                      showToast('Authentication failed');
                    }
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.3),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.fingerprint,
                  size: 40,
                  color: blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
