import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class ProductCategoryScreen extends StatelessWidget {
  final Category categoryData;
  const ProductCategoryScreen({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBarList(),
      body: SafeArea(
          child: Body(
        categoryData: categoryData,
      )),
    );
  }
}
