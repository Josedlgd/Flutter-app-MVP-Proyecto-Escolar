import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/components/default_button.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/size_config.dart';

import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final ProductDB product;

  const Body({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: heightBody,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //* IMAGES
          ProductImages(product: product),
          // * BODY
          TopRoundedContainer(
            color: const Color(0xFFF5F6F9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //* PRODUCT DESCRIPTION
                //? NAME / FAVOURITE / DESCRIPTION
                ProductDescription(
                  product: product,
                  pressOnSeeMore: () {},
                ),

                //* BUTTON TO ADD CARD
                buildWidgetMarginHrzAndVerticalAllScreen(
                  DefaultButton(
                    text: "Añadir al Carrito",
                    press: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
