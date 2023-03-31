import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/credentials.dart';

import '../di/injection.dart';
import '../domain/repository/account_repository.dart';
import '../domain/repository/xmtp_repository.dart';
import '../screens/login/login_screen.dart';
import '../utils/abbreviate.dart';
import 'address_avatar.dart';

class MyProfileCard extends StatefulWidget {
  const MyProfileCard({Key key, this.address}) : super(key: key);

  final EthereumAddress address;

  @override
  State<MyProfileCard> createState() => _MyProfileCardState();
}

class _MyProfileCardState extends State<MyProfileCard> {
  final AccountRepository _accountRepository = getIt();
  final XmtpRepository _xmtpRepository = getIt();

  _disconnectWallet() {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Disconnect wallet"),
          content: const Text("Are you sure you want to disconnect wallet?"),
          actions: [
            TextButton(
              onPressed: () async {
                await _accountRepository.deletePrivateKey();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const LoginScreen();
                      },
                    ),
                    (route) => false,
                  );
                }
              },
              child: Text(
                "Disconnect",
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AddressAvatar(address: widget.address),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.circle, color: Colors.green, size: 14.0),
                          SizedBox(width: 8.0),
                          Text(
                            "Connected as:",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(abbreviate(widget.address?.hexEip55 ?? "")),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    "DEV",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ListTile(
                                  title: Text("Version 1.0"),
                                  leading: Icon(Icons.info),
                                  enabled: false,
                                ),
                                const Divider(height: 1.0),
                                ListTile(
                                  title: const Text("Copy wallet address"),
                                  leading: const Icon(Icons.copy),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await Clipboard.setData(ClipboardData(
                                      text: _xmtpRepository
                                          .getMyAddress()
                                          .hexEip55,
                                    ));
                                  },
                                ),
                                const Divider(height: 1.0),
                                ListTile(
                                  title: const Text(
                                    "Disconnect wallet",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  leading: const Icon(
                                    Icons.link_off,
                                    color: Colors.redAccent,
                                  ),
                                  onTap: _disconnectWallet,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.settings),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
