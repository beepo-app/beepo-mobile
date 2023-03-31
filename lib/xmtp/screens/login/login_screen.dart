import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

import '../../data/xmtp/session.dart';
import '../../di/injection.dart';
import '../../domain/repository/account_repository.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _editingController = TextEditingController();

  final AccountRepository _accountRepository = getIt();
  final Session _session = getIt();

  _loginWithWallet() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Coming soon"),
          content: const Text("This feature is coming soon."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  _loginAsGuest() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
      barrierDismissible: false,
    );

    var wallet = EthPrivateKey.createRandom(Random.secure());
    await _accountRepository.savePrivateKey(
      bytesToHex(wallet.privateKey, include0x: true),
    );
    await _session.initSession(wallet);

    if (mounted) {
      Navigator.pop(context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) {
            return const HomeScreen();
          },
        ),
        (route) => false,
      );
    }
  }

  _importWallet() async {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
      barrierDismissible: false,
    );

    var privateKey = _editingController.text.trim();
    if (privateKey.isEmpty) {
      return;
    }

    await _accountRepository.savePrivateKey(privateKey);
    var wallet = EthPrivateKey.fromHex(privateKey);
    await _session.initSession(wallet);

    if (mounted) {
      Navigator.pop(context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) {
            return const HomeScreen();
          },
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var darkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/${darkMode ? "background-flip.jpg" : "background.jpeg"}",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    Text(
                      "Decentralized Chat",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: darkMode ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      "XMTP integration that decentralizes messaging at the OS level.",
                      style: TextStyle(
                        color: darkMode ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _loginWithWallet,
                            icon: const Icon(Icons.wallet),
                            label: const Text("Connect wallet"),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _loginAsGuest,
                            icon: const Icon(Icons.person),
                            label: const Text("Guest"),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Import"),
                                    content: TextField(
                                      controller: _editingController,
                                      decoration: const InputDecoration(
                                        hintText: "Private key",
                                      ),
                                      maxLines: 6,
                                      minLines: 3,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: _importWallet,
                                        child: const Text("Import"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.download_sharp),
                            label: const Text("Import"),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
