// ignore_for_file: prefer_const_constructors

import 'package:beepo/Screens/Profile/wallet_phrase.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components.dart';

class PhraseConfirmation extends StatefulWidget {
  const PhraseConfirmation();

  @override
  State<PhraseConfirmation> createState() => _PhraseConfirmationState();
}

class _PhraseConfirmationState extends State<PhraseConfirmation> {
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Wallet Phrase'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "In the next step, you will be given a \"Secret Phrase\" of 12 words to secure your account. \nKeep it safe and confidential, as it's the only way to recover your account. Sharing the phrase will grant access to your account to others.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 20),
              Lottie.asset(
                'assets/lottie/security.json',
                height: 200,
                width: 200,
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                value: value1,
                onChanged: (value) {
                  setState(() {
                    value1 = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  "If I lose my secret phrase, my assets and Beepo account will be lost forever.",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              CheckboxListTile(
                value: value2,
                onChanged: (value) {
                  setState(() {
                    value2 = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  "If I expose or share my secret phrase to anybody, my assets can get stolen.",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              CheckboxListTile(
                value: value3,
                onChanged: (value) {
                  setState(() {
                    value3 = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  "I agree that the Beepo App and Beepo Inc. team will NEVER reach out to ask for it.",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              CheckboxListTile(
                value: value4,
                onChanged: (value) {
                  setState(() {
                    value4 = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  "The Beepo app is user centric and decentralized therefore I am responsible for the security and protection of my Beepo account and assets within",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FilledButton(
                text: 'Proceed',
                onPressed: () {
                  if (value1 && value2 && value3 && value4) {
                    Get.to(WalletPhraseScreen());
                  } else {
                    showToast('Please check all the boxes to proceed');
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
