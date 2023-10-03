// To parse this JSON data, do
//
//     final categories = sectionsFromJson(jsonString);

import 'dart:convert';

Map<String, Section> sectionsFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Section>(k, Section.fromJson(v)));

String sectionsToJson(Map<String, Section> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Section {
  Section({this.id, this.icon, required this.name, required this.enable});

  String? icon;
  String name;
  bool enable;
  String? id;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
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

  Section copy() => Section(icon: icon, name: name, enable: enable, id: id);
}
