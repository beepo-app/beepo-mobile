import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Models/wallet.dart';
import '../send_global.dart';
import '../receive_token.dart';

class WalletToken extends StatefulWidget {
  final Wallet wallet;
  final String balance;
  const WalletToken({Key key, this.wallet, this.balance}) : super(key: key);

  @override
  State<WalletToken> createState() => _WalletTokenState();
}

class _WalletTokenState extends State<WalletToken> {
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
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  color: Color(0xff0e014c)),
              child: Column(children: [
                const SizedBox(height: 75),
                CircleAvatar(
                  radius: 28,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.wallet.logoUrl,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.balance + " " + widget.wallet.ticker,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Column(
                      children: [
                        Transform.rotate(
                          angle: 24.5,
                          child: IconButton(
                              onPressed: () => Get.to(SendGlobal()),
                              icon: const Icon(
                                Icons.send_outlined,
                                size: 30,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Send',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => Get.to(ReceiveToken(
                            wallet: widget.wallet,
                          )),
                          icon: const Icon(Icons.file_download_sharp,
                              size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Receive',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(),
                  ],
                ),
              ]),
            ),
          ),
          const SizedBox(height: 22),
          ListTile(
            minLeadingWidth: 10,
            leading: const Icon(
              Icons.qr_code_scanner_sharp,
              size: 30,
              color: Color(0xff0e014c),
            ),
            title: const Text(
              "Your address",
              style: TextStyle(
                color: Color(0xff0e014c),
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              widget.wallet.address,
              style: const TextStyle(
                color: Color(0x7f0e014c),
                fontSize: 12,
              ),
            ),
            trailing: IconButton(
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
                size: 30,
                color: Color(0xff0e014c),
              ),
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
          ),

          // Expanded(
          //   child: Container(
          //     color: Colors.white,
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       padding: EdgeInsets.zero,
          //       itemCount: 7,
          //       itemBuilder: (ctx, i) {
          //         return ListTile(
          //           minLeadingWidth: 10,
          //           leading: const Icon(Icons.arrow_downward,
          //               size: 20, color: Color(0xff0e014c)),
          //           title: Row(
          //             children: [
          //               const Expanded(
          //                 child: const Text(
          //                   "Deposit",
          //                   style: TextStyle(
          //                     color: const Color(0xff0e014c),
          //                     fontSize: 13,
          //                   ),
          //                 ),
          //               ),
          //               const Text(
          //                 "+0.23 CELO",
          //                 style: TextStyle(
          //                   color:  Color(0xff08aa48),
          //                   fontSize: 13,
          //                 ),
          //               )
          //             ],
          //           ),
          //           subtitle: const Text(
          //             "From: 0x0G61836c8e35db159eG816868AfcA1388781796e",
          //             style: TextStyle(
          //               color: Color(0x7f0e014c),
          //               fontSize: 11,
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
