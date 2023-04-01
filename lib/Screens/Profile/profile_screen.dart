// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:beepo/Screens/Auth/onboarding.dart';
import 'package:beepo/Screens/Profile/edit_profile.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Utils/styles.dart';
import '../language_screen.dart';
import '../security_screen.dart';

class Profile extends StatefulWidget {
  // const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map userData;

  @override
  Widget build(BuildContext context) {
    userData = Hive.box('beepo').get('userData');
    return Scaffold(
      appBar: appBar('My Profile'),
      body: FutureBuilder<Map>(
          future: AuthService().getUser(),
          initialData: userData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            userData = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: userData['profilePictureUrl'] == null
                            ? Container(
                                height: 135,
                                width: 135,
                                color: Colors.grey[300],
                                child: const Center(
                                  child:
                                      Icon(Iconsax.user, color: primaryColor),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: userData['profilePictureUrl'],
                                height: 135,
                                width: 135,
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
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userData['displayName'].toString(),
                          style: const TextStyle(
                            color: Color(0xffff9c34),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Get.to(() => EditProfile(userData))
                              .then((value) => setState(() {})),
                          child: const Icon(
                            Icons.mode_edit_outlined,
                            color: Color(0xffff9c34),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "@" + userData['username'].toString(),
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: GestureDetector(
                    //         onTap: () => Get.to(AccountType()),
                    //         child: const Text(
                    //           "Account Type",
                    //           style: TextStyle(
                    //             color: const secondaryColor,
                    //             fontSize: 14,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const Text(
                    //       "Professional",
                    //       style: TextStyle(
                    //         color: Color(0x660e014c),
                    //         fontSize: 14,
                    //       ),
                    //     )
                    //   ],
                    // ),

                    // const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Theme",
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Text(
                          "System Default",
                          style: TextStyle(
                            color: Color(0x660e014c),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(Security()),
                            child: const Text(
                              "Security",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward,
                            color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Help",
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward,
                            color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Invite Friends",
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward,
                            color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Notification",
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward,
                            color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(Language()),
                            child: const Text(
                              "Language",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward,
                            color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    const SizedBox(height: 26),
                    InkWell(
                      onTap: () => launchUrlString('https://www.beepoapp.net'),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "About",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              color: Color(0x660e014c), size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Get.dialog(AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Hive.box('beepo').clear();
                                Get.offAll(Onboarding());
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        ));
                      },
                      title: const Text(
                        "Log Out",
                        style: TextStyle(color: secondaryColor, fontSize: 14),
                      ),
                      trailing: const Icon(Icons.logout, size: 20),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
