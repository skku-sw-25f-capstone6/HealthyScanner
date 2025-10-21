import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/component/round_icon_button.dart';
import 'package:healthy_scanner/component/guide_pill.dart';
import 'package:healthy_scanner/component/shutter_button.dart';

class ScanReadyPage extends StatefulWidget {
  const ScanReadyPage({
    super.key,
    this.onClose,
    this.onOpenGallery,
    this.onShutter,
    this.onModeChanged,
    this.cameraBuilder,
  });

  final VoidCallback? onClose;
  final VoidCallback? onOpenGallery;
  final VoidCallback? onShutter;
  final ValueChanged<ScanMode>? onModeChanged;

  /// 실제 카메라 프리뷰를 주입
  /// 예: cameraBuilder: (context) => CameraPreview(controller)
  final WidgetBuilder? cameraBuilder;

  @override
  State<ScanReadyPage> createState() => _ScanReadyPageState();
}

class _ScanReadyPageState extends State<ScanReadyPage> {
  ScanMode _mode = ScanMode.ingredient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 카메라 프리뷰 (배경 전체)
          Positioned.fill(
            child: widget.cameraBuilder?.call(context) ??
                const _CameraPlaceholder(),
          ),

          Column(
            children: [
              // 상단 좌우 아이콘
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundIconButton(
                      assetPath: 'assets/icons/ic_x.png',
                      onTap: widget.onClose ??
                          () => Navigator.of(context).maybePop(),
                    ),
                    RoundIconButton(
                      assetPath: 'assets/icons/ic_image.png',
                      onTap: widget.onOpenGallery,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 가이드 텍스트
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: GuidePill.red('식품 바코드를 프레임 안에 맞춰주세요'),
              ),
              const SizedBox(height: 14),

              // 스캔 모드 선택 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ScanModeButton(
                  selected: _mode,
                  onChanged: (m) {
                    setState(() => _mode = m);
                    widget.onModeChanged?.call(m);
                  },
                ),
              ),

              // 중앙 셔터 버튼
              const SizedBox(height: 14),
              ShutterButton(onTap: widget.onShutter),
              const SizedBox(height: 35),
            ],
          ),
        ],
      ),
    );
  }
}

/// 카메라 연결 전 임시 화면
class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(color: AppColors.peachRed);
  }
}
