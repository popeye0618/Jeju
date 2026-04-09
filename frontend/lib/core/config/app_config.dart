import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfig {
  AppConfig._();

  // ── 환경별 Base URL ─────────────────────────────────
  // 개발: 로컬 PC IP 주소 (에뮬레이터에서 localhost 대신 사용)
  // Android 에뮬레이터에서 호스트 PC는 10.0.2.2
  static const String _devBaseUrl = 'http://10.0.2.2:8080/api/v1';
  static const String _prodBaseUrl = 'https://your-production-domain.com/api/v1';

  static String get baseUrl => kDebugMode ? _devBaseUrl : _prodBaseUrl;

  // ── 카카오 네이티브 앱 키 ─────────────────────────────
  static String get kakaoNativeAppKey =>
      dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';

  // ── 네이버 지도 Client ID ────────────────────────────
  // https://console.ncloud.com 에서 발급 (Maps 서비스)
  static const String naverMapClientId = 'YOUR_NAVER_MAP_CLIENT_ID';

  // ── 보안 저장소 ──────────────────────────────────────
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ── 토큰 관리 ─────────────────────────────────────────
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
