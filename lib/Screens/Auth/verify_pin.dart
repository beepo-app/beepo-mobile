import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Utils/styles.dart';
import '../../components.dart';
import '../bottom_nav.dart';

class VerifyCode extends StatelessWidget {
  VerifyCode({Key key}) : super(key: key);

  TextEditingController otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.black,
              size: 30,
            )),
        title: const Text(
          "Verify your PIN",
          style: TextStyle(
            color: Color(0xb20e014c),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset(
                'assets/pin_img.png',
                height: 127,
                width: 127,
              ),
              SizedBox(height: 70),
              Expanded(
                child: SizedBox(
                  width: 120,
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.number,
                    length: 4,
                    obscureText: true,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 21,
                        fieldWidth: 21,
                        // activeFillColor: primaryColor,
                        activeColor: primaryColor,
                        inactiveFillColor: Colors.white,
                        inactiveColor: Colors.grey,
                        borderWidth: 3,
                        activeFillColor: Colors.white,
                        selectedColor: primaryColor,
                        selectedFillColor: Colors.white),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.white,
                    enableActiveFill: true,
                    controller: otp,
                    onCompleted: (v) {},
                    onChanged: (val) {},
                  ),
                ),
              ),
              FilledButton(
                text: 'Continue',
                onPressed: () {
                  Get.to(BottomNav());
                },
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
