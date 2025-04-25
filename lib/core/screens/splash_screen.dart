import 'package:flutter/material.dart';

import '../constants/asset_const.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AssetConst.splashBG, fit: BoxFit.fill),
          ),
          Center(child: Image.asset(AssetConst.appLogo)),
        ],
      ),
    );
  }
}