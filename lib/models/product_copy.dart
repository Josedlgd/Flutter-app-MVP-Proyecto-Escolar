import 'package:flutter/material.dart';

class ProductCopy {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, is_popular;

  ProductCopy({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.is_popular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<ProductCopy> demoProducts = [
  ProductCopy(
    id: 1,
    images: [
      "assets/images/ps4_console_white_1.png",
      "assets/images/ps4_console_white_2.png",
      "assets/images/ps4_console_white_3.png",
      "assets/images/ps4_console_white_4.png",
    ],
    colors: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Canasta para perro",
    price: 350,
    description: description,
    rating: 4.8,
    isFavourite: true,
    is_popular: true,
  ),
  ProductCopy(
    id: 2,
    images: [
      "assets/images/Image Popular ProductDB 2.png",
    ],
    colors: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Peluche interactivo",
    price: 120,
    description: description,
    rating: 4.1,
    is_popular: true,
  ),
  ProductCopy(
    id: 3,
    images: [
      "assets/images/glap.png",
    ],
    colors: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Bombilla para calor",
    price: 420,
    description: description,
    rating: 4.1,
    isFavourite: true,
    is_popular: true,
  ),
];

const String articletitle = "Producto";
const String description =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua..";