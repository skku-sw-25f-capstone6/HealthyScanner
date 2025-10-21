import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.assetPath,
    this.onTap,
    this.opacity = 0.6,
    this.iconSize = 24,
    this.padding = const EdgeInsets.all(13),
  });

  final String assetPath;
  final VoidCallback? onTap;
  final double opacity;
  final double iconSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: opacity),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Image.asset(
            assetPath,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
