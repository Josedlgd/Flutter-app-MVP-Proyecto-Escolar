// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

Map<String, Category> categoriesFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, Category>(k, Category.fromJson(v)));

String categoriesToJson(Map<String, Category> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Category {
  Category(
      {this.id, this.icon, required this.name, required this.enable});

  String? icon;
  String name;
  bool enable;
  String? id;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        icon: json["icon"],
        name: json["name"],
        enable: json["enable"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "name": name,
        "enable": enable,
        "id": id,
      };

  Category copy() => Category(icon: icon, name: name, enable: enable, id: id);
}
