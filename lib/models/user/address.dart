// To parse this JSON data, do
//
//     final userApp = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address(
      {required this.neighborhood,
      required this.numberExt,
      required this.numberInt,
      required this.street,
      required this.zipCode,
      this.description,
      this.isAlmacen});

  String? neighborhood;
  int? numberExt;
  int? numberInt;
  String? street;
  int? zipCode;
  bool? isAlmacen;
  String? description;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      neighborhood: json.containsKey('neighborhood')
          ? json["neighborhood"].toString()
          : null,
      numberExt: json.containsKey('number_ext')
          ? json["number_ext"] != null && json["number_ext"] is String
              ? int.parse(json["number_ext"])
              : json["number_ext"]
          : null,
      numberInt: json.containsKey('number_int')
          ? json["number_int"] != null && json["number_int"] is String
              ? int.parse(json["number_int"])
              : json["number_int"]
          : null,
      street: json.containsKey('street') ? json["street"].toString() : null,
      zipCode: json.containsKey('zip_code') && json["zip_code"] != null
          ? json["zip_code"] is String
              ? int.parse(json["zip_code"])
              : json["zip_code"]
          : null,
      description: json.containsKey('description') ? json['description'] : null,
      isAlmacen: json.containsKey('is_almacen') ? json['is_almacen'] : false);

  Map<String, dynamic> toJson() => {
        "neighborhood": neighborhood,
        "number_ext": numberExt,
        "number_int": numberInt,
        "street": street,
        "zip_code": zipCode,
        "is_almacen": isAlmacen,
        "description": description
      };
}

Address example_adress = Address(
    neighborhood: 'sdfsdf',
    numberExt: 123,
    numberInt: 123123,
    street: 'WE4QWWET  ',
    zipCode: 767567);
