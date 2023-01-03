import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Models/transaction.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

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

      final response = await http.post(
        Uri.parse('$baseUrl/transaction/send'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          // "publickey": EncryptionService().publicKey,
          // "sender_id": AuthService().contextId,
          "encrypted_seedphrase": base64SeedPhrase,
          "receiverAddress": address,
          "networkId": networkId,
          "value": num.parse(amount),
          // "gasfee": gasFee,
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
