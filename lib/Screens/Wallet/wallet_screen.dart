import 'dart:developer';

import 'package:beepo/Models/balance.dart';
import 'package:beepo/Models/market_data.dart';
import 'package:beepo/Screens/Wallet/send_global.dart';
import 'package:beepo/Service/wallets.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/wallet.dart';
import '../../Utils/styles.dart';
import '../../components.dart';
import '../requestToken.dart';
import 'send_global.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({Key key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final Future<List> _getWallets = WalletsService().getWallets();
  List<Map> currencies = [];
  String selectedCurrency = 'usd';
  String selectedCurrencySymbol = '\$';
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
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Currency - ' + selectedCurrency.toUpperCase()),
                  value: 1,
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
                  Get.bottomSheet(
                    Container(
                      height: 300,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Select Currency',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: currencies.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCurrency =
                                            currencies[index]['currency'];
                                        selectedCurrencySymbol =
                                            currencies[index]['symbol'];
                                      });
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          currencies[index]['currency']
                                                  .toUpperCase() +
                                              ' - ' +
                                              currencies[index]['symbol'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: Future.wait([
            _getWallets, //runs only once
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
                  return loader();
                }

                CoinBalance btcBalance = snapshot.data[0];
                List ercBalances = snapshot.data[1];

                //Get all currencies
                List<Map> availableCurrencies = [];

                for (var balance in btcBalance.prices) {
                  availableCurrencies.add({
                    'currency': balance.currency,
                    'symbol': balance.symbol,
                  });
                }

                currencies = availableCurrencies;

                //Calculate total balance
                double totalBalance = 0;

                //add erc balances
                try{
                for (var balance in ercBalances) {
                  //get balance in selected currency
                  var balanceDouble = double.parse(balance['prices'].firstWhere(
                          (e) => e['currency'] == selectedCurrency)['value'] ??
                      '0');
                  totalBalance += balanceDouble;
                }}catch(e){
                  print(e);
                }

                //add btc balance
                totalBalance += double.parse(btcBalance.prices
                        .firstWhere((e) => e.currency == selectedCurrency)
                        .value ??
                    '0.00');

                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
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
                              selectedCurrencySymbol +
                                  totalBalance.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 11),
                            const Text(
                              'Total Balance',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                WalletIcon(
                                  text: 'Send',
                                  icon: Icons.send_outlined,
                                  angle: 5.7,
                                  onTap: () {
                                    Get.to(SendGlobal(
                                      wallets: wallets,
                                      coinMarketDataList: coinMarketDataList,
                                      btcBalance: btcBalance,
                                      ercBalances: ercBalances,
                                      selectedCurrency: selectedCurrency,
                                      selectedCurrencySymbol:
                                          selectedCurrencySymbol,
                                    ));
                                  },
                                ),
                                WalletIcon(
                                  text: 'Receive',
                                  icon: Icons.file_download_sharp,
                                  onTap: () {
                                    Get.to(SendGlobal(
                                      wallets: wallets,
                                      coinMarketDataList: coinMarketDataList,
                                      btcBalance: btcBalance,
                                      ercBalances: ercBalances,
                                      selectedCurrency: selectedCurrency,
                                      selectedCurrencySymbol:
                                          selectedCurrencySymbol,
                                      isSending: false,
                                    ));
                                  },
                                ),
                                WalletIcon(
                                  text: 'Buy',
                                  icon: Icons.shopping_cart_outlined,
                                  onTap: () {
                                    showToast('Coming soon');
                                  },
                                ),
                                const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(17.0),
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
                        height: MediaQuery.of(context).size.height *0.52,
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
                              child: WalletList(
                                wallets: wallets,
                                coinMarketDataList: coinMarketDataList,
                                btcBalance: btcBalance,
                                ercBalances: ercBalances,
                                selectedCurrency: selectedCurrency,
                                selectedCurrencySymbol: selectedCurrencySymbol,
                              ),
                            ),
                          ),
                          Container(
                              // color: secondaryColor,
                              )
                        ]),
                      )
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

class WalletList extends StatelessWidget {
  final List<Wallet> wallets;
  final List<CoinMarketData> coinMarketDataList;
  final CoinBalance btcBalance;
  final List ercBalances;
  final String selectedCurrencySymbol;
  final String selectedCurrency;

  const WalletList({
    Key key,
    @required this.wallets,
    @required this.coinMarketDataList,
    @required this.btcBalance,
    @required this.ercBalances,
    @required this.selectedCurrencySymbol,
    @required this.selectedCurrency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
        CoinMarketData coinMarketData = coinMarketDataList.firstWhere(
            (e) => e.id == wallet.chainId.toString(),
            orElse: () => null);
        String balance;

        if (wallet.ticker == 'BITCOIN') {
          balance = btcBalance.balance.toString();
          fiatValue = btcBalance.prices
              .firstWhere((e) => e.currency == selectedCurrency)
              .value;
        } else {
          Map coinBalance = ercBalances.firstWhere(
            (balance) => balance['symbol'] == wallet.ticker.toUpperCase(),
            orElse: () => {
              'balance': "0.0",
              'symbol': wallet.ticker,
            },
          );
          balance = coinBalance['balance'].toString();

          fiatValue = coinBalance['prices']
              .firstWhere((e) => e['currency'] == selectedCurrency, )['value'];
        }

        return WalletListTile(
          image: wallet.logoUrl,
          title: wallet.displayName,
          subtext: wallet.ticker,
          amount: balance ?? 'N/A',
          wallet: wallet,
          coinMarketData: coinMarketData,
          fiatSymbol: selectedCurrencySymbol,
          fiatValue: fiatValue == 'null'
              ? '0.00'
              : num.parse(fiatValue ?? "0.00").toStringAsFixed(2),
        );
      },
    );
  }
}

class WalletIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final double angle;
  const WalletIcon({
    Key key,
    this.text,
    this.icon,
    this.onTap,
    this.angle = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 80,
              height: 80,
              // alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20,),
              color: secondaryColor,
              child: Column(
                children: [
                  Transform.rotate(
                    angle: angle,
                    child: Icon(icon, size: MediaQuery.of(context).size.width *0.05, color: Colors.white),
                  ),
                  // const SizedBox(height: 7),
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
