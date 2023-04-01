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
    this.id,
    this.owner,
    this.ticker,
    this.description,
    this.chainId,
    this.name,
    this.displayName,
    this.isTestnet,
    this.derivationPath,
    this.logoUrl,
    this.transactionCount,
    this.publicKey,
    this.address,
    this.v,
  });

  String id;
  String owner;
  String ticker;
  String description;
  int chainId;
  String name;
  String displayName;
  bool isTestnet;
  String derivationPath;
  String logoUrl;
  int transactionCount;
  String publicKey;
  String address;
  int v;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["_id"],
        owner: json["owner"],
        ticker: json["ticker"],
        description: json["description"],
        chainId: json["chainId"],
        name: json["name"],
        displayName: json["displayName"],
        isTestnet: json["isTestnet"],
        derivationPath: json["derivationPath"],
        logoUrl: json["logoUrl"],
        transactionCount: json["transactionCount"],
        publicKey: json["publicKey"],
        address: json["address"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "owner": owner,
        "ticker": ticker,
        "description": description,
        "chainId": chainId,
        "name": name,
        "displayName": displayName,
        "isTestnet": isTestnet,
        "derivationPath": derivationPath,
        "logoUrl": logoUrl,
        "transactionCount": transactionCount,
        "publicKey": publicKey,
        "address": address,
        "__v": v,
      };
}
