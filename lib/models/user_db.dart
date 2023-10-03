import 'dart:convert';

class UserDB {
  UserDB({
    required this.name,
    required this.lastname,
    required this.id,
    required this.email,
    required this.password,
    required this.profile_picture,
    required this.role,
    required this.colony,
    required this.description,
    required this.number_ext,
    required this.number_int,
    required this.street,
    required this.street_btw1,
    required this.street_btw2,
    required this.number,
    required this.name_contact,
    required this.directions,
    this.stripe_keys,
    this.telephones,
  });

//! INFORMACION PERSONAL BASICA
  String name;
  String lastname;
  String id;
  String email;
  String password;
  String profile_picture;
  String role;

//! DIRECTIONS
  String colony;
  String description;
  int number_ext;
  int number_int;
  String street;
  String street_btw1;
  String street_btw2;

//!TELEPONES
  int number;
  String name_contact;

//!LISTAS

  List<Map<String, dynamic>> directions;
  List<Map<String, dynamic>>? telephones;
  List<Map<String, dynamic>>? stripe_keys;

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "lastname": lastname,
        "email": email,
        "password": password,
        "profile_picture": profile_picture,
        "role": role,
        "colonny": colony,
        "description": description,
        "number_ext": number_ext,
        "number_int": number_int,
        "street": street,
        "street_btw1": street_btw1,
        "street_btw2": street_btw2,
        "number": number,
        "name_contact": name_contact,
        "directions": directions,
        "telephones": telephones,
        "stripe_keys": stripe_keys,
      };

  factory UserDB.fromJson(Map<String, dynamic> json) => UserDB(
        name: json["name"],
        id: json['id'],
        lastname: json['lastname'],
        email: json['email'],
        password: json['password'],
        profile_picture: json['profile_picture'],
        role: json['role'],
        colony: json['colony'],
        description: json["description"],
        number_ext: json["number_ext"],
        number_int: json["number_int"],
        street: json["street"],
        street_btw1: json["street_btw1"],
        street_btw2: json["street_btw2"],
        number: json["number"],
        name_contact: json["nam_contact"],
        directions: json["directions"],
        telephones: json["telephones"],
        stripe_keys: json["stripe_keys"],
      );
}
