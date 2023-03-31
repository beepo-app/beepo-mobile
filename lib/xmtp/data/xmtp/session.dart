import 'dart:developer';

import 'package:web3dart/credentials.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

import '../local/messages_store.dart';

class Session {
   xmtp.Client _client;

  xmtp.Client get client => _client;

  Future<xmtp.Client> initSession(Credentials wallet) async {
    var api = xmtp.Api.create(host: "dev.xmtp.network", isSecure: true);
    _client = await xmtp.Client.createFromWallet(api, wallet);
    log("Client: ${_client.address.hexEip55}");

    _listenForNewConversations();

    return _client;
  }

  _listenForNewConversations() async {
    var existingConversations = await client.listConversations();
    store.setConversations(existingConversations);

    _client.streamConversations().listen((newConversation) {
      store.addConversation(newConversation);
    });
  }
}
