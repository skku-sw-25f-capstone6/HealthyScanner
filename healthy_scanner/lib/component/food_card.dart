import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/theme/app_colors.dart';

class FoodCard extends StatelessWidget {
  final String title; // 예: "칸쵸"
  final String category; // 예: "과자/초콜릿가공품"
  final String message; // 예: "포화지방과 당류가..."
  final String imageAsset; // 촬영한 식품 이미지
  final String? warningAsset; // 빨간 경고 아이콘

  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.title,
    required this.category,
    required this.message,
    required this.imageAsset,
    this.warningAsset,
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
                child: Image.asset(
                  imageAsset,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
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
                        SizedBox(
                          width: 25,
                          height: 23,
                          child: Image.asset(
                            'assets/icons/ic_warning.png',
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

                    // 임시 SizedBox 자리에 신호등 컴포넌트 연결 필요
                    const SizedBox(
                      height: 15,
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
}
