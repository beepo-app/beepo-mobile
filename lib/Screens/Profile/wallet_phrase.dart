import 'package:beepo/Service/auth.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:flutter/material.dart';

class WalletPhraseScreen extends StatefulWidget {
  const WalletPhraseScreen({Key key}) : super(key: key);

  @override
  State<WalletPhraseScreen> createState() => _WalletPhraseScreenState();
}

class _WalletPhraseScreenState extends State<WalletPhraseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: AuthService().retrievePassphrase(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loader();
          }
          return Column(
            children: [],
          );
        },
      ),
    );
  }
}
