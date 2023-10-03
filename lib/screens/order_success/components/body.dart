import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 124,
            height: 124,
            margin: const EdgeInsets.only(bottom: 32),
            child: SvgPicture.asset(
              'assets/icons/Success.svg',
              color: Colors.green,
            ),
          ),
          const Text(
            '¡Se ha creado tu pedido! 😆',
            style: TextStyle(
              color: AppColor.secondary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              'Hemos recibido tu pedido',
              style: TextStyle(color: AppColor.secondary.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
