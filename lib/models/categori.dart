class Categori {
  String iconUrl;
  String name;
  bool featured;
  Categori({
    required this.name,
    required this.iconUrl,
    required this.featured,
  });

  factory Categori.fromJson(Map<String, dynamic> json) {
    return Categori(
      featured: json['featured'],
      iconUrl: json['icon_url'],
      name: json['name'],
    );
  }
}
