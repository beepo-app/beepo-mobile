import 'dart:developer';

import 'package:beepo/Service/auth.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/styles.dart';
import '../../Widgets/components.dart';

class WalletPhraseScreen extends StatefulWidget {
  const WalletPhraseScreen({Key? key}) : super(key: key);

  @override
  State<WalletPhraseScreen> createState() => _WalletPhraseScreenState();
}

class _WalletPhraseScreenState extends State<WalletPhraseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Your Wallet Phrase'),
      body: SafeArea(
        child: FutureBuilder(
          future: AuthService().retrievePassphrase(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loader();
            }

            String walletPhrase = snapshot.data!;

            log(walletPhrase);

            List words = walletPhrase.split(' ');

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Please make sure to keep this secret phrase in a safe and secure location, as it is the only way to recover your account. Do not share this phrase with anyone, as it will grant them access to your account.\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 50),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 11,
                        mainAxisSpacing: 30,
                        childAspectRatio: 3,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0x72ff9b33),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${index + 1}. ${words[index]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                      itemCount: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0x99ffd1d1),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: const [
                          Text(
                            "Do not share this phrase with anyone, as it will grant them access to your account.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff680e00),
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Write Down your Seed Phrase in a Secured Place, \nThe Beepo Team will Never ask for it",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff680e00),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    FilledButtons(
                      onPressed: () {
                        // Clipboard.setData(ClipboardData(text: walletPhrase));
                        // showToast("Copied to clipboard successfully");
                        Get.close(2);
                      },
                      color: secondaryColor,
                      text: 'I have written it down',
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
