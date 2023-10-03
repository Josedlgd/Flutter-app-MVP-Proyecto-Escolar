import 'dart:convert';

import 'package:flutter/material.dart';

class ProductCartDB {
  ProductCartDB({
    required this.name,
    required this.id,
    required this.image,
    required this.descount,
    required this.price,
    required this.available,
    required this.quantity,
  });

//! INFORMACION BASICA
  String name;
  String id;

  bool available;

//! PRECIO
  double descount;
  double price;
  int quantity;

//!LISTAS
  String image;

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "descount": descount,
        "price": price,
        "quantity": quantity,
        "image": image,
      };

  factory ProductCartDB.fromJson(Map<String, dynamic> json) => ProductCartDB(
        name: json.containsKey('name') ? json["name"] : '',
        id: json.containsKey('id') ? json['id'] : '',
        descount:
            json.containsKey('descount') ? json["descount"].toDouble() : 0.0,
        price: json.containsKey('price') ? json["price"].toDouble() : 0.0,
        quantity: json.containsKey('quantity') ? json["quantity"] : 0,
        image: json.containsKey('image') ? json["image"] : '',
        available: false,
      );

  ProductCartDB copy() => ProductCartDB(
      name: name,
      price: price,
      id: id,
      image: image,
      quantity: quantity,
      descount: descount,
      available: available);
}

ProductCartDB product_cart_example = ProductCartDB(
    available: true,
    name: 'Ejemplo producto',
    id: '12312312',
    image:
        "https://res.cloudinary.com/diut8vgyz/image/upload/v1678147933/hlvswt23nzypx9xekhyj.jpg",
    descount: 123,
    price: 1000,
    quantity: 1);
