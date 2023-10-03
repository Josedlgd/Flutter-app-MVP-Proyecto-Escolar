import 'package:card_swiper/card_swiper.dart';
import 'package:domas_ecommerce/models/models.dart';
import 'package:domas_ecommerce/screens/home/components/section_title.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:domas_ecommerce/ui/ui.dart';
import 'package:flutter/material.dart';

class DiscountBanner extends StatelessWidget {
  final List<Promotion> promotions;

  const DiscountBanner({
    Key? key,
    required this.promotions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (promotions.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.4,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.4,
      child: Swiper(
        itemCount: promotions.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.8, //0.6
        itemHeight: size.height * 0.4, //0.4
        itemBuilder: (_, index) {
          final promotion = promotions[index];

          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.png'),
              image: NetworkImage(promotion.text),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
