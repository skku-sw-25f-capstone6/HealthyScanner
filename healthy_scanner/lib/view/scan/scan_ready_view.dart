import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/component/round_icon_button.dart';
import 'package:healthy_scanner/component/guide_pill.dart';
import 'package:healthy_scanner/component/shutter_button.dart';

// TODO: StatelessWidget으로 바꾸고, Get으로 상태 관리
class ScanReadyView extends StatefulWidget {
  const ScanReadyView({
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
  final WidgetBuilder? cameraBuilder;

  @override
  State<ScanReadyView> createState() => _ScanReadyViewState();
}

class _ScanReadyViewState extends State<ScanReadyView> {
  ScanMode _mode = ScanMode.ingredient;

  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _cameraController = controller;
      _initializeControllerFuture = controller.initialize();
      setState(() {});
    } catch (e) {
      debugPrint('카메라 초기화 실패: $e');
    }
  }

  Future<void> _handleShutter() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    setState(() => _isTakingPicture = true);
    try {
      final XFile file = await _cameraController!.takePicture();
      debugPrint('사진 저장 경로: ${file.path}');

      widget.onShutter?.call();
    } catch (e) {
      debugPrint('사진 촬영 실패: $e');
    } finally {
      if (mounted) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // 🔹 여기! build는 State 클래스 안에 있어야 하고
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 카메라 프리뷰 (배경 전체)
          Positioned.fill(
            child: _buildCameraPreview(),
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
                // TODO: 설정된 스캔 모드에 따라 텍스트 변경
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
              ShutterButton(onTap: _handleShutter),
              const SizedBox(height: 35),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (widget.cameraBuilder != null) {
      return widget.cameraBuilder!(context);
    }

    // 카메라 실패시 임시 화면
    if (_initializeControllerFuture == null || _cameraController == null) {
      return const _CameraPlaceholder();
    }

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_cameraController!);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              '카메라를 불러오지 못했어요',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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
