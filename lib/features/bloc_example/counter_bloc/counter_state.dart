/// State represents the immutable snapshot of data at any given moment.
/// The UI listens to state changes and rebuilds.
class CounterState {
  final int count;

  const CounterState({this.count = 0});

  CounterState copyWith({int? count}) {
    return CounterState(
      count: count ?? this.count,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState && runtimeType == other.runtimeType && count == other.count;

  @override
  int get hashCode => count.hashCode;
}
