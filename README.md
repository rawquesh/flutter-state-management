# Flutter State Management Lab 🚀

A comprehensive, clean, and interactive educational project built to help you learn and compare Flutter's four most popular state management packages side-by-side:

1. **[Provider](https://pub.dev/packages/provider)** (`ChangeNotifierProvider`, `context.watch`, `context.read`, `Consumer`)
2. **[Riverpod 3](https://pub.dev/packages/flutter_riverpod)** (`NotifierProvider`, `ConsumerWidget`, `ref.watch`, `ref.read`, compile-time safety)
3. **[BLoC & Cubit](https://pub.dev/packages/flutter_bloc)** (`BlocProvider`, `BlocBuilder`, Event -> State stream, `emit()`)
4. **[GetX](https://pub.dev/packages/get)** (`.obs`, `Rx`, `Obx`, `GetBuilder`, context-free dependency injection)

Each package implements the exact same dual-state scenarios:
- **Counter State**: Primitive state increment, decrement, and reset.
- **Task List State**: Collection state (adding, toggling completion, deleting items).

---

## 📁 Directory Structure

```text
lib/
├── main.dart                                # Root entry point (ProviderScope & GetMaterialApp setup)
├── shared/                                  # Shared models and reusable UI widgets
│   ├── models/
│   │   └── task_item.dart                   # Immutable TaskItem model with copyWith
│   └── widgets/
│       └── concept_card.dart                # Visual notes card for state management concepts
│
└── features/
    ├── home/
    │   └── home_screen.dart                 # Dashboard with navigation cards & comparison cheat-sheet
    │
    ├── provider_example/                    # 1. PROVIDER IMPLEMENTATION
    │   ├── state/
    │   │   ├── counter_notifier.dart        # ChangeNotifier holding primitive counter state
    │   │   └── task_notifier.dart           # ChangeNotifier holding task list with notifyListeners()
    │   └── views/
    │       └── provider_view.dart           # MultiProvider, context.watch, context.read, Consumer
    │
    ├── riverpod_example/                    # 2. RIVERPOD IMPLEMENTATION
    │   ├── providers/
    │   │   ├── counter_riverpod.dart        # Notifier<int> and top-level NotifierProvider
    │   │   └── task_riverpod.dart           # Notifier<List<TaskItem>> + computed Provider<int>
    │   └── views/
    │       └── riverpod_view.dart           # ConsumerStatefulWidget, ref.watch, ref.read
    │
    ├── bloc_example/                        # 3. BLOC & CUBIT IMPLEMENTATION
    │   ├── counter_bloc/                    # Event-driven BLoC pattern
    │   │   ├── counter_event.dart           # CounterIncrementPressed, CounterDecrementPressed, etc.
    │   │   ├── counter_state.dart           # Immutable CounterState class
    │   │   └── counter_bloc.dart            # on<Event>((event, emit) => ...)
    │   ├── task_cubit/                      # Cubit pattern (simpler, function-driven)
    │   │   └── task_cubit.dart              # TaskCubit extends Cubit<List<TaskItem>>
    │   └── views/
    │       └── bloc_view.dart               # MultiBlocProvider, BlocBuilder, context.read<Bloc>().add()
    │
    └── getx_example/                        # 4. GETX IMPLEMENTATION
        ├── controllers/
        │   ├── counter_controller.dart      # Reactive (.obs) & Simple (update() / GetBuilder)
        │   └── task_controller.dart         # RxList<TaskItem> observable list
        └── views/
            └── getx_view.dart               # Get.put(), Obx(() => ...), GetBuilder, Get.snackbar
```

---

## 🧠 Architectural Comparison

| Dimension | Provider | Riverpod 3 | BLoC & Cubit | GetX |
| :--- | :--- | :--- | :--- | :--- |
| **Mental Model** | `ChangeNotifier` + `InheritedWidget` | Compile-safe functional containers | Unidirectional event/state streams | Reactive streams (`.obs`) & micro-framework |
| **Needs `BuildContext`?** | Yes (`context.watch`, `context.read`) | No (uses `WidgetRef ref`) | Yes for `BlocProvider.of(context)` | No (uses `Get.find()` or controller instances) |
| **UI Rebuild Trigger** | `notifyListeners()` | `state = ...` | `emit(...)` | `.value = ...` or `update()` |
| **Listening in UI** | `context.watch<T>()` or `Consumer<T>` | `ref.watch(provider)` | `BlocBuilder<B, S>` | `Obx(() => ...)` or `GetBuilder` |
| **Action Trigger** | `context.read<T>().action()` | `ref.read(prov.notifier).action()` | `context.read<B>().add(Event)` | `controller.action()` |
| **Boilerplate** | Low to Medium | Low | Medium to High | Minimal |
| **Best Suited For** | Small to Medium projects | Modern apps, clean DI, testability | Enterprise, strict team rules | Rapid prototyping, all-in-one ecosystem |

---

## 🚀 How to Run the Project

1. Ensure dependencies are fetched:
   ```bash
   flutter pub get
   ```
2. Run the application:
   ```bash
   flutter run
   ```
3. Run tests:
   ```bash
   flutter test
   ```
