import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Models/balance.dart';
import 'package:beepo/Models/market_data.dart';
import 'package:beepo/Service/auth.dart';
import 'package:http/http.dart' as http;

import '../Constants/network.dart';
import '../Models/wallet.dart';
import '../Widgets/toasts.dart';

class WalletsService {
  Future<List<Wallet>> getWallets() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/wallet/coins"),
        headers: {
          'Accept': 'application/json',
          Headers.bearer: AuthService().accessToken,
          // Headers.context: AuthService().contextId,
        },
      );

      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        List<Wallet> wallets = walletFromJson(response.body);
        return wallets;
      } else {
        return [];
      }
    } catch (e) {
      print(e);

      showToast(e.toString());
      rethrow;
    }
  }

  Future<List> getERCWalletBalances(String address) async {
    try {
      print(address);
      final response = await http.post(
        Uri.parse('$baseUrl/getallbalance'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"address": address}),
      );

      // print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);

        return data['balances'];
      } else {
        return [];
      }
    } catch (e) {
      showToast(e.toString());
      rethrow;
    }
  }

  Future<CoinBalance> getWalletBalance(String networkId, String address) async {
    try {
      log(networkId);
      log(address);
      final response = await http.post(
        Uri.parse('$baseUrl/addressbalance'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"networkId": networkId, "address": address}),
      );

      print(response.body);
      log(response.statusCode.toString());

      var data = json.decode(response.body);
      CoinBalance balance = CoinBalance.fromJson(data);
      return balance;
    } catch (e) {
      print(e);
      showToast(e.toString());
      rethrow;
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
      rethrow;
    }
  }

  //get coin market data
  Future<List<CoinMarketData>> getCoinMarketData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/marketdata'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body)['data'];
        return data.map((e) => CoinMarketData.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      showToast(e.toString());
      return [];
    }
  }
}
