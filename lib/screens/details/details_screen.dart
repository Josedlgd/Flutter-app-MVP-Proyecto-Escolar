import 'package:flutter/material.dart';

import '../../models/models.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Body(product: agrs.product)),
    );
  }
}

class ProductDetailsArguments {
  final ProductDB product;

  ProductDetailsArguments({required this.product});
}
