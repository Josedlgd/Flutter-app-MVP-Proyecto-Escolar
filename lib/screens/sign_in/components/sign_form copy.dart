import 'package:domas_ecommerce/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/default_button.dart';
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
            decoration: const InputDecoration(
              labelText: "Correo electrónico",
              hintText: "Ingresa tu correo electrónico",
              prefixIconColor: primaryColor,
              prefixIcon: Icon(
                Icons.email,
              ),
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              RegExp regExp = emailValidatorRegExp;

              return regExp.hasMatch(value ?? '') ? null : invalidEmailError;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              hintText: "Ingresa tu contraseña",
              prefixIconColor: primaryColor,
              prefixIcon: Icon(
                Icons.lock,
              ),
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : shortPassError;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                ),
                child: const Text(
                  "Olvidé mi contraseña",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Ingresar",
            press: loginForm.isLoading
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
          ),
        ],
      ),
    );
  }
}
