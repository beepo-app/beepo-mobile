import 'dart:convert';

CoinBalance balanceModelFromJson(String str) =>
    CoinBalance.fromJson(json.decode(str));

String balanceModelToJson(CoinBalance data) => json.encode(data.toJson());

class CoinBalance {
  CoinBalance({
    this.balance,
    this.symbol,
    this.status,
    this.prices,
    this.address,
  });

  num balance;
  String symbol;
  String status;
  List<Price> prices;
  String address;

  factory CoinBalance.fromJson(Map<String, dynamic> json) => CoinBalance(
        balance: json["balance"],
        symbol: json["symbol"],
        status: json["status"],
        prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "symbol": symbol,
        "status": status,
        "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
        "address": address,
      };
}

class Price {
  Price({
    this.currency,
    this.symbol,
    this.value,
  });

  String currency;
  String symbol;
  String value;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        currency: json["currency"],
        symbol: json["symbol"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "symbol": symbol,
        "value": value,
      };
}
