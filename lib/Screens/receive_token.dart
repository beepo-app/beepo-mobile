import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../Models/wallet.dart';
import '../Utils/styles.dart';

class ReceiveToken extends StatefulWidget {
  final Wallet wallet;
  const ReceiveToken({Key key, this.wallet}) : super(key: key);

  @override
  State<ReceiveToken> createState() => _ReceiveTokenState();
}

class _ReceiveTokenState extends State<ReceiveToken> {
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
                    color: Color(0xff0e014c)),
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
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: CachedNetworkImageProvider(
                          widget.wallet.logoUrl,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.wallet.ticker,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      QrImage(
                        data: widget.wallet.address,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.wallet.address,
                            style: const TextStyle(
                              color: Color(0x7f0e014c),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 17),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.wallet.address));
                          Get.snackbar(
                            'Copied to clipboard',
                            'Address copied to clipboard',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        icon: const Icon(
                          Icons.copy_outlined,
                          color: blue,
                        ),
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
