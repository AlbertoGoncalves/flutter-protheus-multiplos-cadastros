

import 'package:multiplos_cadastros/src/model/peoplex_model.dart';

enum BrowserPeopleStateStatus { loaded, error }

class BrowserPeopleState {
  final BrowserPeopleStateStatus status;
  final List<PeopleXModel> people;

  BrowserPeopleState({required this.status, required this.people});

  BrowserPeopleState copyWith({
    BrowserPeopleStateStatus? status,
    List<PeopleXModel>? people,
  }) {
    return BrowserPeopleState(
        status: status ?? this.status, people: people ?? this.people);
  }
}
