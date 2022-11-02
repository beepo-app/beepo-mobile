import 'package:beepo/Screens/Auth/pin_code.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Service/mqtt.dart';
import '../../components.dart';
import 'create_acct.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController phraseController = TextEditingController(
        text: 'flash orient circle frog put item slab tank little doll effort enlist');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // leading: Ba,
        foregroundColor: Colors.black,
        title: const Text(
          "Login",
          style: TextStyle(
            color: Color(0xb20e014c),
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
            TextField(
              controller: phraseController,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Enter your secret phrase',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
              onPressed: () async {
                String phrase = phraseController.text.trim();
                if (phrase.isEmpty) {
                  // showToast('Please enter your secret phrase');
                  connect();
                } else {
                  Get.to(
                    Material(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Lottie.asset(
                                    'assets/lottie/lottie_1.json',
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                                Text(
                                  'Logging in...',
                                  style: Get.textTheme.headline6,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    fullscreenDialog: true,
                  );
                  bool result = await AuthService().loginWithSecretPhrase(phrase);
                  Get.back();
                  if (result) {
                    showToast('Logged in successfully');
                    Get.offAll(const PinCode());
                  } else {
                    showToast('Something went wrong');
                  }
                }
              },
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
