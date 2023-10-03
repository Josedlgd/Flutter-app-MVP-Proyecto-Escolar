// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

Map<String, Cart> cartFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Cart>(k, Cart.fromJson(v)));

String cartToJson(Map<String, Cart> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Cart {
  String? id;
  String? image;
  num? initialPrice;
  String? productId;
  String? productName;
  num? productPrice;
  num? productDescount;
  String? productDescountType;
  int? quantity;

  Cart(
      {this.id,
      required this.image,
      required this.initialPrice,
      required this.productId,
      required this.productName,
      required this.productPrice,
      required this.quantity,
      this.productDescount,
      this.productDescountType});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        image: json["image"],
        initialPrice: json["initialPrice"],
        productId: json["productId"],
        productName: json["productName"],
        productPrice: json["productPrice"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "initialPrice": initialPrice,
        "productId": productId,
        "productName": productName,
        "productPrice": productPrice,
        "quantity": quantity,
      };
}
