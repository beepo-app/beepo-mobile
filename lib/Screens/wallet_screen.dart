import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components.dart';
import 'send_global.dart';
import 'receive_token.dart';
import 'wallet_tokens_screen.dart';

class Wallet extends StatefulWidget {
  Wallet({Key key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              const Icon(
                Icons.search,
                color: Color(0xff908f8d),
                size: 25,
              ),
              const SizedBox(width: 20),
              const Icon(
                Icons.more_vert_outlined,
                color: Color(0xff908f8d),
                size: 25,
              ),
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Color(0xff0e014c),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 11),
                    const Text(
                      '\$15,678.13',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 43),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Column(
                          children: [
                            Transform.rotate(
                              angle: 24.5,
                              child: IconButton(
                                  onPressed: () => Get.to(SendGlobal()),
                                  icon: const Icon(
                                    Icons.send_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Send',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => Get.to(ReceiveToken()),
                              icon: const Icon(Icons.file_download_sharp,
                                  size: 30, color: Colors.white),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Receive',
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
                              onPressed: () => Get.to(WalletToken()),
                              icon: const Icon(Icons.shopping_cart_outlined,
                                  size: 30, color: Colors.white),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Buy',
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
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Crypto Assets',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      WalletListTile(
                        image: 'assets/bCoin.png',
                        title: 'Bitcoin',
                        subtext: 'BTC',
                        amount: '0.0234789',
                      ),
                      const SizedBox(height: 20),
                      WalletListTile(
                        image: 'assets/BTCoin.png',
                        title: 'Binance Token',
                        subtext: 'BNB',
                        amount: '6.0483920',
                      ),
                      const SizedBox(height: 20),
                      WalletListTile(
                        image: 'assets/ETH.png',
                        title: 'Etherium',
                        subtext: 'ETH',
                        amount: '6.0483920',
                      ),
                      const SizedBox(height: 20),
                      WalletListTile(
                        image: 'assets/Celo.png',
                        title: 'Celo',
                        subtext: 'Celo',
                        amount: '20.234789',
                      ),
                      const SizedBox(height: 20),
                      WalletListTile(
                        image: 'assets/BTC.png',
                        title: 'Celo Dollar',
                        subtext: 'CUSD',
                        amount: '20.234789',
                      ),
                      const SizedBox(height: 20),
                      WalletListTile(
                        image: 'assets/volt.png',
                        title: 'Volt Token',
                        subtext: 'VOLT',
                        amount: '0.0234789',
                      ),
                      const SizedBox(height: 20),
                      WalletListTile(
                        image: 'assets/usdt.png',
                        title: 'USDT Token',
                        subtext: 'USDT',
                        amount: '0.0234789',
                      ),
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
