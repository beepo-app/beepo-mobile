// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:beepo/Screens/Auth/onboarding.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

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
    print(userData);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: const SizedBox(),
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Color(0xff0e014c),
                ),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 53),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CachedNetworkImage(
                          imageUrl: userData['profilePictureUrl'],
                          height: 135,
                          width: 135,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) {
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress.progress,
                              ),
                            );
                          },
                          // placeholder: (context, url) => Container(
                          //   height: 135,
                          //   width: 135,
                          //   color: Colors.grey[300],
                          //   child: const Center(
                          //     child: Icon(Iconsax.user, color: blue),
                          //   ),
                          // ),
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
                        const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Color(0xffff9c34),
                          size: 25,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        userData['username'].toString(),
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
                    //             color: const Color(0xff0e014c),
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
                              color: Color(0xff0e014c),
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
                                color: Color(0xff0e014c),
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
                              color: Color(0xff0e014c),
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
                              color: Color(0xff0e014c),
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
                              color: Color(0xff0e014c),
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
                                color: Color(0xff0e014c),
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
                      children: const [
                        Expanded(
                          child: Text(
                            "About",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward,
                            color: Color(0x660e014c), size: 20),
                      ],
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
            ))
          ],
        ),
      ),
    );
  }
}
