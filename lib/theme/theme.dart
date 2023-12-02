import 'package:flutter/material.dart';
import 'package:yoko_mind/theme/color.dart';

int _mcgpalette0PrimaryValue = 0xFF1B1464;

Map<int, Color> color = {
  50: const Color(0xFFE4E3EC),
  100: const Color(0xFFBBB9D1),
  200: const Color(0xFF8D8AB2),
  300: const Color(0xFF5F5B93),
  400: const Color(0xFF3D377B),
  500: Color(_mcgpalette0PrimaryValue),
  600: const Color(0xFF18125C),
  700: const Color(0xFF140E52),
  800: const Color(0xFF100B48),
  900: const Color(0xFF080636),
};

MaterialColor colorCustom = MaterialColor(_mcgpalette0PrimaryValue, color);

var appTheme = ThemeData(
  focusColor: AppColor.basic,
  primaryColor: AppColor.basic,
  primarySwatch: colorCustom,
  scaffoldBackgroundColor: AppColor.background,
  appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
    color: AppColor.outLine,
  )),
);
