import 'package:flutter/material.dart';
import 'package:domas_ecommerce/size_config.dart';

const primaryColor = Color.fromARGB(255, 178, 120, 229);
const primaryColorStrong = Color.fromARGB(255, 85, 31, 133);
const primaryLightColor = Color.fromARGB(255, 255, 251, 248);
const primaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromARGB(255, 85, 31, 133),
    Color.fromARGB(255, 178, 120, 229)
  ],
);
const secondaryColor = Color(0xFF979797);
const textColor = Color(0xFF757575);
const errorColor = Color(0xFFF03738);
const warningColor = Color.fromARGB(255, 221, 199, 0);
const sucessColor = Colors.green;

const animationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);
const defaultPadding = 20.0;

const double heightIconsBig = 50.0;
const heightIconsMedium = 35;
const heightIconsSmall = 25;

// Form Error
final RegExp emailValidatorRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
final RegExp nameValidatorRegExp =
    RegExp(r"^[a-zA-ZÀ-ÿ\u00f1\u00d1]+([ '-][a-zA-ZÀ-ÿ\u00f1\u00d1]+)*$");
final RegExp phoneValidatorRegExp =
    RegExp(r'^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
const String emailNullError = "Debes ingresar tu correo electrónico";
const String invalidEmailError = "Ingresa un correo electrónico válido";
const String invalidNameError = "Debes ingresar un nombre";
const String invalidLastNameError = "Debes ingresar un apellido";
const String invalidPhoneError = "Ingresa un número de teléfono válido";
const String passNullError = "Debes ingresar tu contraseña";
const String shortPassError = "La contraseña debe ser mayor a 6 caracteres";
const String matchPassError = "Las contraseñas no coinciden";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: textColor),
  );
}

final MaterialStateProperty<Color?> overlayColor =
    MaterialStateProperty.resolveWith<Color?>(
  (Set<MaterialState> states) {
    // Material color when switch is selected.
    if (states.contains(MaterialState.selected)) {
      return Color.fromARGB(100, 85, 31, 133);
    }
    // Material color when switch is disabled.
    if (states.contains(MaterialState.disabled)) {
      return Color.fromARGB(100, 178, 120, 229);
    }
    // Otherwise return null to set default material color
    // for remaining states such as when the switch is
    // hovered, or focused.
    return null;
  },
);

final MaterialStateProperty<Color?> trackColor =
    MaterialStateProperty.resolveWith<Color?>(
  (Set<MaterialState> states) {
    // Material color when switch is selected.
    if (states.contains(MaterialState.selected)) {
      return Color.fromARGB(255, 85, 31, 133);
    }
    // Material color when switch is disabled.
    if (states.contains(MaterialState.disabled)) {
      return Color.fromARGB(255, 178, 120, 229);
    }
    // Otherwise return null to set default material color
    // for remaining states such as when the switch is
    // hovered, or focused.
    return null;
  },
);
