// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pzdeals/src/state/directus_auth_service.dart';

// class DirectusTokenInterceptor extends Interceptor {
//   DirectusTokenInterceptor();

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     final authService = ProviderContainer().read(directusAuthServiceProvider);

//     debugPrint("Token interceptor called ${authService.getAccessToken()}");

//     if (authService.isTokenValid()) {
//       debugPrint("Token is valid");
//       if (authService.isTokenExpired()) {
//         debugPrint("Token is expired");
//         try {
//           debugPrint("Attempting to refresh token");
//           final token = await authService.refreshTokens();
//           options.headers['Authorization'] = 'Bearer $token';
//         } catch (e) {
//           debugPrint('Token refresh failed: $e');
//         }
//       } else {
//         options.headers['Authorization'] =
//             'Bearer ${authService.getAccessToken()}';
//       }
//     } else {
//       debugPrint("Token is invalid, attempting to login");
//       // try {
//       //   await authService.login();
//       //   final token = authService.getAccessToken();
//       //   options.headers['Authorization'] = 'Bearer $token';
//       // } catch (e) {
//       //   debugPrint('Token login failed: $e');
//       // }
//     }

//     handler.next(options);
//   }
// }
