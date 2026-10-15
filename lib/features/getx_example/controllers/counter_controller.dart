import 'package:get/get.dart';

/// [CounterController] demonstrates GetX state management.
///
/// GetX offers two approaches:
/// 1. Reactive State Management (using `.obs` and [Rx] types with [Obx]):
///    Automatically tracks which variables are accessed inside [Obx] and updates
///    only the relevant widgets when the value changes.
/// 2. Simple State Management (using standard variables with `update()` and [GetBuilder]):
///    Extremely lightweight with minimal RAM usage.
class CounterController extends GetxController {
  // 1. Reactive variable using .obs
  final RxInt count = 0.obs;

  // 2. Non-reactive variable for GetBuilder demonstration
  int manualCount = 0;

  void increment() {
    count.value++; // Automatically triggers Obx widgets
  }

  void decrement() {
    if (count.value > 0) {
      count.value--;
    }
  }

  void reset() {
    count.value = 0;
  }

  void incrementManual() {
    manualCount++;
    update(); // Manually notifies GetBuilder widgets
  }
}
