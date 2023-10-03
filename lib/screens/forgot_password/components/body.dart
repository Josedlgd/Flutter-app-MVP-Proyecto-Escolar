import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:domas_ecommerce/services/services.dart';
import 'package:flutter/material.dart';
import 'package:domas_ecommerce/components/default_button.dart';
import 'package:domas_ecommerce/components/no_account_text.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

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
            '¿Olvidaste tu contraseña?',
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
            'Ingresa el correo donde te registraste \ny te enviaremos un correo para que la restablezcas.',
            style: TextStyle(
                color: AppColor.secondary.withOpacity(0.7),
                fontSize: 12,
                height: 150 / 100),
          ),
        ),
        ChangeNotifierProvider(
            create: (_) => ForgotPasswordFormProvider(),
            child: const _ForgotPassForm()),
      ],
    );
  }
}

class _ForgotPassForm extends StatelessWidget {
  const _ForgotPassForm();
  @override
  Widget build(BuildContext context) {
    final forgotPasswordForm = Provider.of<ForgotPasswordFormProvider>(context);
    return Form(
      key: forgotPasswordForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Ingresa tu correo electrónico',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Message.svg',
                    color: AppColor.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            onChanged: (value) => forgotPasswordForm.email = value,
            validator: (value) {
              RegExp regExp = emailValidatorRegExp;

              return regExp.hasMatch(value ?? '') ? null : invalidEmailError;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: forgotPasswordForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService = Provider.of<AuthFirebaseService>(
                          context,
                          listen: false);

                      if (!forgotPasswordForm.isValidForm()) return;

                      forgotPasswordForm.isLoading = true;

                      await authService
                          .sendPasswordResetEmail(forgotPasswordForm.email);

                      forgotPasswordForm.isLoading = false;
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
                'Enviar correo',
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
