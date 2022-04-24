import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components.dart';
import 'pin_code.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
                size: 30,
              )),
          title: const Text(
            "Create your account",
            style: TextStyle(
              color: Color(0xb20e014c),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )),
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
              TextField(),
              const Spacer(),
              FilledButton(
                text: 'Next',
                onPressed: () => Get.to(PinCode()),
              ),
              const Spacer()
            ],
          )),
    );
  }
}
