import 'package:beepo/Screens/Auth/phrase_screen.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components.dart';
import 'pin_code.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController displayName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Create your account",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 131,
                  height: 131,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffc4c4c4),
                  ),
                  child: Icon(
                    Icons.person_outlined,
                    size: 117,
                    color: Color(0x66000000),
                  ),
                ),
                Positioned(
                  right: 17,
                  bottom: 12,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff0e014c),
                    ),
                    child: const Icon(
                      Icons.photo_camera_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Display name",
                style: TextStyle(
                  color: Color(0x4c0e014c),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextField(
              controller: displayName,
            ),
            const Spacer(),
            FilledButton(
              text: 'Next',
              onPressed: () async {
                if (displayName.text.trim().isEmpty) {
                  showToast('Please enter a display name');
                  return;
                } else {
                  String backupPhrase =
                      await AuthService.createUser(displayName.text.trim());
                  if (backupPhrase != null) {
                    showToast('Account created successfully');
                    Get.to(PhraseScreen(phrase: backupPhrase));
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
