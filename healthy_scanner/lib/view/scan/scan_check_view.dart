import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/component/round_icon_button.dart';
import 'package:healthy_scanner/component/bottom_button.dart';
import 'package:healthy_scanner/component/guide_pill.dart';

// TODO: StatelessWidget으로 바꾸고, Get으로 상태 관리
class ScanCheckView extends StatefulWidget {
  const ScanCheckView({
    super.key,
    this.onClose,
    this.onShutter,
    this.onModeChanged,
    this.cameraBuilder,
  });

  final VoidCallback? onClose;
  final VoidCallback? onShutter;
  final ValueChanged<ScanMode>? onModeChanged;

  /// 실제 카메라 프리뷰를 주입
  /// 예: cameraBuilder: (context) => CameraPreview(controller)
  final WidgetBuilder? cameraBuilder;

  @override
  State<ScanCheckView> createState() => _ScanCheckViewState();
}

class _ScanCheckViewState extends State<ScanCheckView> {
  // TODO: 촬영 시 설정한 ScanMode가 그대로 유지되도록
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
              // 상단 좌측 아이콘
              const SizedBox(height: 57),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(width: 20),
                RoundIconButton(
                  assetPath: 'assets/icons/ic_x.png',
                  onTap:
                      widget.onClose ?? () => Navigator.of(context).maybePop(),
                ),
              ]),

              const Spacer(),

              // 가이드 텍스트
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: GuidePill.gray('촬영된 사진을 확인해 주세요'),
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

              // 하단 분석하기 버튼
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
}

/// 카메라 연결 전 임시 화면
class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(color: AppColors.peachRed);
  }
}
