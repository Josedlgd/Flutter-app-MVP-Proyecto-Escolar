import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class AllProductsScreen extends StatelessWidget {
  static String routeName = "/allProducts";

  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainAppBar(),
      body: SafeArea(child: Body()),
    );
  }
}
