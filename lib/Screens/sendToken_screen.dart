import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';
import '../components.dart';
import 'sendToken2.dart';

class SendToken extends StatefulWidget {
  SendToken({Key key}) : super(key: key);

  @override
  State<SendToken> createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  final TextEditingController amount = TextEditingController();
  final TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Send Token",
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
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 10),
                height: 132,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff0e014c),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Amount",
                          style: TextStyle(
                            color: Color(0xe50d004c),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          // prefix: Icon(Icons.search),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("CELO",
                                  style: TextStyle(
                                    color: Color(0x7f0e014c),
                                    fontSize: 18,
                                  )),
                            ),
                          ),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Address",
                          style: TextStyle(
                            color: Color(0xe50d004c),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: address,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: Icon(Icons.qr_code_scanner_sharp,
                              size: 25, color: Color(0x7f0e014c)),
                          hintText: "Enter Address",
                          hintStyle: TextStyle(
                            color: Color(0x7f0e014c),
                            fontSize: 14,
                          ),
                          // suffixText: "CELO",
                          // suffixStyle: TextStyle(
                          //   color: Color(0x7f0e014c),
                          //   fontSize: 14,
                          // ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 62),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Send to contacts",
                            style: TextStyle(
                              color: Color(0x7f0e014c),
                              fontSize: 14,
                            ),
                          )),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          shrinkWrap: true,
                          itemCount: 6,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (ctx, i) => SizedBox(width: 10),
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    'assets/profile_img.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "James",
                                  style: TextStyle(
                                    color: blue,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 70),
                      FilledButton(
                        color: blue,
                        text: "continue",
                        onPressed: () => Get.to(SendToken2()),
                      ),
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
