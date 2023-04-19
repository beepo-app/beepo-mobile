import 'dart:developer';

import 'package:beepo/Models/market_data.dart';
import 'package:beepo/Screens/Wallet/receive_token.dart';
import 'package:beepo/Screens/Wallet/send_global.dart';
import 'package:beepo/Screens/Wallet/token_screen.dart';
import 'package:beepo/Service/wallets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Models/wallet.dart';
import '../../Utils/styles.dart';
import '../../components.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({Key key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: const SizedBox(),
          title: const Text(
            'Wallet',
            style: TextStyle(
                fontSize: 18,
                color: secondaryColor,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              children: const [
                // Icon(
                //   Icons.search,
                //   color: Color(0xff908f8d),
                //   size: 25,
                // ),
                // SizedBox(width: 20),
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
            WalletsService().getCoinMarketData(),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<Wallet> wallets = snapshot.data[0] ?? [];
            final List<CoinMarketData> coinMarketDataList = snapshot.data[1];

            Wallet btcWallet = wallets.firstWhere((e) => e.name == 'Bitcoin');
            Wallet ethWallet = wallets.firstWhere((e) => e.ticker == 'ETH');

            return FutureBuilder<List>(
              future: Future.wait([
                WalletsService().getWalletBalance('bitcoin', btcWallet.address),
                WalletsService().getERCWalletBalances(ethWallet.address),
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                Map btcBalance = snapshot.data[0];
                List ercBalances = snapshot.data[1];

                //Calculate total balance
                double totalBalance = 0;

                for (var balance in ercBalances) {
                  var balanceDouble =
                      num.parse(balance['USD']?.toString() ?? '0');
                  totalBalance += balanceDouble;
                }

                totalBalance += num.parse(btcBalance['USD']?.toString() ?? '0');

                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 100),
                              Text(
                                "\$" + totalBalance.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Total Balance',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryColor),
                              ),
                              const SizedBox(height: 43),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: GestureDetector(
                                      onTap: () => Get.to(
                                        SendGlobal(),
                                      ),
                                      child: Container(
                                        width: 63.0,
                                        height: 61.0,
                                        color: secondaryColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Transform.rotate(
                                                angle: 24.5,
                                                child: const Icon(
                                                  Icons.send_outlined,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ),

                                              // const SizedBox(height: 7),
                                              const Text(
                                                'Send',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: GestureDetector(
                                      onTap: () => Get.to(const ReceiveToken()),
                                      child: Container(
                                        width: 63.0,
                                        height: 61.0,
                                        color: secondaryColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: const [
                                              Icon(Icons.file_download_sharp,
                                                  size: 25,
                                                  color: Colors.white),

                                              //const SizedBox(height: 7),
                                              Text(
                                                'Receive',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: GestureDetector(
                                      onTap: () => Get.to(const WalletToken()),
                                      child: Container(
                                        width: 63.0,
                                        height: 61.0,
                                        color: secondaryColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: const [
                                              Icon(Icons.shopping_cart_outlined,
                                                  size: 25,
                                                  color: Colors.white),

                                              //const SizedBox(height: 7),
                                              Text(
                                                'Buy',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TabBar(
                          indicatorColor: secondaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2,
                          tabs: [
                            Tab(
                              child: Text(
                                "Crypto Assets",
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "NFTs",
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 380,
                        child: TabBarView(children: [
                          Container(
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
                                separatorBuilder: (_, int index) {
                                  return const SizedBox(height: 10);
                                },
                                itemBuilder: (_, int index) {
                                  Wallet wallet = wallets[index];
                                  String fiatValue = '0';
                                  CoinMarketData coinMarketData =
                                      coinMarketDataList.firstWhere(
                                          (e) =>
                                              e.id == wallet.chainId.toString(),
                                          orElse: () => null);
                                  String balance;

                                  if (wallet.ticker == 'BITCOIN') {
                                    balance = btcBalance['balance'].toString();
                                    if (btcBalance['USD'] == null) {
                                      fiatValue = "0";
                                    } else {
                                      fiatValue = btcBalance['USD'].toString();
                                    }
                                  } else {
                                    Map bal = ercBalances.firstWhere(
                                      (balance) =>
                                          balance['symbol'] == wallet.ticker,
                                      orElse: () => {'balance': "0.0"},
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
                                    coinMarketData: coinMarketData,
                                    fiatValue: fiatValue == 'null'
                                        ? '0.00'
                                        : num.parse(fiatValue ?? "0.00")
                                            .toStringAsFixed(2),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                              // color: secondaryColor,
                              ),
                        ]),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
