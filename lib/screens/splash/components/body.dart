import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/screens/sign_in/sign_in_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section 1 - Illustration
          Container(
            margin: const EdgeInsets.only(top: 32),
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset('assets/icons/shopping illustration.svg'),
          ),
          // Section 2 - Marketky with Caption
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: const Text(
                  'Do Mas',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                ),
              ),
              Text(
                'Toda una tienda desde tu bolsillo. Encuentra \nlos mejores productos aquí.',
                style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7), fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // Section 3 - Get Started Button
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, SignInScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                '¡Comienza!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
