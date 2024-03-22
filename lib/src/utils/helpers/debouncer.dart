import 'dart:async';
import 'dart:ui';

class Debouncer {
  final Duration delay;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    this.action = action;
    _timer?.cancel();
    _timer = Timer(delay, () {
      this.action!();
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
