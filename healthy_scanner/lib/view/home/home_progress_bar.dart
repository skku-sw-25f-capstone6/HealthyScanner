// home_progress_bar.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

class SemiCircularProgress extends StatelessWidget {
  const SemiCircularProgress({
    super.key,
    required this.value, // 0.0 ~ 1.0
    this.thickness = 18.0,
    this.size = 220.0,
    this.offsetY = 28.0, // 반원을 아래로 내리는 정도 (px)
    this.bgColor = const Color(0x66FFFFFF),
    this.fgColor = Colors.white,
  });

  final double value;
  final double thickness;
  final double size;
  final double offsetY;
  final Color bgColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      // 높이를 넉넉히 주고, painter가 offsetY만큼 아래로 그리게 함
      height: size * 0.70, // 필요 시 0.65~0.75 사이에서 미세조정
      child: CustomPaint(
        painter: _SemiCircularPainter(
          value: value.clamp(0.0, 1.0),
          thickness: thickness,
          bgColor: bgColor,
          fgColor: fgColor,
          offsetY: offsetY,
        ),
      ),
    );
  }
}

class _SemiCircularPainter extends CustomPainter {
  _SemiCircularPainter({
    required this.value,
    required this.thickness,
    required this.bgColor,
    required this.fgColor,
    required this.offsetY,
  });

  final double value;
  final double thickness;
  final Color bgColor;
  final Color fgColor;
  final double offsetY;

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = math.min(size.width, size.height * 2);

    // 반원의 원(rect)을 아래로 내리기 위한 오프셋
    final dy = offsetY.clamp(0, size.height); // 안전한 범위로 클램프
    final rect = Rect.fromLTWH(
      (size.width - diameter) / 2,
      size.height - diameter + dy,
      diameter,
      diameter,
    );

    const startAngle = math.pi;
    const sweepFull = math.pi;

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = fgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepFull, false, bgPaint);
    canvas.drawArc(rect, startAngle, sweepFull * value, false, fgPaint);
  }

  @override
  bool shouldRepaint(_SemiCircularPainter old) =>
      old.value != value ||
      old.thickness != thickness ||
      old.bgColor != bgColor ||
      old.fgColor != fgColor ||
      old.offsetY != offsetY;
}
