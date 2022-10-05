import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Service/auth.dart';
import 'package:hive/hive.dart';

import '../Constants/network.dart';
import '../Models/wallet.dart';
import 'package:http/http.dart' as http;

import '../Widgets/toasts.dart';

class WalletsService {
  Future<List<Wallet>> getWallets() async {
    try {
      print(AuthService().token);

      final response = await http.get(
        Uri.parse('$baseUrl/wallets/coins'),
        headers: {
          // 'Accept': 'application/json',
          Headers.bearer: AuthService().token,
          Headers.context: AuthService().contextId,
        },
      );

      log(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Wallet> wallets = walletFromJson(response.body);
        return wallets;
      } else {
        String pwd = Hive.box('beepo').get('password');
        print(pwd);
        // AuthService().login(pwd);
        // return [];
      }
    } catch (e) {
      print(e);

      showToast(e.toString());
      return null;
    }
  }

  Future<List> getWalletBalances() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallets/balances'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService().token}'
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        String pwd = Hive.box('beepo').get('password');
        print(pwd);
        // AuthService().login(pwd);
        return [];
      }
    } catch (e) {
      print(e);

      showToast(e.toString());
      return null;
    }
  }

  Future<Map> getWalletCoinData() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/exchange-and-conversion/coin-data'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService().token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "coinIds": [
            "bitcoin",
            "celo",
            "litecoin",
            "ethereum",
            // "ropsten",
            // "binance_testnet",
          ],
          "outputFiatCurrencies": ["NGN", "USD"]
        }),
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['coins'];
      } else {
        return {};
      }
    } catch (e) {
      print(e);

      showToast(e.toString());
      return null;
    }
  }
}
