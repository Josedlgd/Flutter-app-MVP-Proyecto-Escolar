import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/screens/screens.dart';
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
            width: 164,
            height: 164,
            margin: const EdgeInsets.only(bottom: 32),
            child: SvgPicture.asset('assets/icons/Paper Bag.svg'),
          ),
          const Text(
            'No tienes productos ☹️',
            style: TextStyle(
              color: AppColor.secondary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 48, top: 12),
            child: Text(
              'Regresa al inicio para explorar \nnuestros productos y agregarlos al carrito',
              style: TextStyle(color: AppColor.secondary.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: AppColor.border,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'Regresar al inicio',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColor.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
