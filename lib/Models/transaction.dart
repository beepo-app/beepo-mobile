// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

List<Transaction> transactionFromJson(List transactions) =>
    List<Transaction>.from(transactions.map((x) => Transaction.fromJson(x)));

String transactionToJson(List<Transaction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaction {
  Transaction({
    required this.type,
    required this.from,
    required this.to,
    required this.value,
    required this.hash,
    required this.gasfee,
    required this.timestamp,
    required this.confirmed,
    required this.networkId,
    required this.url,
  });

  String type;
  String from;
  String to;
  double value;
  String hash;
  double gasfee;
  int timestamp;
  bool confirmed;
  int networkId;
  String url;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        type: json["type"],
        from: json["from"],
        to: json["to"] ?? '',
        value: json["value"].toDouble(),
        hash: json["hash"],
        gasfee: json["gasfee"].toDouble(),
        timestamp: json["timestamp"],
        confirmed: json["confirmed"],
        networkId: json["networkId"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "from": from,
        "to": to,
        "value": value,
        "hash": hash,
        "gasfee": gasfee,
        "timestamp": timestamp,
        "confirmed": confirmed,
        "networkId": networkId,
        "url": url,
      };
}
