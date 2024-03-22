import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';

@immutable
class DirectusToken {
  const DirectusToken(this.refreshToken, this.accessToken, this.expiresIn,
      this.tokenReceivedDateTime);

  final String refreshToken;
  final String accessToken;
  final int expiresIn;
  final DateTime tokenReceivedDateTime;

  DirectusToken copyWith({
    String? refreshToken,
    String? accessToken,
    int? expiresIn,
    DateTime? tokenReceivedDateTime,
  }) {
    return DirectusToken(
      refreshToken ?? this.refreshToken,
      accessToken ?? this.accessToken,
      expiresIn ?? this.expiresIn,
      tokenReceivedDateTime ?? this.tokenReceivedDateTime,
    );
  }
}

class DirectusTokenNotifier extends StateNotifier<List<DirectusToken>> {
  DirectusTokenNotifier() : super([]);

  void updateTokens(DirectusToken tokens) {
    state = [...state, tokens];
  }

  DirectusToken? getTokens() {
    if (state.isNotEmpty) {
      return state.last;
    } else {
      return null;
    }
  }

  void clearTokens() {
    state = [];
  }

  String? getAccessToken() {
    final tokens = getTokens();
    return tokens?.accessToken;
  }

  String? getRefreshToken() {
    final tokens = getTokens();
    return tokens?.refreshToken;
  }

  int? getExpireseIn() {
    final tokens = getTokens();
    return tokens?.expiresIn;
  }
}

final directusTokenProvider =
    StateNotifierProvider<DirectusTokenNotifier, List<DirectusToken>>((ref) {
  return DirectusTokenNotifier();
});

class DirectusAuthService {
  final DirectusTokenNotifier tokenNotifier;

  DirectusAuthService(this.tokenNotifier);

  Future<void> login() async {
    ApiClient apiClient = ApiClient();
    try {
      Response response = await apiClient.dio.post("auth/login",
          data: {
            "email": "app@app.com",
            "password": "@Dm1n@Dm1n",
          },
          options: Options(contentType: Headers.jsonContentType));
      if (response.statusCode == 200) {
        final responseData = response.data["data"];

        final token = DirectusToken(
            responseData["refresh_token"],
            responseData["access_token"],
            responseData["expires"],
            DateTime.now());

        tokenNotifier.updateTokens(token);
      } else {
        throw Exception(
            '${response.statusCode} Failed to fetch directus tokens info');
      }
    } catch (e) {
      debugPrint('Error fetching person info: $e');
      // throw Exception('Failed to fetch directus login info');
    }
  }

  Future<String> refreshTokens() async {
    ApiClient apiClient = ApiClient();
    try {
      Response response = await apiClient.dio.post("auth/refresh",
          data: {"refresh_token": tokenNotifier.getRefreshToken()});
      if (response.statusCode == 200) {
        final responseData = response.data["data"];

        final token = DirectusToken(
            responseData["refresh_token"],
            responseData["access_token"],
            responseData["expires"],
            DateTime.now());

        tokenNotifier.updateTokens(token);
        return responseData["access_token"];
      } else {
        throw Exception(
            '${response.statusCode} Failed to refresh directus tokens info');
      }
    } catch (e) {
      debugPrint('Error fetching person info: $e');
      throw Exception('Failed to fetch person info');
    }
  }

  bool isTokenExpired() {
    final token = tokenNotifier.getTokens();
    if (token == null) {
      return true;
    }

    final currentTime = DateTime.now();
    final expirationTime = token.tokenReceivedDateTime
        .add(Duration(milliseconds: token.expiresIn));

    return expirationTime.isBefore(currentTime);
  }

  bool isTokenValid() {
    return tokenNotifier.getTokens() != null;
  }

  String? getAccessToken() {
    return tokenNotifier.getAccessToken();
  }
}
