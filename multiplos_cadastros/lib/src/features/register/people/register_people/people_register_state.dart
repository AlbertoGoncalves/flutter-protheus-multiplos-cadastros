

import 'package:multiplos_cadastros/src/model/peoplex_model.dart';

enum PeopleRegisterStateStatus {
  initial,
  success,
  error,
}

class PeopleRegisterState {
  final PeopleRegisterStateStatus status;
  final List<PeopleXModel>? listPeople;

  PeopleRegisterState({required this.status, this.listPeople});

  PeopleRegisterState copyWith({
    PeopleRegisterStateStatus? status,
    List<PeopleXModel>? listPeople,
  }) {
    return PeopleRegisterState(
        status: status ?? this.status,
        listPeople: listPeople ?? this.listPeople);
  }
}
