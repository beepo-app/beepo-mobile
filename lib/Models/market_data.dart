// To parse this JSON data, do
//
//     final coinMarketData = coinMarketDataFromJson(jsonString);

import 'dart:convert';

class CoinMarketData {
  CoinMarketData({
    required this.id,
    required this.data,
  });

  String id;
  Data data;

  factory CoinMarketData.fromRawJson(String str) =>
      CoinMarketData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CoinMarketData.fromJson(Map<String, dynamic> json) => CoinMarketData(
        id: json["id"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.marketCap,
    required this.currentPrice,
    required this.volume,
    required this.priceChangePercentage24H,
    required this.priceChangePercentage7D,
    required this.priceChangePercentage14D,
    required this.priceChangePercentage30D,
    required this.priceChangePercentage60D,
    required this.priceChangePercentage200D,
    required this.priceChangePercentage1Y,
    required this.circulatingSupply,
    required this.totalSupply,
  });

  String marketCap;
  String currentPrice;
  String volume;
  String priceChangePercentage24H;
  String priceChangePercentage7D;
  String priceChangePercentage14D;
  String priceChangePercentage30D;
  String priceChangePercentage60D;
  String priceChangePercentage200D;
  String priceChangePercentage1Y;
  String circulatingSupply;
  String totalSupply;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        marketCap: json["market_cap"],
        currentPrice: json["current_price"],
        volume: json["volume"],
        priceChangePercentage24H: json["price_change_percentage_24h"],
        priceChangePercentage7D: json["price_change_percentage_7d"],
        priceChangePercentage14D: json["price_change_percentage_14d"],
        priceChangePercentage30D: json["price_change_percentage_30d"],
        priceChangePercentage60D: json["price_change_percentage_60d"],
        priceChangePercentage200D: json["price_change_percentage_200d"],
        priceChangePercentage1Y: json["price_change_percentage_1y"],
        circulatingSupply: json["circulating_supply"],
        totalSupply: json["total_supply"],
      );

  Map<String, dynamic> toJson() => {
        "market_cap": marketCap,
        "current_price": currentPrice,
        "volume": volume,
        "price_change_percentage_24h": priceChangePercentage24H,
        "price_change_percentage_7d": priceChangePercentage7D,
        "price_change_percentage_14d": priceChangePercentage14D,
        "price_change_percentage_30d": priceChangePercentage30D,
        "price_change_percentage_60d": priceChangePercentage60D,
        "price_change_percentage_200d": priceChangePercentage200D,
        "price_change_percentage_1y": priceChangePercentage1Y,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
      };
}
