import 'package:flutter/material.dart';
import 'package:healthy_scanner/theme/app_theme.dart';
import 'package:healthy_scanner/theme/theme_extensions.dart';
import 'package:healthy_scanner/component/bottombutton.dart';
import 'package:healthy_scanner/foodcard.dart';

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
            Text('Caption1 Medium', style: context.caption1Medium),
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              child: FoodCard(
                title: '칸쵸',
                category: '과자/초콜릿가공품과자',
                message: '포화지방과 당류가 다소 높고, 땅콩이 포함되어 있어요.',
                imageAsset: 'assets/images/cancho.png',
                warningAsset: 'assets/icons/ic_warning.png',
                onTap: () {
                  // 카드 눌렸을 때 액션 추가: 상세 페이지 등으로 이동
                },
              ),
            ),
            Text(
              'Caption1 Medium',
              style: context.caption1Medium,
            ),
            const SizedBox(height: 12),
            Text('Title2 Medium', style: context.title2Medium),
            const SizedBox(height: 12),
            Text('Footnote1 Medium', style: context.footnote1Medium),
            const SizedBox(height: 12),
            Text('Title3 Regular', style: context.title3Regular),
            const SizedBox(height: 12),
            Text('Caption1 Bold', style: context.caption1Bold),
            const SizedBox(height: 12),
            const Text(
              '직접 지정',
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
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
