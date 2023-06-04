import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';
import '../Widgets/components.dart';

class RequestToken extends StatefulWidget {
  RequestToken({Key key}) : super(key: key);

  @override
  State<RequestToken> createState() => _RequestTokenState();
}

class _RequestTokenState extends State<RequestToken> {
  final TextEditingController value = TextEditingController();
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
          "Request Token",
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
                    color: secondaryColor),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.asset(
                          "assets/profile2.png",
                          height: 152,
                          width: 152,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Precious",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 57),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Amount",
                          style: TextStyle(
                            color: Color(0xe50d004c),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.phone,
                        controller: value,
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "CELO",
                                style: TextStyle(
                                  color: Color(0x7f0e014c),
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 2),
                              SizedBox(
                                width: 35,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: secondaryColor,
                                    size: 30,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          isDense: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              )),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 130),
                      FilledButtons(
                        text: 'Request',
                        color: secondaryColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
