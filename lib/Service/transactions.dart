import 'package:http/http.dart' as http;

import '../Constants/network.dart';

class TransactionService {
  //Send token
  Future<void> sendToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transaction/send'),
        headers: {'Accept': 'application/json'},
        body: {
          "publickey": "",
          "sender_id": "636b941bb9173386c612991c",
          "receiverAddress": "0xcF11f1a209dDD056A834384D30229357d33403F2",
          "value": 100,
          "gasfee": "21000",
          "networkId": "1",
          "encrypted_seedphrase": "",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
  }
}
