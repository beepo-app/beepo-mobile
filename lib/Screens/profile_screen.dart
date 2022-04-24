import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'account_type.dart';
import 'language_screen.dart';
import 'security_screen.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: SizedBox(),
        title: Text(
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Color(0xff0e014c)),
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 53),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: Image.asset(
                          'assets/profile_img1.png',
                          height: 135,
                          width: 135,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Yomna Elema",
                          style: TextStyle(
                            color: Color(0xffff9c34),
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Color(0xffff9c34),
                          size: 25,
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(AccountType()),
                            child: Text(
                              "Account Type",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "Professional",
                          style: TextStyle(
                            color: Color(0x660e014c),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Theme",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          "System Default",
                          style: TextStyle(
                            color: Color(0x660e014c),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Store",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Statistics",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(Security()),
                            child: Text(
                              "Security",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Help",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Invite Friends",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Notification",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(Language()),
                            child: Text(
                              "Language",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "About",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Color(0x660e014c), size: 20),
                      ],
                    ),
                    SizedBox(height: 20)
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
