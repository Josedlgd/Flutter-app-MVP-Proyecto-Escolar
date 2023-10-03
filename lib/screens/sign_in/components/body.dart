import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/screens/sign_in/components/sign_form.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      children: [
        // Section 1 - Header
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 12),
          child: const Text(
            '¡Bienvenido de nuevo! 😁',
            style: TextStyle(
              color: AppColor.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          child: Text(
            'Ingresa tu correo y contraseña \npara iniciar sesión.',
            style: TextStyle(
                color: AppColor.secondary.withOpacity(0.7),
                fontSize: 12,
                height: 150 / 100),
          ),
        ),
        // Section 2 - Form
        const SignForm(),
      ],
    );
  }
}
