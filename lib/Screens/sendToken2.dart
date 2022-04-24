import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';
import '../components.dart';

class SendToken2 extends StatefulWidget {
  SendToken2({Key key}) : super(key: key);

  @override
  State<SendToken2> createState() => _SendToken2State();
}

class _SendToken2State extends State<SendToken2> {
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
        title: Column(
          children: [
            Text(
              "Send Token",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "Confirm Transaction",
              style: TextStyle(
                color: Color(0xccffffff),
                fontSize: 14,
              ),
            )
          ],
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
            SizedBox(height: 33),
            Text(
              "You are sending",
              style: TextStyle(
                color: Color(0x7f0e014c),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "500 CELO",
              style: TextStyle(
                color: Color(0xe50d004c),
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "to the following wallet",
              style: TextStyle(
                color: Color(0x7f0e014c),
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              "0x0E61830c8e35db159eF816868AfcA1388781796e",
              style: TextStyle(
                color: Color(0xe50d004c),
                fontSize: 12,
              ),
            ),
            Spacer(),
            Text(
              "Gas Fee: 0.0098 CELO",
              style: TextStyle(
                color: Color(0xe50d004c),
                fontSize: 12,
              ),
            ),
            Spacer(),
            FilledButton(
              color: blue,
              text: "Approve",
              onPressed: () {},
            ),
            SizedBox(height: 105),
          ],
        ),
      ),
    );
  }
}
