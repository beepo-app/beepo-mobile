import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Constants/app_constants.dart';
import 'package:beepo/Screens/Wallet/transfer_success.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Service/transactions.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/pin_code.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

import '../../Models/wallet.dart';
import '../../Service/xmtp.dart';
import '../../Utils/styles.dart';
import '../../Widgets/components.dart';

class ConfirmTransfer extends StatefulWidget {
  final Wallet wallet;
  final double amount;
  final String address;
  final Conversation convo;
  const ConfirmTransfer({
    Key key,
    this.wallet,
    this.amount,
    this.address,
    this.convo,
  }) : super(key: key);

  @override
  State<ConfirmTransfer> createState() => _ConfirmTransferState();
}

class _ConfirmTransferState extends State<ConfirmTransfer> {
  @override
  Widget build(BuildContext context) {
    print(widget.wallet.chainId.toString());
    return Scaffold(
      appBar: appBar('Confirm Transaction'),
      body: FutureBuilder<String>(
        future: TransactionService().estimateGasFee(
            widget.wallet.ticker == "BITCOIN"
                ? 'bitcoin'
                : widget.wallet.chainId.toString()),
        builder: (c, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          String gasFee = snapshot.data;

          return Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "You are sending",
                  style: TextStyle(
                    color: Color(0x7f0e014c),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.amount} ${widget.wallet.ticker}",
                  style: const TextStyle(
                    color: txtColor1,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "to the following wallet",
                  style: TextStyle(
                    color: Color(0x7f0e014c),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 11,
                ),
                Text(
                  widget.address,
                  style: const TextStyle(
                    color: txtColor1,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 60),
                Text(
                  "Gas Fee: $gasFee ${widget.wallet.ticker}",
                  style: const TextStyle(
                    color: txtColor1,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                FilledButtons(
                  color: secondaryColor,
                  text: "Approve",
                  onPressed: () async {
                    TextEditingController controller = TextEditingController();
                    Get.bottomSheet(
                      BottomSheet(
                        onClosing: () {},
                        enableDrag: false,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        builder: (ctx) => Container(
                          height: Get.height * 0.6,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              const Text('Transaction Pin',
                                  style: TextStyle(
                                    color: txtColor1,
                                    fontSize: 18,
                                  )),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: 100,
                                child: PinCodeTextField(
                                  appContext: context,
                                  length: 4,
                                  onChanged: (val) {},
                                  controller: controller,
                                  readOnly: true,
                                  obscuringCharacter: '*',
                                  obscureText: true,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.circle,
                                    fieldHeight: 20,
                                    fieldOuterPadding: const EdgeInsets.all(0),
                                    fieldWidth: 20,
                                    inactiveColor: Colors.grey,
                                  ),
                                  onCompleted: (value) async {
                                    //confirm pin
                                    String pin = AuthService().userPin;

                                    if (pin == value) {
                                      Get.back();
                                      loadingDialog('Sending Token...');

                                      bool result =
                                          await TransactionService().sendToken(
                                        address: widget.address,
                                        amount: widget.amount.toString(),
                                        gasFee: gasFee,
                                        networkId:
                                            widget.wallet.chainId.toString(),
                                      );
                                      Get.back();
                                      if (result) {
                                        if (widget.convo != null) {
                                          //send message
                                          var trxDetails = {
                                            'value': widget.amount.toString(),
                                            'token': widget.wallet.ticker,
                                            'address': widget.address,
                                            'type': 'transfer',
                                          };

                                          context
                                              .read<XMTPProvider>()
                                              .sendMessage(
                                                convo: widget.convo,
                                                content: jsonEncode(trxDetails),
                                              );
                                          Get.to(
                                            TransferSuccess(
                                              widget.address,
                                              widget.amount.toString(),
                                              widget.wallet.ticker,
                                            ),
                                          );
                                        } else {
                                          Get.off(
                                            TransferSuccess(
                                              widget.address,
                                              widget.amount.toString(),
                                              widget.wallet.ticker,
                                            ),
                                          );
                                        }
                                        return;
                                      }
                                    } else {
                                      showToast('Incorrect Pin');
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: NumberKeyboard(onPressed: (p0) {
                                  if (p0 == -1) {
                                    if (controller.text.isEmpty) {
                                      return;
                                    } else {
                                      controller.text = controller.text
                                          .substring(
                                              0, controller.text.length - 1);
                                      return;
                                    }
                                  } else {
                                    if (controller.text.length == 4) {
                                      return;
                                    } else {
                                      controller.text += p0.toString();
                                    }
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 105),
              ],
            ),
          );
        },
      ),
    );
  }
}
