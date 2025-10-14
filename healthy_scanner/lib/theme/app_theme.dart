import 'package:flutter/material.dart';
import 'app_typography.dart';
import 'app_colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.mainRed,
    onPrimary: Colors.white,
    secondary: AppColors.salmonRed,
    onSecondary: Colors.white,
    surface: AppColors.staticWhite,
    onSurface: AppColors.staticBlack,
    error: AppColors.brickRed,
    onError: Colors.white,
  ),
  textTheme: buildTextTheme(),
);
