import 'package:flutter/foundation.dart';

/// [CounterNotifier] manages a simple integer count using [ChangeNotifier].
///
/// HOW IT WORKS:
/// 1. Extends [ChangeNotifier] from Flutter foundation.
/// 2. Keeps `_count` private to prevent unmonitored external modifications.
/// 3. Whenever `_count` changes, calls `notifyListeners()`.
/// 4. Any widget listening (via `context.watch` or `Consumer`) rebuilds automatically.
class CounterNotifier extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // Tells subscribers to rebuild
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
