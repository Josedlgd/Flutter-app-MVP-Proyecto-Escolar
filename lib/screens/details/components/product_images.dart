import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/models/models.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductDB product;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildWidgetMarginHrzAllScreen(
          Container(
            decoration: buildBoxDecorationCard(),
            width: SizeConfig.screenWidth,
            child: AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: widget.product.id.toString(),
                child: getImage(widget.product.images![0]),
              ),
            ),
          ),
        ),
        if (widget.product.images != null)
          if (widget.product.images!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(widget.product.images!.length,
                    (index) => buildSmallProductPreview(index)),
              ],
            )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: primaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.asset(widget.product.images![index]),
      ),
    );
  }
}
