import 'package:flutter/material.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:web3dart/credentials.dart';
import 'dart:math';

class Protocol extends ChangeNotifier {
  var wallet;
  var client;

  final mySecureStorage = Random.secure();

  createClient() async{
     wallet = EthPrivateKey.createRandom(Random.secure());
     notifyListeners();
    var api = xmtp.Api.create();
     client = await xmtp.Client.createFromWallet(api, wallet);
     notifyListeners();
    // await mySecureStorage.save(client.keys.writeToBuffer());
  }

  listExistingConversation()async {
    var conversations = await client.listConversations();
    for (var convo in conversations) {
      debugPrint('Saying GM to ${convo.peer}');
      await client.sendMessage(convo, 'gm');
    }
  }

  listenForNewConversation()async{
    // var listening =
    client.streamConversations().listen((convo) {
      debugPrint('Got a new conversation with ${convo.peer}');
    });
// When you want to stop listening:
//     await listening.cancel();
  }
  startNewConversation(String walletAddress)async{
    await client.newConversation(walletAddress);
  }

  sendMessages(String walletAddress)async{
    var convo = await client.newConversation(walletAddress);
    await client.sendMessage(convo, 'gm');
  }
  //
  // listOfMessagesInAConversation()async{
  //   // Only show messages from the last 24 hours.
  //    await client.listMessages(convo,
  //       start: DateTime.now().subtract(const Duration(hours: 24)));
  // }
}
