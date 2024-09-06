import 'package:asyncstate/asyncstate.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/providers/application_providers.dart';
import 'package:multiplos_cadastros/src/features/register/people/alter_people/people_alter_state.dart';
import 'package:multiplos_cadastros/src/model/peoplex_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'people_alter_vm.g.dart';

@riverpod
class PeopleAlterVm extends _$PeopleAlterVm {
  @override
  PeopleAlterState build() => PeopleAlterState.initial();

  Future<void> alter({
    PeopleXModel? people,
  }) async {
    final peopleRepository = ref.watch(peopleRepositoryProvider);

    final resulRegister = await peopleRepository.alter(people);

    switch (resulRegister) {
      case Success():
        state = state.copyWith(status: PeopleAlterStateStatus.success);
      case Failure():
        state = state.copyWith(status: PeopleAlterStateStatus.error);
    }
  }

  Future<void> delete({    PeopleXModel? people,
  }) async {
    final peopleRepository = ref.watch(peopleRepositoryProvider);

    final resulRegister = await peopleRepository.delete(people);

    switch (resulRegister) {
      case Success():
        state = state.copyWith(status: PeopleAlterStateStatus.success);
      case Failure():
        state = state.copyWith(status: PeopleAlterStateStatus.error);
    }
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}