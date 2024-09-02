import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String layoutTypeKey = 'layoutType';

Future<String> loadLayoutType() async {
  final prefs = await SharedPreferences.getInstance();
  debugPrint('loadLayoutType: ${prefs.getString(layoutTypeKey) ?? "Grid"}');
  return prefs.getString(layoutTypeKey) ?? 'Grid';
}

Future<void> saveLayoutType(String layoutType) async {
  final prefs = await SharedPreferences.getInstance();
  debugPrint('saveLayoutType: $layoutType');
  await prefs.setString(layoutTypeKey, layoutType);
}

class LayoutTypeNotifier extends StateNotifier<String> {
  LayoutTypeNotifier() : super('Grid') {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    state = await loadLayoutType();
    debugPrint('loadInitialState: $state');
  }

  void setLayoutType(String layoutType) {
    state = layoutType;
    debugPrint('setLayoutType: $layoutType');
    saveLayoutType(layoutType);
  }
}

final layoutTypeProvider =
    StateNotifierProvider<LayoutTypeNotifier, String>((ref) {
  return LayoutTypeNotifier();
});
