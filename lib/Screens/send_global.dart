// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';
import '../components.dart';
import 'Wallet/send_token.dart';

class SendGlobal extends StatefulWidget {
  final List wallets;
  final List balances;
  SendGlobal({Key key, this.wallets, this.balances}) : super(key: key);

  @override
  State<SendGlobal> createState() => _SendGlobalState();
}

class _SendGlobalState extends State<SendGlobal> {
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
              "Send Token",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "Choose and asset",
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WalletListTile(
                        image: 'assets/bCoin.png',
                        title: 'Bitcoin',
                        subtext: 'BTC',
                        amount: '0.0234789',
                      ),
                      // SizedBox(height: 20),
                      // WalletListTile(
                      //   image: 'assets/BTCoin.png',
                      //   title: 'Binance Token',
                      //   subtext: 'BNB',
                      //   amount: '6.0483920',
                      // ),
                      // SizedBox(height: 20),
                      // WalletListTile(
                      //   image: 'assets/ETH.png',
                      //   title: 'Etherium',
                      //   subtext: 'ETH',
                      //   amount: '6.0483920',
                      // ),
                      // SizedBox(height: 20),
                      // WalletListTile(
                      //   image: 'assets/Celo.png',
                      //   title: 'Celo',
                      //   subtext: 'Celo',
                      //   amount: '20.234789',
                      // ),
                      // SizedBox(height: 20),
                      // WalletListTile(
                      //   image: 'assets/BTC.png',
                      //   title: 'Celo Dollar',
                      //   subtext: 'CUSD',
                      //   amount: '20.234789',
                      // ),
                      // SizedBox(height: 20),
                      // WalletListTile(
                      //   image: 'assets/volt.png',
                      //   title: 'Volt Token',
                      //   subtext: 'VOLT',
                      //   amount: '0.0234789',
                      // ),
                      // SizedBox(height: 24),
                      // WalletListTile(
                      //   image: 'assets/usdt.png',
                      //   title: 'USDT Token',
                      //   subtext: 'USDT',
                      //   amount: '0.0234789',
                      // ),
                      // SizedBox(height: 20),
                      // WalletListTile(
                      //   image: 'assets/BTCoin.png',
                      //   title: 'Binance Token',
                      //   subtext: 'BNB',
                      //   amount: '6.0483920',
                      // ),
                      // SizedBox(height: 20),
                      // WalletListTile(
                      //   image: 'assets/ETH.png',
                      //   title: 'Etherium',
                      //   subtext: 'ETH',
                      //   amount: '6.0483920',
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
