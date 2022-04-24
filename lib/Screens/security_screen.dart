import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';

class Security extends StatefulWidget {
  Security({Key key}) : super(key: key);

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool enable = false;
  bool enable1 = false;

  bool enable2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (() => Get.back()),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
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
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Security",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff0e014c),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 60),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Login with Biometrics",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                              value: enable,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  enable = value;
                                });
                              })
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Auto Lock",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                              value: enable1,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  enable1 = value;
                                });
                              })
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Store Media for 30 days",
                              style: TextStyle(
                                color: Color(0xff0e014c),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Switch(
                              value: enable2,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  enable2 = value;
                                });
                              })
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
