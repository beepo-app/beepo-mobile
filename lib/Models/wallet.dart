// To parse this JSON data, do
//
//     final wallet = walletFromJson(jsonString);

import 'dart:convert';

List<Wallet> walletFromJson(String str) =>
    List<Wallet>.from(json.decode(str).map((x) => Wallet.fromJson(x)));

String walletToJson(List<Wallet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wallet {
  Wallet({
    this.uid,
    this.coinName,
    this.coinTicker,
    this.coinDescription,
    this.coinLogoUrl,
    this.networkName,
    this.networkDisplayName,
    this.derivationPath,
    this.created,
    this.lastUpdated,
    this.networkId,
    this.ownerId,
    this.address,
    this.isTestnet,
  });

  String uid;
  String coinName;
  String coinTicker;
  String coinDescription;
  dynamic coinLogoUrl;
  String networkName;
  String networkDisplayName;
  String derivationPath;
  double created;
  double lastUpdated;
  int networkId;
  String ownerId;
  String address;
  bool isTestnet;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        uid: json["uid"],
        coinName: json["coinName"],
        coinTicker: json["coinTicker"],
        coinDescription: json["coinDescription"],
        coinLogoUrl: json["coinLogoUrl"],
        networkName: json["networkName"],
        networkDisplayName: json["networkDisplayName"],
        derivationPath: json["derivationPath"],
        created: json["created"].toDouble(),
        lastUpdated: json["lastUpdated"].toDouble(),
        networkId: json["networkId"] == null ? null : json["networkId"],
        ownerId: json["ownerId"],
        address: json["address"],
        isTestnet: json["is_testnet"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "coinName": coinName,
        "coinTicker": coinTicker,
        "coinDescription": coinDescription,
        "coinLogoUrl": coinLogoUrl,
        "networkName": networkName,
        "networkDisplayName": networkDisplayName,
        "derivationPath": derivationPath,
        "created": created,
        "lastUpdated": lastUpdated,
        "networkId": networkId == null ? null : networkId,
        "ownerId": ownerId,
        "address": address,
        "is_testnet": isTestnet,
      };
}
