import 'package:asyncstate/asyncstate.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/providers/application_providers.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/browser_people_state.dart';
import 'package:multiplos_cadastros/src/model/peoplex_model.dart';


import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'browser_people_vm.g.dart';

@riverpod
class BrowserPeopleVm extends _$BrowserPeopleVm {
  String apiFilter = "N";
  String emp = "emp";
  String code = "code";
  String description = "description";

  Future<void> setFilterPeople({
    required String apiFilter,
    required String emp,
    required String code,
    required String description,

  }) async {
    this.apiFilter = apiFilter;
    this.emp = emp;
    this.code = code;
    this.description = description;
  }

  @override
  Future<BrowserPeopleState> build() async {
    final repository = ref.read(peopleRepositoryProvider);

    final peopleResult = await repository.getPeoples(
        apiFilter, emp, code, description);

    // final peopleResult = await repository.getPeople(companyId);

    switch (peopleResult) {
      case Success(value: final peopleData):
        final listPeople = <PeopleXModel>[];
        listPeople.addAll(peopleData);

        return BrowserPeopleState(
            status: BrowserPeopleStateStatus.loaded,
            people: listPeople);
      case Failure():
        return BrowserPeopleState(
            status: BrowserPeopleStateStatus.error,
            people: []);
    }
  }

  Future<BrowserPeopleState> filterPeople({
    required String apiFilter,
    required String code,
    required String description,
    required String emp,
    required String group,
  }) async {
    final repository = ref.read(peopleRepositoryProvider);

    final peopleResult = await repository.getPeoples(
        apiFilter, emp, code, description);

    switch (peopleResult) {
      case Success(value: final peopleData):
        final people = <PeopleXModel>[];
        people.addAll(peopleData);

        return BrowserPeopleState(
            status: BrowserPeopleStateStatus.loaded,
            people: people);
      case Failure():
        return BrowserPeopleState(
            status: BrowserPeopleStateStatus.error,
            people: []);
    }
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}
