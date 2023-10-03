import 'dart:io';

import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/models/models.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductDB product;

  getCategoriesForProduct() {
    String myCategories = '';

    for (var item in product.categories!) {
      if (myCategories.isEmpty) {
        myCategories = '${item.name} ';
      }
      myCategories = '$myCategories | ${item.name}';
    }
    return myCategories;
  }

  getSectionForProduct() {
    String mySections = '';

    for (var item in product.sections!) {
      if (mySections.isEmpty) {
        mySections = '${item.name} ';
      }
      mySections = '$mySections | ${item.name}';
    }
    return mySections;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(paddingHorizontal),
          vertical: getProportionateScreenWidth(paddingVertical)),
      child: Container(
        // margin:  EdgeInsets.symmetric(horizontal:getProportionateScreenWidth(paddingHorizontal), vertical: getProportionateScreenHeight(paddingVertical)),
        width: SizeConfig.screenWidth,
        height: heightProductCardAdminList,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(
              url: product.images![0],
            ),
            _ProductDetails(
              productCategory: getCategoriesForProduct(),
              sectionctSection: getSectionForProduct(),
              productName: product.name!,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTitle(
                productPrice: product.price!.toDouble(),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _NotAvailable(
                productAvaible: product.available!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 0),
              blurRadius: 5,
            )
          ]);
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({
    Key? key,
    required this.productAvaible,
  }) : super(key: key);

  final bool productAvaible;

  @override
  Widget build(BuildContext context) {
    if (!productAvaible) {
      return Container(
        width: 120,
        height: 70,
        decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(15))),
        child: const FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'No disponible',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 120,
        height: 70,
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(15))),
        child: const FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Disponible',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      );
    }
  }
}

class _PriceTitle extends StatelessWidget {
  const _PriceTitle({
    Key? key,
    required this.productPrice,
  }) : super(key: key);

  final double productPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 120,
      height: 70,
      decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          )),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$$productPrice',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    Key? key,
    required this.productName,
    required this.sectionctSection,
    required this.productCategory,
  }) : super(key: key);

  final String sectionctSection;
  final String productCategory;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 120),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Categorias: $productCategory',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Secciones: $sectionctSection',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15),
      ));
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage({
    Key? key,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: sizeBckImage,
        height: sizeBckImage,
        child: getImage(url),
      ),
    );
  }
}
