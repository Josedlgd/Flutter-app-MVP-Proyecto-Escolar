class ProductSizes {
  String size;
  String name;

  ProductSizes({required this.size, required this.name});

  factory ProductSizes.fromJson(Map<String, dynamic> json) {
    return ProductSizes(
      name: json['name'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "size": size};
}
