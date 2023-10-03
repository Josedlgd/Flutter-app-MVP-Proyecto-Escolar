import 'package:domas_ecommerce/constant/app_color.dart';
import 'package:domas_ecommerce/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../services/services.dart';
import '../../../size_config.dart';
import '../../screens.dart';

class SignForm extends StatelessWidget {
  const SignForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ChangeNotifierProvider(
            create: (_) => LoginFormProvider(),
            child: _LoginForm(),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
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
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              RegExp regExp = emailValidatorRegExp;

              return regExp.hasMatch(value ?? '') ? null : invalidEmailError;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            autofocus: false,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Ingresa tu contraseña',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Lock.svg',
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
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != '') ? null : passNullError;
            },
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary.withOpacity(0.1),
              ),
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColor.secondary.withOpacity(0.5),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authFirebaseService = AuthFirebaseService();

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      final String? errorMessage = await authFirebaseService
                          .signInUser(loginForm.email, loginForm.password);

                      if (errorMessage == null) {
                        if (loginForm.email == 'admin_domas@adminapp.com') {
                          Navigator.pushReplacementNamed(
                              context, DashboardScreen.routeName);
                          NotificationsService.showSnackbar(
                              '¡Hola, Administrador!', sucessColor);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.routeName);
                          NotificationsService.showSnackbar(
                              '¡Iniciaste sesión!', sucessColor);
                        }
                      } else {
                        NotificationsService.showSnackbar(
                            errorMessage, errorColor);
                        loginForm.isLoading = false;
                      }
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
                'Iniciar sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: 100,
            height: 2,
            color: AppColor.border,
          ),
          // SIgn in With Google
          ElevatedButton(
            onPressed: () async {
              await AuthFirebaseService().signInWithGoogle();
              Navigator.pushReplacementNamed(
                  context, CheckUserCompleted.routeName);
              NotificationsService.showSnackbar(
                  '¡Iniciaste sesión!', sucessColor);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primary,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              backgroundColor: AppColor.primarySoft,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/Google.svg',
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: const Text(
                    'Inicia sesión con Google',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
