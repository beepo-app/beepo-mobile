import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';

import '../Utils/styles.dart';

class Security extends StatefulWidget {
  const Security({Key key}) : super(key: key);

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool enable = false;
  bool enable1 = false;

  bool enable2 = false;

  bool isLocked = Hive.box('beepo').get('isLocked', defaultValue: false);

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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          "Security",
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
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Color(0xff0e014c)),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Login with Biometrics",
                            style: TextStyle(
                              color: Color(0xff0e014c),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Switch(
                            value: isLocked,
                            activeColor: blue,
                            onChanged: (value) {
                              LocalAuthentication()
                                  .authenticate(
                                localizedReason: 'Please authenticate to continue',
                              )
                                  .then((val) {
                                if (val) {
                                  setState(() {
                                    isLocked = !isLocked;
                                  });
                                  Hive.box('beepo').put('isLocked', isLocked);
                                }
                              });
                            })
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
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
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}