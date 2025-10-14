import 'package:flutter/material.dart';
import '../theme/app_colors.dart'; 

class TagChipToggle extends StatefulWidget {
  final String label;
  final bool initialSelected;
  final Function(bool)? onChanged;

  const TagChipToggle({
    super.key,
    required this.label,
    this.initialSelected = false,
    this.onChanged,
  });

  @override
  State<TagChipToggle> createState() => _TagChipToggleState();
}

class _TagChipToggleState extends State<TagChipToggle> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialSelected;
  }

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });
    widget.onChanged?.call(_isSelected);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _isSelected ? AppColors.peachRed : AppColors.staticWhite;
    final textColor =
        _isSelected ? AppColors.mainRed : AppColors.brownGray;

    return GestureDetector(
      onTap: _toggleSelection,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: _isSelected ? Colors.transparent : AppColors.softGray,
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
