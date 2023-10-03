import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ItemVariantProduct extends StatefulWidget {
  const ItemVariantProduct(
      {super.key, required this.nameVariant, required this.file});
  final String nameVariant;
  final String file;
  @override
  State<ItemVariantProduct> createState() => _ItemVariantProductState();
}

class _ItemVariantProductState extends State<ItemVariantProduct> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(flex: 3, child: ProductImage(url: widget.file)),
        Expanded(
            flex: 7,
            child: Center(
              child: Text(
                widget.nameVariant,
                style: txtStyleSubTitleBlack,
                overflow: TextOverflow.ellipsis,
              ),
            )),
        Expanded(
            flex: 2,
            child: IconButton(
                iconSize: sizeGeneralIcon,
                onPressed: () => debugPrint('Eliminar de listado'),
                tooltip: 'Eliminar',
                icon: Icon(
                  Icons.delete_forever,
                  color: primaryColorStrong,
                )))
      ],
    );
  }
}
