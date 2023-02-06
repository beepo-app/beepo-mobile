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
  Future<List<Transaction>> transactionHistory(String networkId, String address) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}transaction/history'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode({"networkId": networkId, "address": address}),
      );
      if (response.statusCode == 200) {
        return transactionFromJson(jsonDecode(response.body)['data']);
      } else {
        return [];
      }
    } catch (e) {
      log(e);
      return [];
    }
  }
}
