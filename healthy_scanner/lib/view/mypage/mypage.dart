import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthy_scanner/controller/auth_controller.dart';

// TODO: 임시 비어있는 마이페이지
class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => auth.logout(),
          child: const Text('로그아웃 (테스트용)'),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
