class OrderUser {
  String imageUrl;
  String title;
  String description;
  DateTime dateTime;

  OrderUser({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  factory OrderUser.fromJson(Map<String, dynamic> json) {
    return OrderUser(
      imageUrl: json['image_url'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['date_time']),
    );
  }
}
