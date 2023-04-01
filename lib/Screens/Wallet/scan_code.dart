// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:beepo/Utils/styles.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:beepo/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanCode extends StatefulWidget {
  const ScanCode({Key key}) : super(key: key);

  @override
  State<ScanCode> createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  String result;
  QRViewController controller;
  bool runOnce = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: Get.height / 1.5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                borderColor: primaryColor,
                borderRadius: 10,
              ),
              onQRViewCreated: (controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  // setState(() {
                  //   result = scanData.code;
                  // });

                  bool isAddress = scanData.code.startsWith('0x');
                  if (!isAddress) {
                    showToast('Invalid Address');
                    return;
                  } else {
                    if (runOnce) {
                      runOnce = false;
                      Get.back(result: scanData.code);
                    }
                  }
                });
                if (Platform.isAndroid) {
                  controller.pauseCamera();
                  controller.resumeCamera();
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Scan Code',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          OutlnButton(text: 'Back', onPressed: () => Get.back())
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
