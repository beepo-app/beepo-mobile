// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:io';

import 'package:beepo/Utils/styles.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/functions.dart';
import '../../components.dart';
import 'pin_code.dart';

class CreateAccount extends StatefulWidget {
  // const CreateAccount({Key key}) : super(key: key);

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
                          child: Image.file(
                            selectedImage,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ))
                      : const Icon(
                          Icons.person_outlined,
                          size: 117,
                          color: Color(0x66000000),
                        ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: () {
                      ImageUtil()
                          .pickProfileImage(context: context)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            selectedImage = value;
                          });
                        }
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                      ),
                      child: const Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.white,
                        size: 20,
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
            FilledButtons(
              text: 'Next',
              color: Color(0xffFF9C34),
              onPressed: () async {
                if (displayName.text.trim().isEmpty) {
                  showToast('Please enter a display name');
                  return;
                } else {
                  Get.to(PinCode(
                    image: selectedImage,
                    name: displayName.text.trim(),
                  ));
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
