
enum PeopleAlterStateStatus {
  initial,
  success,
  error,
}

class PeopleAlterState {
  final PeopleAlterStateStatus status;

  PeopleAlterState({required this.status});

  PeopleAlterState.initial(): this(status: PeopleAlterStateStatus.initial);

  PeopleAlterState copyWith({
    PeopleAlterStateStatus? status,
  }) {
    return PeopleAlterState(
        status: status ?? this.status);
  }
}
