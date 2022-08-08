import 'dart:convert';

import 'package:beepo/Service/auth.dart';
import 'package:hive/hive.dart';

import '../Models/wallet.dart';
import '../Utils/constants.dart';
import 'package:http/http.dart' as http;

import '../Widgets/toasts.dart';

class WalletsService {
  Future<List<Wallet>> getWallets() async {
    try {
      print(AuthService().token);

      final response = await http.get(
        Uri.parse('$baseUrl/wallets'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService().token}'
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Wallet> wallets = walletFromJson(response.body);
        return wallets;
      } else {
        String pwd = Hive.box('beepo').get('password');
        print(pwd);
        AuthService().login(pwd);
        return [];
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
        AuthService().login(pwd);
        return [];
      }
    } catch (e) {
      print(e);

      showToast(e.toString());
      return null;
    }
  }
}
