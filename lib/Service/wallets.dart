import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Service/auth.dart';
import 'package:hive/hive.dart';

import '../Constants/network.dart';
import '../Models/wallet.dart';
import 'package:http/http.dart' as http;

import '../Widgets/toasts.dart';

class WalletsService {
  Future<List> getWallets() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/wallet/coins"),
        headers: {
          'Accept': 'application/json',
          Headers.bearer: AuthService().accessToken,
          Headers.context: AuthService().contextId,
        },
      );

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

  Future<List> getERCWalletBalances(String address) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getallbalance'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"address": address}),
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['balances'];
      } else {
        // String pwd = Hive.box('beepo').get('password');
        // print(pwd);
        // AuthService().login(pwd);
        return [];
      }
    } catch (e) {
      print(e);

      showToast(e.toString());
      return null;
    }
  }

  Future<Map> getWalletBalance(String networkId, String address) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addressbalance'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"networkId": networkId, "address": address}),
      );

      log(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      print(e);

      showToast(e.toString());
      return {};
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
