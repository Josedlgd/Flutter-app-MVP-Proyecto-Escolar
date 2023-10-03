// To parse this JSON data, do
//
//     final userApp = phoneNumberFromJson(jsonString);

import 'dart:convert';

PhoneNumber phoneNumberFromJson(String str) => PhoneNumber.fromJson(json.decode(str));

String phoneNumberToJson(PhoneNumber data) => json.encode(data.toJson());

class PhoneNumber {
  PhoneNumber({
    required this.contactName,
    required this.phoneNumber,
  });

  String contactName;
  int phoneNumber;

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
        contactName: json["contact_name"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "contact_name": contactName,
        "phone_number": phoneNumber,
      };
}