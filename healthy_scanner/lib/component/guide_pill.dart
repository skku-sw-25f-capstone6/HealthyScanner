import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';

class GuidePill extends StatelessWidget {
  const GuidePill(
    this.text, {
    super.key,
    this.backgroundColor = AppColors.warmGray,
    this.foregroundColor = AppColors.staticBlack,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
    this.radius = 56,
    this.boxShadow,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.textStyle,
  });

  /// 빨간 배경 + 흰 글자
  const GuidePill.red(
    this.text, {
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
    this.radius = 56,
    this.boxShadow,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.textStyle,
  })  : backgroundColor = AppColors.mainRed,
        foregroundColor = Colors.white;

  /// 회색 배경 + 검은 글자
  const GuidePill.gray(
    this.text, {
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
    this.radius = 56,
    this.boxShadow,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.textStyle,
  })  : backgroundColor = AppColors.warmGray,
        foregroundColor = AppColors.staticBlack;

  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;
  final double radius;
  final List<BoxShadow>? boxShadow;
  final int maxLines;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final shadows = boxShadow ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows,
      ),
      child: Center(
        child: Text(
          text,
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
          style: (textStyle ?? context.caption1Medium)
              .copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}
