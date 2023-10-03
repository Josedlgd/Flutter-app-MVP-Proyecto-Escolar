import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';

class ProductItemCard extends StatelessWidget {
  final ProductDB product;
  final Color titleColor;
  final Color priceColor;

  const ProductItemCard({
    super.key,
    required this.product,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SingleProductScreen(product: product)));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 16 - 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // item image
            Container(
              width: MediaQuery.of(context).size.width / 2 - 16 - 8,
              height: MediaQuery.of(context).size.width / 2 - 16 - 8,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                    image: NetworkImage(product.images![0]), fit: BoxFit.cover),
              ),
              child: const Text(''),
            ),

            // item details
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      product.price.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: priceColor,
                      ),
                    ),
                  ),
                  if (product.descount != null)
                    // NOTE //! PERCENT OR CASH
                    Text(
                      product.descountType! == 'percent'
                          ? 'Descuento %${product.descount!.toStringAsFixed(0)}'
                          : 'Descuento \$${product.descount!.toStringAsFixed(2)}',
                      style: txtStyleBodyGrayStrong,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
