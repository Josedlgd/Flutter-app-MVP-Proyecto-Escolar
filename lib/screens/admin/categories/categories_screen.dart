import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeName = "/categories";

  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoriesService>(context);
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Categorías'),
      ),
      body: const SafeArea(child: Body()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColorStrong,
        onPressed: () {
          categoryService.selectedCategory = Category(name: '', enable: true);
          Navigator.pushNamed(context, CategoryScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
