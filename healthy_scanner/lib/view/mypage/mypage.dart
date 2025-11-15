import 'package:flutter/material.dart';

// TODO: 임시 비어있는 마이페이지
class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '마이페이지 화면입니다.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
