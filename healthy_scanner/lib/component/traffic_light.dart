import 'package:flutter/material.dart';
import '../theme/app_colors.dart'; // 경로에 맞게 수정하세요

enum TrafficLightState { red, yellow, green }

class TrafficLight extends StatelessWidget {
  final TrafficLightState state;

  const TrafficLight({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLight(AppColors.mainRed, state == TrafficLightState.red),
        const SizedBox(width: 4),
        _buildLight(AppColors.kakaoYellow, state == TrafficLightState.yellow),
        const SizedBox(width: 4),
        _buildLight(AppColors.mainGreen, state == TrafficLightState.green),
      ],
    );
  }

  Widget _buildLight(Color color, bool isActive) {
    final double size = isActive ? 15 : 7;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}