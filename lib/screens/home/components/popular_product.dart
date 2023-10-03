import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/models/models.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key, required this.popularProducts});
  final List<ProductDB> popularProducts;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16),
          child: Text(
            'Últimos agregados',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
              popularProducts.length,
              (index) => ProductItemCard(
                product: popularProducts[index],
              ),
            ),
          ),
        )
      ],
    );
  }
}
