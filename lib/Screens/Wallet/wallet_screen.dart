import 'dart:developer';

import 'package:beepo/Service/auth.dart';
import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Service/wallets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/wallet.dart';
import '../../Utils/styles.dart';
import '../../components.dart';
import '../send_global.dart';
import 'receive_token.dart';
import 'token_screen.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({Key key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: const SizedBox(),
        title: const Text(
          'Wallet',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: const [
              Icon(
                Icons.search,
                color: Color(0xff908f8d),
                size: 25,
              ),
              SizedBox(width: 20),
              Icon(
                Icons.more_vert_outlined,
                color: Color(0xff908f8d),
                size: 25,
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          WalletsService().getWallets(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Wallet> wallets = snapshot.data[0] ?? [];

          Wallet btcWallet = wallets.firstWhere((e) => e.name == 'Bitcoin');
          Wallet ethWallet = wallets.firstWhere((e) => e.ticker == 'ETH');
          // Wallet solWallet = wallets.firstWhere((e) => e.ticker == 'SOL');
          Wallet bnbWallet = wallets.firstWhere((e) => e.ticker == 'BNB');

          return FutureBuilder<List>(
            future: Future.wait([
              WalletsService().getWalletBalance('bitcoin', btcWallet.address),
              // WalletsService().getWalletBalance('solana', solWallet.address),
              WalletsService().getWalletBalance('56', bnbWallet.address),
              WalletsService().getERCWalletBalances(ethWallet.address),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              Map btcBalance = snapshot.data[0];
              // Map solBalance = snapshot.data[1];
              Map bnbBalance = snapshot.data[1];
              List ercBalances = snapshot.data[2];

              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: secondaryColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 100),
                            const Text(
                              'Total Balance',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 11),
                            Text(
                              // totalBalance.toString(),
                              '',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            // const SizedBox(height: 43),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     const SizedBox(),
                            //     Column(
                            //       children: [
                            //         Transform.rotate(
                            //           angle: 24.5,
                            //           child: IconButton(
                            //             onPressed: () => Get.to(
                            //               SendGlobal(),
                            //             ),
                            //             icon: const Icon(
                            //               Icons.send_outlined,
                            //               size: 30,
                            //               color: Colors.white,
                            //             ),
                            //           ),
                            //         ),
                            //         const SizedBox(height: 7),
                            //         const Text(
                            //           'Send',
                            //           style: TextStyle(
                            //               fontSize: 18,
                            //               fontWeight: FontWeight.bold,
                            //               color: Colors.white),
                            //         ),
                            //       ],
                            //     ),
                            //     Column(
                            //       children: [
                            //         IconButton(
                            //           onPressed: () => Get.to(ReceiveToken()),
                            //           icon: const Icon(Icons.file_download_sharp,
                            //               size: 30, color: Colors.white),
                            //         ),
                            //         const SizedBox(height: 7),
                            //         const Text(
                            //           'Receive',
                            //           style: TextStyle(
                            //               fontSize: 18,
                            //               fontWeight: FontWeight.bold,
                            //               color: Colors.white),
                            //         ),
                            //       ],
                            //     ),
                            //     Column(
                            //       children: [
                            //         IconButton(
                            //           onPressed: () => Get.to(const WalletToken()),
                            //           icon: const Icon(Icons.shopping_cart_outlined,
                            //               size: 30, color: Colors.white),
                            //         ),
                            //         const SizedBox(height: 7),
                            //         const Text(
                            //           'Buy',
                            //           style: TextStyle(
                            //               fontSize: 18,
                            //               fontWeight: FontWeight.bold,
                            //               color: Colors.white),
                            //         ),
                            //       ],
                            //     ),
                            //     const SizedBox(),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        color: Colors.white,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {});
                          },
                          child: ListView.separated(
                            itemCount: wallets.length,
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              Wallet wallet = wallets[index];
                              String fiatValue = '0';

                              String balance;

                              if (wallet.ticker == 'BITCOIN') {
                                balance = btcBalance['balance'];
                                if (btcBalance['USD'] == null) {
                                  fiatValue = "0";
                                } else {
                                  fiatValue = btcBalance['USD'].toString();
                                }
                              } else if (wallet.ticker == 'BNB') {
                                balance = bnbBalance['balance'].toString();
                                fiatValue = bnbBalance['USD'].toString();
                              } else {
                                Map bal = ercBalances.firstWhere(
                                  (balance) => balance['symbol'] == wallet.ticker,
                                  orElse: () => {'balance': 0.0},
                                );
                                balance = bal['balance'].toString();

                                fiatValue = bal['USD'].toString();
                              }

                              return WalletListTile(
                                image: wallet.logoUrl,
                                title: wallet.displayName,
                                subtext: wallet.ticker,
                                amount: balance ?? 'N/A',
                                wallet: wallet,
                                fiatValue: double.parse(fiatValue).toStringAsFixed(2),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
