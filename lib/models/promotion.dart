// To parse this JSON data, do
//
//     final promotion = promotionFromJson(jsonString);

import 'dart:convert';

Map<String, Promotion> promotionFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Promotion>(k, Promotion.fromJson(v)));

String promotionToJson(Map<String, Promotion> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Promotion {
    String text;

    Promotion({
        required this.text,
    });

    factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}
