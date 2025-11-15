// scan_check_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/component/round_icon_button.dart';
import 'package:healthy_scanner/component/bottom_button.dart';
import 'package:healthy_scanner/component/guide_pill.dart';

class ScanCheckView extends StatefulWidget {
  const ScanCheckView({super.key});

  @override
  State<ScanCheckView> createState() => _ScanCheckViewState();
}

class _ScanCheckViewState extends State<ScanCheckView> {
  late ScanMode _mode;
  String? _imagePath;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>?;

    _imagePath = args?['imagePath'] as String?;
    _mode = args?['mode'] as ScanMode? ?? ScanMode.ingredient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildBackground(),
          ),
          Column(
            children: [
              const SizedBox(height: 57),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  RoundIconButton(
                    assetPath: 'assets/icons/ic_x.png',
                    onTap: () => Get.back(),
                  ),
                ],
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: GuidePill.gray('촬영된 사진을 확인해 주세요'),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ScanModeButton(
                  selected: _mode,
                  onChanged: (m) {
                    setState(() => _mode = m);
                  },
                ),
              ),
              SafeArea(
                minimum: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: BottomButton(
                  text: '분석하기',
                  onPressed: () {
                    // TODO: 분석하기 로직
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (_imagePath != null) {
      return Image.file(
        File(_imagePath!),
        fit: BoxFit.cover,
      );
    }

    return const _CameraPlaceholder();
  }
}

/// 카메라 연결 전 임시 화면
class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/sample_eggs.png',
      fit: BoxFit.cover,
    );
  }
}
