import 'package:beepo/Utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:beepo/Models/transaction.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/functions.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction? transaction;
  final String? walletTicker;
  const TransactionDetails({Key? key, this.transaction, this.walletTicker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSent = transaction!.type == 'transfer';

    return Scaffold(
      body: Container(
        color: bg,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 7, right: 25),
                    height: 121,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xff0e014c),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_outlined,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                onPressed: () {}),
                            const Text(
                              "Transfer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ReusableTransferText(
              text: (isSent ? '-' : '+') +
                  "${transaction!.value.toPrecision(5)} $walletTicker",
              color: isSent ? Colors.red : Colors.green,
              size: 20,
              fontWeight: FontWeight.bold,
            ),
            // const SizedBox(height: 12),
            // const ReusableTransferText(
            //   text: "~\$113,96",
            //   color: Colors.grey,
            //   fontWeight: FontWeight.bold,
            // ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableTransferText(
                    text: "Date",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  ReusableTransferText(
                    text: formatDate(DateTime.fromMillisecondsSinceEpoch(
                      transaction!.timestamp * 1000,
                    )),
                    size: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableTransferText(
                    text: "Status",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  ReusableTransferText(
                    text: transaction!.confirmed ? "Confirmed" : "Pending",
                    size: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.green.shade500,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableTransferText(
                    text: "Transaction Type",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  ReusableTransferText(
                    text: transaction!.type.capitalizeFirst!,
                    size: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  ReusableTransferText(
                    text: isSent ? "Recipient" : "Sender",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ReusableTransferText(
                      text: isSent ? transaction!.to : transaction!.from,
                      size: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      color: Colors.grey,
                      align: TextAlign.right,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableTransferText(
                    text: "Network Fee",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  const Spacer(),
                  Expanded(
                    child: ReusableTransferText(
                      text: "${transaction!.gasfee} $walletTicker",
                      size: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      color: Colors.grey,
                      align: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              child: const ReusableTransferText(
                text: "More Details",
                size: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: secondaryColor,
              ),
              onPressed: () {
                launchUrl(Uri.parse(transaction!.url));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableTransferText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final TextAlign? align;
  const ReusableTransferText({
    Key? key,
    required this.text,
    this.color,
    this.size,
    this.fontWeight,
    this.letterSpacing = 2,
    this.textOverflow,
    this.align,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        overflow: textOverflow,
      ),
      textAlign: align,
    );
  }
}
