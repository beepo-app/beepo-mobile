// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/balance.dart';
import '../../Models/market_data.dart';
import '../../Models/wallet.dart';
import '../../Utils/styles.dart';



class SendGlobal extends StatefulWidget {
  final List<Wallet> wallets;
  final List<CoinMarketData> coinMarketDataList;
  final CoinBalance btcBalance;
  final List ercBalances;
  final String selectedCurrencySymbol;
  final String selectedCurrency;
 final bool isSending;
  SendGlobal(
      {Key key,
      this.wallets,
      this.coinMarketDataList,
      this.btcBalance,
      this.ercBalances,
      this.selectedCurrencySymbol,
      this.selectedCurrency,this.isSending = true})
      : super(key: key);

  @override
  State<SendGlobal> createState() => _SendGlobalState();
}

class _SendGlobalState extends State<SendGlobal> {
  List<Wallet> wallets = [];

  @override
  void initState() {
    wallets = widget.wallets;
    super.initState();
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
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: Column(
          children: [
            Text(
              widget.isSending ? "Send Token" : "Receive Token",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "Choose an asset",
              style: TextStyle(
                color: Color(0xccffffff),
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 10),
                height: 132,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isNotEmpty) {
                      wallets = widget.wallets
                          .where((element) =>
                              element.name.toLowerCase().contains(value))
                          .toList();
                    } else {
                      wallets = widget.wallets;
                    }
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                color: Colors.white,
                child: WalletList(
                  wallets: wallets,
                  coinMarketDataList: widget.coinMarketDataList,
                  btcBalance: widget.btcBalance,
                  ercBalances: widget.ercBalances,
                  selectedCurrencySymbol: widget.selectedCurrencySymbol,
                  selectedCurrency: widget.selectedCurrency,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
