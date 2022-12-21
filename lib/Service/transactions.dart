import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Service/auth.dart';
import 'package:http/http.dart' as http;

import '../Constants/network.dart';

class TransactionService {
  //Estimate gasfee
  Future<String> estimateGasfee(String networkId) async {
    try {
      print(networkId);
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
  Future<void> sendToken(
      {String amount, String gasfee, String address, String networkId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transaction/send'),
        headers: {'Accept': 'application/json'},
        body: {
          "publickey": "",
          "encrypted_seedphrase": "",
          "sender_id": AuthService().userID,
          "receiverAddress": address,
          "value": 100,
          "gasfee": gasfee,
          "networkId": networkId,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
  }
}
