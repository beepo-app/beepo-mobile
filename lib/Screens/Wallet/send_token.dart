// ignore_for_file: prefer_const_constructors

import 'package:beepo/Models/wallet.dart';
import 'package:beepo/Screens/Wallet/scan_code.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/styles.dart';
import '../../Widgets/components.dart';
import 'preview_transfer.dart';

class SendToken extends StatefulWidget {
  final Wallet wallet;
  final String balance;
  SendToken({Key key, this.wallet, this.balance}) : super(key: key);

  @override
  State<SendToken> createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  final TextEditingController amount = TextEditingController();
  final TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Send Token'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                style: TextStyle(
                  color: Color(0xff0d004c),
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  suffixText: widget.wallet.ticker ?? " ",
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
              SizedBox(height: 5),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Balance: \$${widget.balance ?? 0.0}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
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
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: IconButton(
                    onPressed: () async {
                      String scannedCode = await Get.to(() => ScanCode());
                      if (scannedCode != null) {
                        address.text = scannedCode;
                      }
                    },
                    icon: Icon(
                      Icons.qr_code_scanner_sharp,
                      size: 25,
                      color: Color(0x7f0e014c),
                    ),
                  ),
                  hintText: "Enter Address",
                  hintStyle: TextStyle(
                    color: Color(0x7f0e014c),
                    fontSize: 14,
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
              SizedBox(height: 62),
              // Align(
              //     alignment: Alignment.bottomLeft,
              //     child: Text(
              //       "Send to contacts",
              //       style: TextStyle(
              //         color: Color(0x7f0e014c),
              //         fontSize: 14,
              //       ),
              //     )),
              // SizedBox(height: 12),
              // SizedBox(
              //   height: 80,
              //   child: ListView.separated(
              //     padding: EdgeInsets.only(right: 10, left: 10),
              //     shrinkWrap: true,
              //     itemCount: 6,
              //     scrollDirection: Axis.horizontal,
              //     separatorBuilder: (ctx, i) => SizedBox(width: 10),
              //     itemBuilder: (ctx, i) {
              //       return Column(
              //         children: [
              //           ClipRRect(
              //             borderRadius: BorderRadius.circular(30),
              //             child: Image.asset(
              //               'assets/profile_img.png',
              //               height: 60,
              //               width: 60,
              //             ),
              //           ),
              //           SizedBox(height: 7),
              //           Text(
              //             "James",
              //             style: TextStyle(
              //               color: secondaryColor,
              //               fontSize: 9,
              //               fontWeight: FontWeight.w700,
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              const SizedBox(height: 70),
              FilledButtons(
                color: secondaryColor,
                text: "Continue",
                onPressed: () {
                  if (amount.text.isEmpty) {
                    showToast('Please enter amount');
                  } else if (address.text.trim().isEmpty ||
                      address.text.trim().length < 16) {
                    showToast('Please enter a valid address');
                  } else {
                    Get.to(
                      SendToken2(
                        wallet: widget.wallet,
                        amount: double.parse(amount.text),
                        address: address.text,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
