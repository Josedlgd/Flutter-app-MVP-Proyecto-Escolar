import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/general.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  final Category categoryData;
  const Body({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: AppColor.secondary,
            child: Text(
              categoryData.name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 5,
            color: AppColor.accent,
          ),
          FutureBuilder(
              future: Provider.of<ProductsService>(context)
                  .getProductsByCategoryId(categoryID: categoryData.id!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: SizeConfig.screenWidth,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Center(
                              child: CircularProgressIndicator(
                            color: AppColor.primary,
                            strokeWidth: 10.0,
                            value: 1.0,
                          )),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final product = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16 / 2,
                      children: List.generate(
                        product.length,
                        (index) => ProductItemCard(
                          product: product[index],
                        ),
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
