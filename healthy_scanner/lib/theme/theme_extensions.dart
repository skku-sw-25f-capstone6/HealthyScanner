import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_typography.dart';

extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Flutter 기본 TextTheme
  TextStyle get caption4Semibold => AppTextStyles.caption4Semibold;
  TextStyle get caption3Regular => AppTextStyles.caption3Regular;
  TextStyle get caption2Regular => AppTextStyles.caption2Regular;
  TextStyle get caption2Medium => AppTextStyles.caption2Medium;
  TextStyle get caption1Regular => AppTextStyles.caption1Regular;
  TextStyle get caption1Medium => AppTextStyles.caption1Medium;
  TextStyle get caption1SemiBold => AppTextStyles.caption1SemiBold;
  TextStyle get caption1Bold => AppTextStyles.caption1Bold;

  // Footnotes
  TextStyle get footnote3SemiBold => AppTextStyles.footnote3SemiBold;
  TextStyle get footnote2Regular => AppTextStyles.footnote2Regular;
  TextStyle get footnote2Medium => AppTextStyles.footnote2Medium;
  TextStyle get footnote2Bold => AppTextStyles.footnote2Bold;
  TextStyle get footnote1Light => AppTextStyles.footnote1Light;
  TextStyle get footnote1Regular => AppTextStyles.footnote1Regular;
  TextStyle get footnote1Medium => AppTextStyles.footnote1Medium;
  TextStyle get footnote1Bold => AppTextStyles.footnote1Bold;

  // Body
  TextStyle get bodyRegular => AppTextStyles.bodyRegular;
  TextStyle get bodyMedium => AppTextStyles.bodyMedium;
  TextStyle get bodyBold => AppTextStyles.bodyBold;
  TextStyle get body2Bold => AppTextStyles.body2Bold;

  // Titles
  TextStyle get title3Regular => AppTextStyles.title3Regular;
  TextStyle get title3Bold => AppTextStyles.title3Bold;
  TextStyle get title2Regular => AppTextStyles.title2Regular;
  TextStyle get title2Bold => AppTextStyles.title2Bold;
  TextStyle get title2Medium => AppTextStyles.title2Medium;
  TextStyle get title1Regular => AppTextStyles.title1Regular;
  TextStyle get title1Bold => AppTextStyles.title1Bold;
  TextStyle get largeTitle => AppTextStyles.largeTitle;
}
