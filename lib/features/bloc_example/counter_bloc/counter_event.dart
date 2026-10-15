/// Events are dispatched to BLoC to represent user interactions or system triggers.
/// In standard BLoC, the UI never changes state directly—it only dispatches Events.
sealed class CounterEvent {
  const CounterEvent();
}

class CounterIncrementPressed extends CounterEvent {
  const CounterIncrementPressed();
}

class CounterDecrementPressed extends CounterEvent {
  const CounterDecrementPressed();
}

class CounterResetPressed extends CounterEvent {
  const CounterResetPressed();
}
