import 'package:domas_ecommerce/models/models.dart';

class CartService {
  static List<Cart> cartData =
      cartRawData.map((data) => Cart.fromJson(data)).toList();
}

var cartRawData = [
  {
    'image': 'assets/images/nikeblack.jpg',
    'name': 'Nike Waffle One',
    'price': 1429000,
    'count': 1,
  },
  // 2
  {
    'image': 'assets/images/nikeblack.jpg',
    'name': "Nike Blazer Mid77 Vintage",
    'price': 1429000,
    'count': 1,
  },
  // 3
  {
    'image': 'assets/images/nikeblack.jpg',
    'name': "Nike Sportswear Swoosh",
    'price': 849000,
    'count': 1,
  },
];
