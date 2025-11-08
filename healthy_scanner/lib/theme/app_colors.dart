import 'package:flutter/material.dart';

class AppColors {
  // Neutral
  static const staticWhite = Color(0xFFFFFFFF);
  static const warmGray = Color(0xFFF2F0EF);
  static const softGray = Color(0xFFE8E4E2);
  static const cloudGray = Color(0xFFC7B0AB);
  static const brownGray = Color(0xFF96867E);
  static const stoneGray = Color(0xFF969291);
  static const charcoleGray = Color(0xFF423A36);
  static const staticBlack = Color(0xFF141110);
  static const backgroundGray = Color(0xFFF5F3F3);

  // Red
  static const darkRed = Color(0xFF993522);
  static const brickRed = Color(0xFFB23E27);
  static const terraRed = Color(0xFFCC472D);
  static const orangeRed = Color(0xFFE55032);
  static const mainRed = Color(0xFFFF5938);
  static const salmonRed = Color(0xFFFFAA99);
  static const peachRed = Color(0xFFFFD4CC);
  static const kakaoYellow = Color(0xFFFEE500);
  static const naverGreen = Color(0xFF03C75A);
  static const mainGreen = Color(0xFF86CE02);

  static const linearGray = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.93, 1.0],
    colors: [
      Color(0xFFF2ECEA), // 위쪽 (어두운 회색)
      Color(0xFFF6F2F1), // 중간 (밝은 회색)
      Color(0xFFFFFFFF), // 아래쪽 (흰색)
    ],
  );

  static const linearRed = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFFFF5938),
      Color(0xFFEA5233),
    ],
  );
}
