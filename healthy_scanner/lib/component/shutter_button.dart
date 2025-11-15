import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';

class ShutterButton extends StatelessWidget {
  const ShutterButton({
    super.key,
    this.onTap,
    this.size = 98,
  });

  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: AppColors.linearRed,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.staticWhite.withValues(alpha: 0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/ic_camera.png',
                width: 38,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
