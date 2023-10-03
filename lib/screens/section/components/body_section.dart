import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/screens.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:domas_ecommerce/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BodySection extends StatelessWidget {
  final Section sectionData;
  const BodySection({super.key, required this.sectionData});

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
              sectionData.name,
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
              future: Provider.of<SectionService>(context)
                  .getProductsBySectionId(sectionID: sectionData.id!),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: product.isNotEmpty
                        ? Wrap(
                            spacing: 16,
                            runSpacing: 16 / 2,
                            children: List.generate(
                              product.length,
                              (index) => ProductItemCard(
                                product: product[index],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingHorizontal),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 164,
                                  height: 164,
                                  margin: const EdgeInsets.only(bottom: 32),
                                  child: SvgPicture.asset(
                                      'assets/icons/Paper Bag.svg'),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: paddingVertical),
                                  child: Text(
                                    'No existen productos aun para esta sección ☹️',
                                    style: TextStyle(
                                      color: AppColor.secondary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColor.primary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    backgroundColor: AppColor.border,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Regresar al inicio',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.secondary),
                                  ),
                                ),
                              ],
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
