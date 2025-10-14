import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_theme.dart';
import 'package:healthy_scanner/component/bottom_button.dart';
import 'package:healthy_scanner/component/food_card.dart';
import 'package:healthy_scanner/component/tag_chip_toggle.dart';
import 'package:healthy_scanner/component/traffic_light.dart';
import 'package:healthy_scanner/component/scan_mode_button.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      home: const MyHomePage(title: '플러터 기본 데모 앱'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScanMode _scanMode = ScanMode.barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ✅ 성분 카드 테스트
            const Text('🔶 성분 카드 테스트', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              child: FoodCard(
                title: '칸쵸',
                category: '과자/초콜릿가공품',
                message: '포화지방과 당류가 다소 높고, 땅콩이 포함되어 있어요.',
                imageAsset: 'assets/images/cancho.png',
                warningAsset: 'assets/icons/ic_warning.png',
                lightState: TrafficLightState.red,
                onTap: () {
                  // 카드 눌렸을 때 액션 추가: 상세 페이지 등으로 이동
                },
              ),
            ),
            const SizedBox(height: 30),

            // ✅ 질환 칩 버튼 테스트
            const Text('🔹 질환 태그 테스트', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TagChipToggle(label: '고혈압'),
                SizedBox(width: 12),
                TagChipToggle(label: '당뇨병', initialSelected: true),
              ],
            ),

            const SizedBox(height: 40),

            // ✅ 신호등 테스트
            const Text('🔸 신호등 테스트', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            const TrafficLight(state: TrafficLightState.red),
            const SizedBox(height: 12),
            const TrafficLight(state: TrafficLightState.yellow),
            const SizedBox(height: 12),
            const TrafficLight(state: TrafficLightState.green),

            const SizedBox(height: 40),

            // ✅ 스캔 모드 버튼 테스트
            const Text('🔹 스캔 모드 버튼 테스트', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScanModeButton(
                selected: _scanMode,
                onChanged: (m) {
                  setState(() => _scanMode = m);
                },
              ),
            ),

            const SizedBox(height: 12),
            Text(
              '현재 선택: $_scanMode',
              style: context.caption1Medium,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: BottomButton(
          text: '저장하기',
          onPressed: () {
            // 버튼 눌렸을 때 로직
          },
        ),
      ),
    );
  }
}
