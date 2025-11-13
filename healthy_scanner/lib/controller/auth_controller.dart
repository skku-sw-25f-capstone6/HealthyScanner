import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  // --------------------------
  // 카카오 로그인 함수
  // --------------------------
  Future<void> loginWithKakao() async {
    try {
      isLoading.value = true;

      // 1) 카카오톡 설치 여부 체크
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token;

      if (isInstalled) {
        // 카카오톡 실행 → 로그인
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        // 카카오계정으로 웹 로그인
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      String kakaoAccessToken = token.accessToken;

      // 2) 서버에 로그인 요청
      await _requestLoginToServer(
        provider: "kakao",
        accessToken: kakaoAccessToken,
      );
    } catch (e) {
      print("❌ 카카오 로그인 실패: $e");
      Get.snackbar("로그인 실패", "카카오 로그인 중 오류가 발생했습니다.");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _requestLoginToServer({
    required String provider,
    required String accessToken,
  }) async {
    // TODO: 나중에 여기서 서버에 로그인 요청 보낼 거야 낄낄.
    // 일단 1단계에서는 에러 안 나게만 막아둬 보자고 뾰로롱.
    print('[_requestLoginToServer] provider=$provider, accessToken=$accessToken');
  }
}
