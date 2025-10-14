import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';

enum ScanMode { barcode, ingredient, image }

class ScanModeButton extends StatelessWidget {
  final ScanMode selected;
  final ValueChanged<ScanMode> onChanged;

  const ScanModeButton({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ModeButton(
            selected: selected == ScanMode.barcode,
            label: '바코드 스캔',
            icon: Image.asset("assets/icons/ic_scan_1.png",
                width: 20, height: 20, fit: BoxFit.contain),
            onTap: () => onChanged(ScanMode.barcode),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ModeButton(
            selected: selected == ScanMode.ingredient,
            label: '성분표 스캔',
            icon: Image.asset("assets/icons/ic_scan_2.png",
                width: 20, height: 20, fit: BoxFit.contain),
            onTap: () => onChanged(ScanMode.ingredient),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ModeButton(
            selected: selected == ScanMode.image,
            label: '이미지 촬영',
            icon: Image.asset("assets/icons/ic_scan_3.png",
                width: 20, height: 20, fit: BoxFit.contain),
            onTap: () => onChanged(ScanMode.image),
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final bool selected;
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _ModeButton({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: selected ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(height: 4),
                Text(label,
                    style: context.caption2Regular.copyWith(
                      color: AppColors.staticBlack,
                    ),
                    maxLines: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
