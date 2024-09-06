import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiplos_cadastros/src/core/ui/helpers/messages.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/browser_people_vm.dart';
import 'package:multiplos_cadastros/src/features/register/people/register_people/people_register_state.dart';
import 'package:multiplos_cadastros/src/features/register/people/register_people/people_register_vm.dart';

import 'widgets/people_item.dart';

class PeopleRegisterPage extends ConsumerStatefulWidget {
  const PeopleRegisterPage({super.key});

  @override
  ConsumerState<PeopleRegisterPage> createState() => _PeopleRegisterPageState();
}

class _PeopleRegisterPageState extends ConsumerState<PeopleRegisterPage> {
  var registerOrAlter = true;

  @override
  Widget build(BuildContext context) {

    final peopleRegisterVM = ref.watch(peopleRegisterVmProvider.notifier);

    ref.listen(peopleRegisterVmProvider.select((state) => state.status),
        (_, status) {
      switch (status) {
        case PeopleRegisterStateStatus.initial:
          break;
        case PeopleRegisterStateStatus.success:
          if (registerOrAlter) {
            Messages.showSuccess('Pessoa cadastrada com sucesso', context);
          } else {
            Messages.showSuccess('Pessoa alterada com sucesso', context);
          }
          Navigator.of(context).pop();
          ref.invalidate(browserPeopleVmProvider);
          ref.invalidate(peopleRegisterVmProvider);

        case PeopleRegisterStateStatus.error:
          Messages.showError('Erro ao registrar Pessoa', context);
      }
    });

    final peopleRegisterState = ref.watch(peopleRegisterVmProvider);
    final listPeople = peopleRegisterState.listPeople;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Pessoas')),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: PeopleItem(
                    people: listPeople?[index],
                    index: index,
                    lastIndex: listPeople?.length),
              ),
              childCount: listPeople?.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56)),
                onPressed: () async {
                  await peopleRegisterVM.register(listPeople: listPeople);
                  // ref.invalidate(browserPeopleVmProvider);
                },
                child: const Text(
                  'Incluir ',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
