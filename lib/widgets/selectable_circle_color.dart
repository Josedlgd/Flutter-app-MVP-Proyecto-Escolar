import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/text_styles.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SelectableOptionProduct extends StatefulWidget {
  final EdgeInsetsGeometry? margin, padding;
  final List<ProductOptions> optionsAvailable;

  const SelectableOptionProduct(
      {super.key, required this.optionsAvailable, this.margin, this.padding});

  @override
  _SelectableCircleState createState() => _SelectableCircleState();
}

class _SelectableCircleState extends State<SelectableOptionProduct> {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
  }

  _change(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        children: List.generate(
          widget.optionsAvailable.length,
          (index) {
            return Container(
              constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth / 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      _change(index);
                    },
                    child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            border: selectedIndex == index
                                ? Border.all(width: 5, color: AppColor.primary)
                                : null,
                            borderRadius: BorderRadius.circular(100)),
                        child: ProductImage(
                            url: widget.optionsAvailable[index].imagen)),
                  ),
                  Text(
                    widget.optionsAvailable[index].optionName ?? '',
                    style: txtStyleBodyPrimaryColor,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
