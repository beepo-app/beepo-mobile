import 'dart:io';

import 'package:beepo/Screens/Auth/phrase_screen.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Utils/functions.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:beepo/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../components.dart';
import 'pin_code.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController displayName = TextEditingController();
  File selectedImage;
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
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(selectedImage),
                        )
                      : const Icon(
                          Icons.person_outlined,
                          size: 117,
                          color: Color(0x66000000),
                        ),
                ),
                Positioned(
                  right: 17,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: () {
                      Get.dialog(Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo_camera),
                                title: const Text("Take a photo"),
                                onTap: () async {
                                  Get.back();
                                  XFile image = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  if (image != null) {
                                    ImageUtil().cropProfileImage(image).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedImage = value;
                                        });
                                      }
                                    });
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text("Choose from gallery"),
                                onTap: () async {
                                  Get.back();
                                  XFile image = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    ImageUtil().cropProfileImage(image).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedImage = value;
                                        });
                                      }
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ));
                    },
                    child: Container(
                      width: 30,
                      height: 30,
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
                  if (selectedImage == null) {
                    showToast('Please select a profile picture');
                    return;
                  }
                  Get.dialog(Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
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
                            'Creating account...',
                            style: Get.textTheme.headline6,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ));

                  String imageUrl =
                      await AuthService.updateUserProfileImage(selectedImage);
                  // if (backupPhrase != null) {
                  //   showToast('Account created successfully');
                  //   Get.to(PhraseScreen(phrase: backupPhrase));
                  // }
                  if (imageUrl != null) {
                    bool result =
                        await AuthService.createUser(displayName.text.trim(), imageUrl);
                    Get.back();
                    if (result) {
                      showToast('Account created successfully');
                      Get.offAll(const PinCode());
                    } else {
                      showToast('Something went wrong');
                    }
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
