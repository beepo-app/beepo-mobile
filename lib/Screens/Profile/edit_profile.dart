import 'dart:io';

import 'package:beepo/Service/auth.dart';
import 'package:beepo/Service/media.dart';
import 'package:beepo/Utils/functions.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/textfields.dart';
import 'package:beepo/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../Widgets/toasts.dart';

class EditProfile extends StatefulWidget {
  final Map data;
  const EditProfile(this.data);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  File file;

  @override
  void initState() {
    super.initState();
    displayNameController.text = widget.data['displayName'];
    userNameController.text = widget.data['username'];
    bioController.text = widget.data['description'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Edit Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: file != null
                          ? Image.file(
                              file,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                          : widget.data['profilePictureUrl'] == null
                              ? Container(
                                  height: 120,
                                  width: 120,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child:
                                        Icon(Iconsax.user, color: primaryColor),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: widget.data['profilePictureUrl'],
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    );
                                  },
                                ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          //pick image
                          file = await ImageUtil()
                              .pickProfileImage(context: context);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Display name',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 14,
                ),
              ),
              Text(
                "Your display name can only be edit once in 30days",
                style: TextStyle(
                  color: Color(0x660e014c),
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter your display name',
                controller: displayNameController,
              ),
              SizedBox(height: 20),
              Text(
                'Username',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 14,
                ),
              ),
              Text(
                "Your username can only be edit once in every 6months",
                style: TextStyle(
                  color: Color(0x660e014c),
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter your username',
                controller: userNameController,
              ),
              SizedBox(height: 20),
              Text(
                'Bio',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 14,
                ),
              ),
              Text(
                "Max 100 Characters",
                style: TextStyle(
                  color: Color(0x660e014c),
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter your bio',
                controller: bioController,
              ),
              SizedBox(height: 40),
              Center(
                child: FilledButton(
                  text: 'Save',
                  onPressed: () async {
                    if (displayNameController.text.isEmpty) {
                      showToast('Display name cannot be empty');
                    } else if (userNameController.text.isEmpty) {
                      showToast('Username cannot be empty');
                    } else {
                      //save changes
                      loadingDialog('Saving changes...');
                      String imgUrl = widget.data['profilePictureUrl'];
                      if (file != null) {
                        imgUrl = await MediaService.uploadProfilePicture(file);
                      }
                      await AuthService().editProfile(
                        displayName: displayNameController.text,
                        username: userNameController.text,
                        imgUrl: imgUrl,
                      );
                      Get.back();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
