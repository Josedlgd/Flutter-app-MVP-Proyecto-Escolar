import 'package:domas_ecommerce/models/models.dart';

class CategoryService {
  static List<Categori> categoryData =
      categoryRawData.map((data) => Categori.fromJson(data)).toList();
}

var categoryRawData = [
  {
    'featured': true,
    'icon_url': 'assets/icons/dog-svgrepo-com.svg',
    'name': 'Perros',
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/cat-svgrepo-com.svg',
    'name': 'Gatos',
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/chameleon-facing-left-svgrepo-com.svg',
    'name': 'Reptiles',
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/bird-svgrepo-com.svg',
    'name': 'Aves',
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/fish-svgrepo-com.svg',
    'name': 'Peces',
  }
];
