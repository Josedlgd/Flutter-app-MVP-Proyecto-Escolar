import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'image_viewer.dart';

class Body extends StatefulWidget {
  final ProductDB product;
  const Body({super.key, required this.product});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    PageController productImageSlider = PageController();
    ProductDB product = widget.product;
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        // Section 1 - appbar & product image
        Stack(
          alignment: Alignment.topCenter,
          children: [
            // product image
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageViewer(imageUrl: product.images!),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 310,
                color: Colors.white,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: productImageSlider,
                  children: List.generate(
                      product.images!.length,
                      (index) => getImage(
                          product.images != null && product.images!.isNotEmpty
                              ? product.images![index]
                              : null)),
                ),
              ),
            ),
            // appbar
            CustomAppBar(
              title: product.name!,
              leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
              leftOnTap: () {
                Navigator.of(context).pop();
              },
              rightOnTap: () {},
              rightIcon: SvgPicture.asset(
                'assets/icons/Bag.svg',
              ),
            ),
            // indicator
            Positioned(
              bottom: 16,
              child: SmoothPageIndicator(
                controller: productImageSlider,
                count: product.images!.length,
                effect: ExpandingDotsEffect(
                  dotColor: AppColor.primary.withOpacity(0.2),
                  activeDotColor: AppColor.primary.withOpacity(0.2),
                  dotHeight: 8,
                ),
              ),
            ),
          ],
        ),
        // Section 2 - product info
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: paddingVertical),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name!,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColor.secondary),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "\$${product.price}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primary),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  "Stock disponible: ${product.stock}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primary),
                ),
              ),
              Text(
                product.description,
                style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    height: 150 / 100),
              ),
            ],
          ),
        ),

        if (product.titleOptions != null &&
            product.productOptions != null &&
            product.productOptions!.isNotEmpty)
          // Section 3 - Color Picker
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.titleOptions.toString(),
                    style: txtStyleSubHeadingCommonBlue),
                SelectableOptionProduct(
                  optionsAvailable: product.productOptions ?? [],
                  margin: const EdgeInsets.only(top: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
