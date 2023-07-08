// ignore_for_file: prefer_const_constructors

import 'package:beepo/Models/market_data.dart';
import 'package:beepo/Models/transaction.dart';
import 'package:beepo/Screens/Wallet/transaction_details.dart';
import 'package:beepo/Service/transactions.dart';
import 'package:beepo/Utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Models/wallet.dart';
import '../../Utils/styles.dart';
import 'receive_token.dart';
import 'send_token.dart';

class WalletToken extends StatefulWidget {
  final Wallet? wallet;
  final String? balance;
  final String? value;
  final CoinMarketData? coinMarketData;
  const WalletToken(
      {Key? key, this.wallet, this.balance, this.value, this.coinMarketData})
      : super(key: key);

  @override
  State<WalletToken> createState() => _WalletTokenState();
}

class _WalletTokenState extends State<WalletToken> {
  String? currentMarketPrice;
  String? change24h;
  bool? isPositive;
  @override
  void initState() {
    super.initState();
    currentMarketPrice = widget.coinMarketData?.data.currentPrice ?? '0';
    change24h = widget.coinMarketData?.data.priceChangePercentage24H ?? '0';
    isPositive = change24h!.startsWith('-') ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '\$$currentMarketPrice',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  (isPositive! ? '+' : '') + '$change24h%',
                  style: TextStyle(
                    color: isPositive! ? Colors.green : Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: secondaryColor,
              ),
              child: Column(children: [
                const SizedBox(height: 75),
                CircleAvatar(
                  radius: 28,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.wallet!.logoUrl,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.balance! + " " + widget.wallet!.ticker,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$" + widget.value!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Column(
                      children: [
                        Transform.rotate(
                          angle: 24.5,
                          child: IconButton(
                              onPressed: () => Get.to(SendToken(
                                    wallet: widget.wallet!,
                                    balance: widget.value!,
                                  )),
                              icon: const Icon(
                                Icons.send_outlined,
                                size: 25,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Send',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => Get.to(ReceiveToken(
                            wallet: widget.wallet!,
                          )),
                          icon: const Icon(Icons.file_download_sharp,
                              size: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Receive',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(),
                  ],
                ),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text(
              "Your address",
              style: TextStyle(
                color: secondaryColor,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              widget.wallet!.address,
              style: const TextStyle(
                color: Color(0x7f0e014c),
                fontSize: 12,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.wallet!.address));
                Get.snackbar(
                  'Copied to clipboard',
                  'Address copied to clipboard',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              icon: const Icon(
                Icons.copy_outlined,
                size: 30,
                color: secondaryColor,
              ),
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
          ),
          FutureBuilder<List<Transaction>>(
            future: TransactionService().transactionHistory(
              widget.wallet!.chainId.toString(),
              widget.wallet!.address.toLowerCase(),
            ),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Expanded(
                    child: Center(child: Text(snapshot.error.toString())));
              }
              if (!snapshot.hasData) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }

              return Expanded(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: snapshot.data!.isEmpty
                        ? const Center(child: Text("No Transactions yet"))
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (ctx, i) {
                              final transaction = snapshot.data![i];
                              bool isSent = transaction.type == 'transfer';
                              return ListTile(
                                minLeadingWidth: 10,
                                leading: Icon(
                                  isSent
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 20,
                                  color: isSent ? Colors.red : Colors.green,
                                ),
                                onTap: () {
                                  Get.to(TransactionDetails(
                                    transaction: transaction,
                                    walletTicker: widget.wallet!.ticker,
                                  ));
                                },
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        transaction.type.capitalizeFirst!,
                                        style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      (isSent ? '-' : '+') +
                                          "${transaction.value.toPrecision(5)} ${widget.wallet!.ticker}",
                                      style: TextStyle(
                                        color:
                                            isSent ? Colors.red : Colors.green,
                                        fontSize: 13,
                                      ),
                                    )
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        isSent
                                            ? "To: ${transaction.to}"
                                            : "From: ${transaction.from}",
                                        style: TextStyle(
                                          color: Color(0x7f0e014c),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      formatDate(
                                          DateTime.fromMillisecondsSinceEpoch(
                                        transaction.timestamp * 1000,
                                      )),
                                      style: TextStyle(
                                        color: Color(0x7f0e014c),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
