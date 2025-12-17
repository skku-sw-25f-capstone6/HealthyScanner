import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/theme/app_colors.dart';
import 'package:healthy_scanner/component/traffic_light.dart';

class FoodCard extends StatelessWidget {
  final String title; // 예: "칸쵸"
  final String category; // 예: "과자/초콜릿가공품"
  final String message; // 예: "포화지방과 당류가..."
  final String imageAsset; // 촬영한 식품 이미지
  final String? warningAsset; // 빨간 경고 아이콘
  final TrafficLightState lightState; // 신호등 상태

  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.title,
    required this.category,
    required this.message,
    required this.imageAsset,
    this.warningAsset,
    this.lightState = TrafficLightState.green,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000), // 25% black
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽 식품 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildFoodImage(),
              ),
              const SizedBox(width: 12),

              // 가운데 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // 식품명
                        Expanded(
                          child: Text(
                            title,
                            style: context.bodyMedium.copyWith(
                              color: AppColors.staticBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // 경고 아이콘
                        if (warningAsset != null)
                          SizedBox(
                            width: 25,
                            height: 23,
                            child: Image.asset(
                              warningAsset!,
                              width: 25,
                              height: 23,
                            ),
                          ),
                      ],
                    ),

                    // 카테고리
                    Text(
                      category,
                      style: context.caption2Regular.copyWith(
                        color: AppColors.stoneGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 17),

                    // 신호등
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TrafficLight(state: lightState),
                        const Spacer()
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    // 분석 메시지
                    Text(
                      message,
                      style: context.caption2Regular.copyWith(
                        color: AppColors.mainRed,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),
                  ],
                ),
              ),

              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodImage() {
    final path = imageAsset.trim();

    if (path.isEmpty) {
      return Container(
        width: 110,
        height: 110,
        color: AppColors.stoneGray.withValues(alpha: 0.2),
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported),
      );
    }

    final isNetwork = path.startsWith('http://') ||
        path.startsWith('https://') ||
        path.startsWith('/static/') ||
        path.startsWith('static/');

    if (isNetwork) {
      final normalizedPath = path.startsWith('static/') ? '/$path' : path;
      final url = normalizedPath.startsWith('/static/')
          ? 'https://healthy-scanner.com$normalizedPath'
          : normalizedPath;

      return Image.network(
        url,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 110,
          height: 110,
          color: AppColors.stoneGray.withValues(alpha: 0.2),
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      );
    }

    return Image.asset(
      path,
      width: 110,
      height: 110,
      fit: BoxFit.cover,
    );
  }
}
