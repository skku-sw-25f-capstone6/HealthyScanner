import 'package:flutter/widgets.dart';

/// 가운데가 살짝 평평한 아치
class BottomArcClipper extends CustomClipper<Path> {
  BottomArcClipper({
    this.arcHeight = 60, // 중앙이 얼마나 내려오게 할지(px)
    this.flatWidth = 0, // 중앙의 평평한 구간 길이(px) — 0이면 기존 완전 곡선
  });

  final double arcHeight;
  final double flatWidth;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    // 안전 범위 클램프
    final ah = arcHeight.clamp(0, h);
    final fw = flatWidth.clamp(0, w * 0.4);

    final path = Path()..lineTo(0, h - ah);

    if (fw == 0) {
      // 하나의 쿼드 베지어: 중앙 컨트롤만 사용
      path
        ..quadraticBezierTo(w / 2, h + ah, w, h - ah)
        ..lineTo(w, 0)
        ..close();
      return path;
    }

    // 중앙 평평한 구간의 좌우 끝점
    final midL = Offset(w / 2 - fw / 2, h + ah);
    final midR = Offset(w / 2 + fw / 2, h + ah);

    // 컨트롤 포인트를 중앙 y와 동일하게 두면 중앙 접선이 수평
    const t = 0.65; // 곡률(텐션)
    final c1 = Offset(w * 0.25, h + ah * t); // 좌측 베지어 컨트롤
    final c2 = Offset(w * 0.75, h + ah * t); // 우측 베지어 컨트롤

    path
      ..quadraticBezierTo(c1.dx, c1.dy, midL.dx, midL.dy)
      ..lineTo(midR.dx, midR.dy)
      ..quadraticBezierTo(c2.dx, c2.dy, w, h - ah)
      ..lineTo(w, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(BottomArcClipper old) =>
      old.arcHeight != arcHeight || old.flatWidth != flatWidth;
}
