import 'dart:developer';
import 'dart:typed_data';
import 'package:beepo/Constants/app_constants.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:web3dart/credentials.dart';
import 'dart:developer' as dev;
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
// import 'package:ethereum/ethereum.dart';

class XMTPProvider extends ChangeNotifier {
  XMTPProvider() {
    getClient();
  }

  final String _conversationId = 'chat';
  final Box _box = Hive.box(kAppName);

  xmtp.Client client;
  List<xmtp.Conversation> _conversations = [];
  bool _isLoadingConversations = false;

  // Getter for conversations
  List<xmtp.Conversation> get conversations => _conversations;

  // Getter for isLoadingConversations
  bool get isLoadingConversations => _isLoadingConversations;

  //get client and notify listeners
  Future<xmtp.Client> getClient() async {
    var key = _box.get('xmpt_key');
    bool isLoggedIn = _box.get('isLogged', defaultValue: false);

    if (isLoggedIn) {
      if (key != null) {
        client = await initClientFromKey();
        notifyListeners();
        // return client;
        print('from key client');
      } else {
        client = await initClient();
        notifyListeners();
        // return client;
        print('new client');
      }
    }
    return client;
  }

  //get privatekey
  Future<xmtp.Client> initClient() async {
    try {
      // Generate the seed from the seed phrase
      String phrase = await AuthService().retrievePassphrase();
      log("phrase $phrase");

      if (phrase.isNotEmpty) {
        final seed = bip39.mnemonicToSeed(phrase);
        final root = bip32.BIP32.fromSeed(seed);

        final firstChild = root.derivePath("m/44'/60'/0'/0/0");
        final privateKeyHex = hex.encode(firstChild.privateKey);

        EthPrivateKey credentials = EthPrivateKey.fromHex(privateKeyHex);

        var api = xmtp.Api.create(host: 'production.xmtp.network');
        var client =
            await xmtp.Client.createFromWallet(api, credentials.asSigner());

        Uint8List key = client.keys.writeToBuffer();

        Hive.box(kAppName).put('xmpt_key', key);
        // notifyListeners();
        return client;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //init client from key
  Future<xmtp.Client> initClientFromKey() async {
    Uint8List key = Hive.box(kAppName).get('xmpt_key');

    var privateKey = xmtp.PrivateKeyBundle.fromBuffer(key);

    var api = xmtp.Api.create(host: 'production.xmtp.network');
    var client = await xmtp.Client.createFromKeys(api, privateKey);

    print(client.address);
    return client;
  }

  //list conversations stream
  Stream<xmtp.DecodedMessage> streamMessages({xmtp.Conversation convo}) {
    return client.streamMessages(convo);
  }

  //send message
  void sendMessage({xmtp.Conversation convo, String content}) async {
    try {
      await client.sendMessage(convo, content);

      print('msg sent');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Method to fetch conversations
  Future<void> fetchConversations() async {
    _isLoadingConversations = true;
    notifyListeners();

    _conversations = await listConversations();

    _isLoadingConversations = false;
    notifyListeners();
  }

  //list conversations
  Future<List<xmtp.Conversation>> listConversations() async {
    try {
      client ??= await getClient();
      var convos = await client.listConversations();
      return convos;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //list messages
  Future<List<xmtp.DecodedMessage>> listMessages(
      {xmtp.Conversation convo}) async {
    try {
      var msgs = await client.listMessages(convo);
      return msgs;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //create new conversation
  Future<xmtp.Conversation> newConversation(String address,
      {Map<String, String> metadata}) async {
    try {
      var convo = await client.newConversation(
        address,
        conversationId: _conversationId,
        metadata: metadata,
      );
      notifyListeners();
      return convo;
    } catch (e) {
      showToast('User is not on XMTP network');
      dev.log(e.toString());
      return null;
    }
  }

  //check if can chat
  Future<bool> checkAddress(String address) async {
    try {
      return await client.canMessage(address);
    } catch (e) {
      return false;
    }
  }

  Future<List<xmtp.DecodedMessage>> mostRecentMessage(
      {List<xmtp.Conversation> convo}) async {
    try {
      var msg = await client.listBatchMessages(convo, limit: 1);

      return msg;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
