import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

/// [CounterBloc] converts [CounterEvent] into [CounterState].
///
/// HOW IT WORKS:
/// 1. Extends [Bloc<CounterEvent, CounterState>].
/// 2. Registers event handlers using `on<EventName>((event, emit) { ... })`.
/// 3. Emits new immutable state using the `emit(...)` function.
/// 4. Provides predictable state transitions and easy logging/debugging.
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(count: 0)) {
    // Register event handlers
    on<CounterIncrementPressed>((event, emit) {
      emit(state.copyWith(count: state.count + 1));
    });

    on<CounterDecrementPressed>((event, emit) {
      if (state.count > 0) {
        emit(state.copyWith(count: state.count - 1));
      }
    });

    on<CounterResetPressed>((event, emit) {
      emit(state.copyWith(count: 0));
    });
  }
}
