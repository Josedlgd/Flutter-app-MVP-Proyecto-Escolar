import 'dart:io';
import 'dart:ui';

import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:flutter/material.dart';

//* CONSTANTS
const paddingHorizontal = 25.0;
const paddingVertical = 10.0;
const heightBottomNavigation = 75.0;
final heightBody = SizeConfig.screenHeight - heightBottomNavigation;
const heightProductCardAdminList = 250.0;
final heightImageProductDescription = SizeConfig.screenHeight / 2;
const borderRadiusImagesProduct = 30.0;
const sizeGeneralIcon = 50.0;
const kActiveColor = Color.fromARGB(255, 76, 217, 81);

//!IMAGES
const sizeBckImage = 450.0;

List<Map<String, dynamic>> categories = [
  {"icon": "assets/icons/dog-svgrepo-com.svg", "text": "Perros"},
  {"icon": "assets/icons/cat-svgrepo-com.svg", "text": "Gatos"},
  {
    "icon": "assets/icons/chameleon-facing-left-svgrepo-com.svg",
    "text": "Reptiles"
  },
  {"icon": "assets/icons/bird-svgrepo-com.svg", "text": "Aves"},
  {"icon": "assets/icons/fish-svgrepo-com.svg", "text": "Peces"},
];

List<Map<String, dynamic>> colorsList = [
  {"color": const Color(0xFFF6625E), "text": "Rojo", "isSelected": false},
  {"color": const Color(0xFF836DB8), "text": "Morado", "isSelected": false},
  {"color": const Color(0xFF000000), "text": "Negro", "isSelected": false},
  {"color": const Color(0xFF90CAF9), "text": "Azul", "isSelected": false},
  {"color": const Color(0xFFA5D6A7), "text": "Verde", "isSelected": false},
  {"color": const Color(0xFFE6EE9C), "text": "Amarillo", "isSelected": false},
  {
    "color": const Color.fromARGB(255, 241, 100, 150),
    "text": "Rosa",
    "isSelected": false
  },
  {"color": const Color(0xFFFFCC80), "text": "Naranja", "isSelected": false},
  {"color": const Color(0xFFFFFFFF), "text": "Blanco", "isSelected": false},
  {"color": const Color(0xB3FFFFFF), "text": "Sin color", "isSelected": false},
];

//* BUILD WIDGETS
buildWidgetMarginHrzAllScreen(Widget widget) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(paddingHorizontal)),
    child: widget,
  );
}

buildWidgetMarginVerticalAllScreen(Widget widget) {
  return Padding(
    padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(paddingVertical / 2)),
    child: widget,
  );
}

buildWidgetMarginHrzAndVerticalAllScreen(Widget widget) {
  return Padding(
    padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(paddingVertical / 2),
        horizontal: getProportionateScreenWidth(paddingHorizontal)),
    child: widget,
  );
}

BoxDecoration buildBoxDecorationShadowCard() => const BoxDecoration(
      borderRadius:
          BorderRadius.all(Radius.circular(borderRadiusImagesProduct)),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, 0),
        ),
      ],
    );

BoxDecoration buildBoxDecorationCard() => const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.all(Radius.circular(borderRadiusImagesProduct)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 0),
            blurRadius: 5,
          )
        ]);

//! IMAGES
Widget getImage(String? picture) {
  if (picture == null) {
    return const Image(
        image: AssetImage('assets/no-image.png'), fit: BoxFit.cover);
  }
  if (picture.startsWith('http')) {
    return FadeInImage(
      placeholder: const AssetImage('assets/jar-loading.gif'),
      image: NetworkImage(picture),
      fit: BoxFit.cover,
    );
  }
  return Image.file(File(picture), fit: BoxFit.fill);
}

//?DATA NOR RECEIVED [NULL DATA]
getNoDataReceivedText() => Center(
        child: Column(
      children: [
        Icon(
          Icons.arrow_upward,
          size: SizeConfig.defaultSize,
          color: primaryColorStrong,
        ),
        const Text('Desliza de arriba abajo nuevamente'),
      ],
    ));

//?
buildWidgetWaiting() => Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        ),
        const Center(
            child: CircularProgressIndicator(color: primaryColorStrong))
      ],
    );
