import 'package:flutter_riverpod/flutter_riverpod.dart';

final layoutTypeProvider = StateProvider<String>((ref) {
  return 'Grid';
});
