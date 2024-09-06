import 'package:asyncstate/asyncstate.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/providers/application_providers.dart';
import 'package:multiplos_cadastros/src/features/register/people/register_people/people_register_state.dart';
import 'package:multiplos_cadastros/src/model/peoplex_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'people_register_vm.g.dart';

@riverpod
class PeopleRegisterVm extends _$PeopleRegisterVm {
  List<PeopleXModel> listPeople = [];

  @override
    // PeopleRegisterState build() => PeopleRegisterState.initial();

  PeopleRegisterState build() {
    if (listPeople.isEmpty) {
      addNewPeopleItems();
    }
    // state = state.copyWith(status: PeopleRegisterStateStatus.initial);
    return PeopleRegisterState(
        status: PeopleRegisterStateStatus.initial, listPeople: listPeople);
    // return  state = state.copyWith(status: PeopleRegisterStateStatus.initial, listPeople: listPeople);
  }

  void addNewPeopleItems() {
    listPeople.add(PeopleXModel(
        sFILIAL: "",
        sCODE: "",
        sNAME: ""));
  }

  void alterPeopleItems({
    required String filial,
    required String code,
    required String name,
    required int index,
  }) {
    listPeople[index] = PeopleXModel(
        sFILIAL: filial,
        sCODE: code,
        sNAME: name);

    if (listPeople.length == (index + 1)) {
      addNewPeopleItems();
    }
  }

  void removePeopleItems({required int index}) {
    listPeople.removeAt(index);
  }

  Future<void> register(
      {List<PeopleXModel>? listPeople,}) async {
    final peopleRepository = ref.watch(peopleRepositoryProvider);

    final resulRegister =
        await peopleRepository.register(listPeople);

    switch (resulRegister) {
      case Success():
        
        state = state.copyWith(status: PeopleRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: PeopleRegisterStateStatus.error);
    }
  }

  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}