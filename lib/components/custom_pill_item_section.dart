import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PillItemSelectorSection extends StatefulWidget {
  PillItemSelectorSection(
      {super.key, required this.section, required this.isSelected});

  // ! we only need categories from database
  // ! product selected
  // ! search categories

  Section section;
  bool isSelected;

  @override
  State<PillItemSelectorSection> createState() => _PillItemSelectorState();
}

//*PILL SELECTOR
class _PillItemSelectorState extends State<PillItemSelectorSection> {
  ProductsService get productService => GetIt.instance<ProductsService>();

  bool _active = false;

  bool get active => _active;

  set active(bool value) {
    _active = value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    active = widget.isSelected;
  }

  Widget buildWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(
              getProportionateScreenWidth(paddingHorizontal / 2)),
          height: getProportionateScreenWidth(sizeGeneralIcon),
          width: getProportionateScreenWidth(sizeGeneralIcon),
          decoration: BoxDecoration(
            border: Border.all(
                color: active ? kActiveColor : Colors.white30, width: 2.5),
            color: active ? kActiveColor : Colors.white30,
            borderRadius: BorderRadius.circular(borderRadiusImagesProduct / 2),
            image: DecorationImage(
              image: NetworkImage(
                widget.section.icon!,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: paddingVertical / 2),
        Text(
          widget.section.name,
          textAlign: TextAlign.center,
          style: active ? txtStyleBodyActive : txtStyleBodyBlack,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            active = !active;
            //NOTE  //!active is true
            active
                ? productService.product.sections == null ||
                        productService.product.sections!.isEmpty
                    ? productService.product.sections = [
                        widget.section
                      ] //EMPTY SET
                    : productService.product.sections!
                        .add(widget.section) //ADD ITEM TO LIST

                // NOTE //! ACTIVE IS FALSE
                : productService.product.sections!.removeWhere(
                    (Section element) =>
                        element == widget.section); //REMOVE IF IS
          });

          debugPrint(
              'sectiosn lenght: ${productService.product.sections!.length}');
        },
        child: buildWidget());
  }
}

// cambiar esto por categoria unica
