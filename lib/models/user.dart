// To parse this JSON data, do
//
//     final userApp = userAppFromJson(jsonString);

import 'dart:convert';

import 'package:domas_ecommerce/models/models.dart';

UserApp userAppFromJson(String str) => UserApp.fromJson(json.decode(str));

String userAppToJson(UserApp data) => json.encode(data.toJson());

class UserApp {
  UserApp({
    required this.addresses,
    this.email,
    this.id,
    required this.lastName,
    required this.name,
    required this.phoneNumbers,
    this.profilePicture
  });

  List<Address> addresses;
  String? email;
  String? id;
  String lastName;
  String name;
  StripeKey? stripeKeys;
  List<PhoneNumber> phoneNumbers;
  String? profilePicture;

  factory UserApp.fromJson(Map<String, dynamic> json) => UserApp(
        addresses: List<Address>.from(
            json["addresses"].map((x) => Address.fromJson(x))),
        email: json["email"],
        id: json["id"],
        lastName: json["last_name"],
        name: json["name"],
        phoneNumbers: List<PhoneNumber>.from(
            json["phone_numbers"].map((x) => PhoneNumber.fromJson(x))), profilePicture:  json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
        "email": email,
        "id": id,
        "last_name": lastName,
        "name": name,
        "profilePicture": profilePicture,
        "stripe_keys": stripeKeys?.toJson(),
        "phone_numbers":
            List<dynamic>.from(phoneNumbers.map((x) => x.toJson())),
      };
}
