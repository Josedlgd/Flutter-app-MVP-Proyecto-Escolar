import 'dart:ui';

import 'package:domas_ecommerce/constants.dart';
import 'package:domas_ecommerce/size_config.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({
    Key? key,
    this.delay = const Duration(milliseconds: 500),
  }) : super(key: key);

  final Duration delay;

  static _LoadingOverlayState of(BuildContext context) {
    return _LoadingOverlayState();
  }

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.defaultSize,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: const Opacity(
              opacity: 0.4,
              child: ModalBarrier(dismissible: false, color: primaryLightColor),
            ),
          ),
          const Center(
              child: CircularProgressIndicator(
            color: primaryColorStrong,
            strokeWidth: 10.0,
            value: 1.0,
          )),
        ],
      ),
    );
  }
}
