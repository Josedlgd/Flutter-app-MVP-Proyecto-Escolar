// ignore_for_file: avoid_print

import 'package:domas_ecommerce/screens/search/search_delegate.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.7,
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        child: TextField(
          readOnly: true,
          onTap: () =>
              showSearch(context: context, delegate: ProductSearchDelegate()),
          decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "Buscar producto",
              prefixIcon: Icon(
                Icons.search,
                color: Color.fromARGB(255, 178, 120, 229),
              )),
        ),
      ),
    );
  }
}
