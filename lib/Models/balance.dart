import 'dart:convert';

CoinBalance balanceModelFromJson(String str) =>
    CoinBalance.fromJson(json.decode(str));

String balanceModelToJson(CoinBalance data) => json.encode(data.toJson());

class CoinBalance {
  CoinBalance({
    required this.balance,
    required this.symbol,
    required this.status,
    required this.prices,
    required this.address,
  });

  num balance;
  String symbol;
  String status;
  List<Price> prices;
  String address;

  factory CoinBalance.fromJson(Map<String, dynamic> json) => CoinBalance(
        balance: num.parse(json["balance"].toString()),
        symbol: json["symbol"],
        status: json["status"],
        prices: json["prices"] == null
            ? []
            : List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
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
    required this.currency,
    required this.symbol,
    required this.value,
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
