// To parse this JSON data, do
//
//     final userApp = stripeKeyFromJson(jsonString);

import 'dart:convert';

StripeKey stripeKeyFromJson(String str) => StripeKey.fromJson(json.decode(str));

String stripeKeyToJson(StripeKey data) => json.encode(data.toJson());

class StripeKey {
  StripeKey({
    required this.userKey,
  });

  String userKey;

  factory StripeKey.fromJson(Map<String, dynamic> json) => StripeKey(
        userKey: json["user_key"],
      );

  Map<String, dynamic> toJson() => {
        "user_key": userKey,
      };
}
