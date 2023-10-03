import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class ItemProductListDetails extends StatelessWidget {
  const ItemProductListDetails({super.key, required this.product});
  final Cart product;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(flex: 3, child: ProductImage(url: product.image)),
        Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: paddingHorizontal,
                      vertical: paddingVertical / 2),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    product.productName!,
                    style: txtStyleSubTitleBlack,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: paddingHorizontal,
                      vertical: paddingVertical / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: paddingVertical / 2),
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                'Precio: \$${product.productPrice}',
                                style: txtStyleBodyBlackStrong,
                              ),
                            ),
                            if (product.productDescount != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: paddingVertical / 2),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  'Descuento: \$${product.productDescount}',
                                  style: txtStyleBodyBlackStrong,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: secondaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: paddingVertical),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  product.quantity.toString(),
                                  style: txtStyleSubTitlePurpleStrong,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                )
              ],
            )),
      ],
    );
  }
}
