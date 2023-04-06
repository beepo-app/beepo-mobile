import 'dart:io';

import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Service/auth.dart';
import '../../Utils/styles.dart';
import '../../bottom_nav.dart';
import '../../components.dart';

class VerifyCode extends StatefulWidget {
  final File image;
  final String name;
  final bool isSignUp;
  final String seedPhrase;
  const VerifyCode(
      {Key key, this.image, this.name, this.isSignUp, this.seedPhrase})
      : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Verify your PIN",
          style: TextStyle(
            color: Color(0xb20e014c),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Image.asset(
              'assets/pin_img.png',
              height: 127,
              width: 127,
            ),
            const SizedBox(height: 70),
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
                onChanged: (val) {},
              ),
            ),
            const Spacer(),
            CustomFilledButton(
              text: 'Continue',
              onPressed: () async {
                String pin = Hive.box('beepo').get('PIN');
                if (pin == otp.text) {
                  if (widget.isSignUp) {
                    //Signup

                    Get.to(
                      fullScreenLoader('Creating Account...'),
                      fullscreenDialog: true,
                    );

                    bool result = await AuthService().createUser(
                      widget.name,
                      widget.image,
                      pin,
                    );

                    Get.back();
                    if (result) {
                      showToast('Account created successfully');
                      Get.offAll(BottomNavHome());
                    }
                  } else {
                    //Login with seedphrase
                    Get.to(
                      fullScreenLoader('Logging in...'),
                      fullscreenDialog: true,
                    );

                    bool result = await AuthService().loginWithSecretPhrase(
                      widget.seedPhrase,
                      pin,
                    );

                    if (result) {
                      showToast('Login successful');
                      Get.offAll(const BottomNavHome());
                    }
                  }
                } else {
                  showToast('PIN does not match');
                }
              },
            ),
            const SizedBox(height: 40, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
