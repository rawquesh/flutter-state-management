import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [CounterRiverpodNotifier] manages integer counter state in Riverpod 3.
///
/// HOW IT WORKS:
/// 1. Extends [Notifier<int>] instead of ChangeNotifier.
/// 2. The initial state is defined in the [build] method.
/// 3. State transitions occur by reassigning `state = ...`.
/// 4. Global provider declaration without BuildContext dependency.
class CounterRiverpodNotifier extends Notifier<int> {
  @override
  int build() {
    return 0; // Initial state
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 0) {
      state--;
    }
  }

  void reset() {
    state = 0;
  }
}

/// Global provider instance.
/// In Riverpod, providers are declared as top-level final variables.
final counterRiverpodProvider =
    NotifierProvider<CounterRiverpodNotifier, int>(CounterRiverpodNotifier.new);
