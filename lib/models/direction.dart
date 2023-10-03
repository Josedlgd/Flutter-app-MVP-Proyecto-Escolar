// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

Map<String, Direction> categoriesFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, Direction>(k, Direction.fromJson(v)));

String categoriesToJson(Map<String, Direction> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Direction {
  Direction(
      {this.number_int,
      required this.colony,
      required this.description,
      required this.number_ext,
      required this.street,
      required this.street_btw1,
      required this.street_btw2});

  String colony;
  String description;
  String number_ext;
  String? number_int;
  bool? isAlmacen;
  String street;
  String street_btw1;
  String street_btw2;

  factory Direction.fromJson(Map<String, dynamic> json) => Direction(
        street: json['street'],
        street_btw1: json['street_btw1'],
        street_btw2: json['street_btw2'],
        colony: json["colony"],
        description: json["description"],
        number_ext: json["number_ext"],
        number_int: json["number_int"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "street_btw1": street_btw1,
        "street_btw2": street_btw2,
        "colony": colony,
        "description": description,
        "number_ext": number_ext,
        "number_int": number_int,
      };

  Direction copy() => Direction(
      street: street,
      street_btw1: street_btw1,
      street_btw2: street_btw2,
      colony: colony,
      description: description,
      number_ext: number_ext,
      number_int: number_int);
}

final example_direction = Direction(
    number_int: '13213',
    colony: '12312',
    description: 'fasdf',
    number_ext: '123',
    street: 'Calle',
    street_btw1: 'Entre calle 1',
    street_btw2: 'eNTRE CALLE 2 ');
