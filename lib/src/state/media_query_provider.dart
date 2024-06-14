import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final mediaqueryProvider = ChangeNotifierProvider<MediaQueryNotifier>(
    (ref) => MediaQueryNotifier(ref));

class MediaQueryNotifier extends ChangeNotifier {
  Ref ref;
  MediaQueryNotifier(this.ref) : super() {
    loadTextScalerFromCache();
  }
  double _textScaler = 1.0;
  double get textScaler => _textScaler;
  final String _boxName = 'media_query';

  void setTextScaler(double scaler) {
    _textScaler = scaler;
    cacheTextScale(scaler, _boxName);
    notifyListeners();
  }

  loadTextScalerFromCache() async {
    try {
      _textScaler = (await getCachedTextScale(_boxName))!;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading text scaler: $e");
    }
  }

  Future<double?> getCachedTextScale(String boxName) async {
    debugPrint("getCachedTextScale called for $boxName");
    final box = await Hive.openBox<double>(boxName);
    final textScale = box.get('textScaler', defaultValue: 1.0);
    await box.close();

    return textScale;
  }

  Future<void> cacheTextScale(double textScale, String boxName) async {
    final box = await Hive.openBox<double>(boxName);
    await box.clear(); // Clear existing cache
    box.put('textScaler', textScale);
  }
}
