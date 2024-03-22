import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/state/directus_token_provider.dart';

final directusAuthServiceProvider = Provider((ref) {
  final tokenNotifier = ref.watch(directusTokenProvider.notifier);
  return DirectusAuthService(tokenNotifier);
});
