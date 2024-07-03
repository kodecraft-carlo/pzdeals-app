import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final comingSoonProvider = ChangeNotifierProvider<ComingSoonNotifier>((ref) {
  return ComingSoonNotifier();
});

class ComingSoonNotifier extends ChangeNotifier {
  bool _disposed = false; // Step 1: Track the disposal state
  SharedPreferences? prefs;
  bool _notifyStatusWishList = false;
  bool get notifyStatusWishLisht => _notifyStatusWishList;

  bool _notifyStatusFlights = false;
  bool get notifyStatusFlights => _notifyStatusFlights;
  @override
  void dispose() {
    _disposed = true; // Set the disposed flag to true when disposed
    super.dispose();
  }

  ComingSoonNotifier() {
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    _notifyStatusWishList = prefs!.getBool('notifyStatusWishList') ?? false;
    _notifyStatusFlights = prefs!.getBool('notifyStatusFlights') ?? false;
  }

  void setNotifyStatus(bool value, String key) {
    if (key == 'wish_list') {
      prefs!.setBool('notifyStatusWishList', value);
      _notifyStatusWishList = value;
    }
    if (key == 'flights') {
      prefs!.setBool('notifyStatusFlights', value);
      _notifyStatusFlights = value;
    }

    notifyListeners();
  }
}
