import 'package:flutter/material.dart';

import 'components/body.dart';

class CategoryScreen extends StatelessWidget {
  static String routeName = "/category";

  const CategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Editar Categoría'),
      ),
      body: const SafeArea(child: Body()),
    );
  }
}
