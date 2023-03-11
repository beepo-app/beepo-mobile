import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Constants/app_constants.dart';
import 'package:beepo/Models/transaction.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../Constants/network.dart';

class TransactionService {
  //Estimate gasFee
  Future<String> estimateGasFee(String networkId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}transaction/estimateGasfee?networkId=$networkId'),
        headers: {'Accept': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['estimategasfee'];
      } else {
        return '';
      }
    } catch (e) {
      log(e);
      return '';
    }
  }

  //Send token
  Future<bool> sendToken(
      {String amount, String gasFee, String address, String networkId}) async {
    try {
      log(address);

      String seedPhrase = await EncryptionService().getSeedPhrase();

      String base64SeedPhrase = base64Encode(utf8.encode(seedPhrase));

      log(networkId);
      log(base64SeedPhrase);

      var body = {
        "receiverAddress": address,
        "value": num.parse(amount),
        "networkId": networkId,
        "pin": "1234",
      };

      //convert to base64
      var base64Body = base64Encode(utf8.encode(jsonEncode(body)));

      String encryptedBody = await EncryptionService().encrypt(base64Body);

      final response = await http.post(
        Uri.parse('$baseUrl/transaction/send'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          Headers.bearer: AuthService().accessToken,
        },
        body: jsonEncode({
          "encrypted_transactionData": encryptedBody,
          // "receiverAddress": address,
          // "networkId": networkId,
          // "value": num.parse(amount),
          "encrypted_seedphrase": Hive.box(kAppName).get('seedphrase'),
        }),
      );

      log(response.body);

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        showToast(data['message'].toString());
        return false;
      }
    } catch (e) {
      print(e);
      showToast('Error sending token');
      return false;
    }
  }

  //Transaction history
  Future<List<Transaction>> transactionHistory(
      String networkId, String address) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}transaction/history'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({"networkId": networkId, "address": address}),
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return transactionFromJson(sample['data']);
      } else {
        return [];
      }
    } catch (e) {
      log(e);
      return [];
    }
  }
}

Map sample = {
  "status": "success",
  "data": [
    {
      "type": "transfer",
      "from": "0x512fc8c99c6f5c1020ebd79d192e95551defec58",
      "to": "0x78139bb85e97346ca9a747cbb4b122b89602da15",
      "value": 0.01,
      "hash":
          "0xb5f30e9247e1431b27b2a84856801d723b4e90e6e74b261288022675be374e3c",
      "gasfee": 0.001943401470864,
      "timestamp": 1671072959,
      "confirmed": true,
      "networkId": 137,
      "url":
          "https://polygonscan.com/tx/0xb5f30e9247e1431b27b2a84856801d723b4e90e6e74b261288022675be374e3c"
    },
    {
      "type": "transfer",
      "from": "0x512fc8c99c6f5c1020ebd79d192e95551defec58",
      "to": "0x78139bb85e97346ca9a747cbb4b122b89602da15",
      "value": 0.01,
      "hash":
          "0x2b1a65401691032292ce685b0df7f7efd0a10e1da14c1a8344d62de13c10c685",
      "gasfee": 0.002385025212297,
      "timestamp": 1671072911,
      "confirmed": true,
      "networkId": 137,
      "url":
          "https://polygonscan.com/tx/0x2b1a65401691032292ce685b0df7f7efd0a10e1da14c1a8344d62de13c10c685"
    },
    {
      "type": "transfer",
      "from": "0x512fc8c99c6f5c1020ebd79d192e95551defec58",
      "to": "0x78139bb85e97346ca9a747cbb4b122b89602da15",
      "value": 0.01,
      "hash":
          "0x7a83854eb16af99849a39950a8cf59e7bea47f633e77c7bee561a6775f8b57ae",
      "gasfee": 0.002738336553015,
      "timestamp": 1671072875,
      "confirmed": true,
      "networkId": 137,
      "url":
          "https://polygonscan.com/tx/0x7a83854eb16af99849a39950a8cf59e7bea47f633e77c7bee561a6775f8b57ae"
    },
  ]
};
