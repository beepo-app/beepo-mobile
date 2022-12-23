import 'package:beepo/Service/auth.dart';
import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Utils/styles.dart';
import '../../components.dart';

class WalletPhraseScreen extends StatefulWidget {
  const WalletPhraseScreen({Key key}) : super(key: key);

  @override
  State<WalletPhraseScreen> createState() => _WalletPhraseScreenState();
}

class _WalletPhraseScreenState extends State<WalletPhraseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet Phrase'),
        backgroundColor: secondaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          // future: EncryptionService().getSeedPhrase(),
          future: AuthService().retrievePassphrase(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loader();
            }

            String walletPhrase = snapshot.data;

            // print(snapshot.data);
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      snapshot.data,
                      style: const TextStyle(
                        wordSpacing: 24,
                        height: 2,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: walletPhrase));
                      showToast("Copied to clipboard successfully");
                    },
                    text: 'Copy to Clipboard',
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
