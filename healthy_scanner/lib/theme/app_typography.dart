import 'package:flutter/material.dart';

/// 앱 전역에서 Noto Sans KR 사용
const _fontFamily = 'NotoSansKR';

TextStyle _base(double size, FontWeight weight, double lineHeightPx,
    {double letter = 0}) {
  final style = TextStyle(
    fontFamily: _fontFamily,
    fontSize: size,
    fontWeight: weight,
    height: lineHeightPx / size,
    letterSpacing: letter,
    leadingDistribution: TextLeadingDistribution.even,
  );
  return style;
}

/// 크기, 두께, 줄간격 매핑
class AppTextStyles {
  // Captions
  static final caption4Semibold = _base(8, FontWeight.w600, 14);
  static final caption3Regular = _base(9, FontWeight.w400, 16);
  static final caption2Regular = _base(10, FontWeight.w400, 14);
  static final caption2Medium = _base(10, FontWeight.w500, 12);
  static final caption1Regular = _base(12, FontWeight.w400, 16);
  static final caption1Medium = _base(12, FontWeight.w500, 16);
  static final caption1SemiBold = _base(12, FontWeight.w600, 16);
  static final caption1Bold = _base(12, FontWeight.w700, 16);

  // Footnotes
  static final footnote3SemiBold = _base(15, FontWeight.w600, 18);
  static final footnote2Regular = _base(14, FontWeight.w400, 22);
  static final footnote2Medium = _base(14, FontWeight.w500, 22);
  static final footnote2Bold = _base(14, FontWeight.w700, 20);
  static final footnote1Light = _base(13, FontWeight.w300, 18, letter: -0.08);
  static final footnote1Regular = _base(13, FontWeight.w400, 18, letter: -0.08);
  static final footnote1Medium = _base(13, FontWeight.w500, 18, letter: -0.08);
  static final footnote1Bold = _base(13, FontWeight.w600, 18, letter: -0.08);

  // Body
  static final bodyRegular = _base(16, FontWeight.w400, 22);
  static final bodyMedium = _base(16, FontWeight.w500, 22, letter: -0.41);
  static final bodyBold = _base(16, FontWeight.w700, 22, letter: -0.41);
  static final body2Bold = _base(18, FontWeight.w700, 24); // 행간 24.5px

  // Titles
  static final title3Regular = _base(20, FontWeight.w400, 25, letter: 0.38);
  static final title3Bold = _base(20, FontWeight.w700, 25, letter: 0.38);

  static final title2Regular = _base(24, FontWeight.w400, 28, letter: -0.2);
  static final title2Bold = _base(24, FontWeight.w700, 28, letter: -0.2);
  static final title2Medium = _base(24, FontWeight.w500, 33); // 행간 32.6px

  static final title1Regular = _base(32, FontWeight.w400, 34, letter: 0.36);
  static final title1Bold = _base(32, FontWeight.w700, 34, letter: 0.36);

  static final largeTitle = _base(48, FontWeight.w500, 34, letter: 0);
}

TextTheme buildTextTheme() => TextTheme(
      // 기본 본문 계열
      bodySmall: AppTextStyles.caption1Regular,
      bodyMedium: AppTextStyles.bodyRegular,
      bodyLarge: AppTextStyles.bodyBold,

      // 제목 계열
      titleSmall: AppTextStyles.title3Regular,
      titleMedium: AppTextStyles.title2Regular,
      titleLarge: AppTextStyles.title1Bold,

      // 라벨 / 버튼 계열
      labelSmall: AppTextStyles.caption2Regular,
      labelMedium: AppTextStyles.caption1Medium,
      labelLarge: AppTextStyles.bodyMedium,

      // 디스플레이 (가장 큰 타이틀)
      displaySmall: AppTextStyles.title2Bold,
      displayMedium: AppTextStyles.title1Bold,
      displayLarge: AppTextStyles.largeTitle,
    );
