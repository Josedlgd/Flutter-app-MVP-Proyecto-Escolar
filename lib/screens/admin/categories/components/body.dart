import 'dart:ui';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/ui/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesService = Provider.of<CategoriesService>(context);
    if (categoriesService.isLoading) {
      return const LoadingScreen();
    } else {
      return RefreshIndicator(
        child: ListView.builder(
          itemCount: categoriesService.categories.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              categoriesService.selectedCategory =
                  categoriesService.categories[index].copy();
              Navigator.pushNamed(context, CategoryScreen.routeName);
            },
            child: Table(
              children: [
                TableRow(children: [
                  _SigleCard(category: categoriesService.categories[index]),
                ]),
              ],
            ),
          ),
        ),
        onRefresh: () async {
          await categoriesService.loadCategories();
        },
      );
    }
  }
}

class _SigleCard extends StatelessWidget {
  final Category category;

  const _SigleCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CardBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            child: getImage(category.icon),
          ),
          const SizedBox(height: 10),
          Text(
            category.name,
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}

class _CardBackground extends StatelessWidget {
  final Widget child;

  const _CardBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
                color: const Color.fromARGB(176, 229, 230, 233),
                borderRadius: BorderRadius.circular(20)),
            child: child,
          ),
        ),
      ),
    );
  }
}
