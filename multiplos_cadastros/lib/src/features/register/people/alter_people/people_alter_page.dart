import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiplos_cadastros/src/core/ui/constants.dart';
import 'package:multiplos_cadastros/src/core/ui/format_txt.dart';
import 'package:multiplos_cadastros/src/core/ui/helpers/form_helper.dart';
import 'package:multiplos_cadastros/src/core/ui/helpers/messages.dart';
import 'package:multiplos_cadastros/src/features/register/people/alter_people/people_alter_state.dart';
import 'package:multiplos_cadastros/src/features/register/people/alter_people/people_alter_vm.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/browser_people_vm.dart';
import 'package:multiplos_cadastros/src/features/register/people/register_people/people_register_vm.dart';
import 'package:multiplos_cadastros/src/model/peoplex_model.dart';
import 'package:validatorless/validatorless.dart';

class PeopleAlterPage extends ConsumerStatefulWidget {
  const PeopleAlterPage({super.key});

  @override
  ConsumerState<PeopleAlterPage> createState() => _PeopleAlterPageState();
}

class _PeopleAlterPageState extends ConsumerState<PeopleAlterPage> {
  final formKey = GlobalKey<FormState>();
  final codeEC = TextEditingController();
  final nameEC = TextEditingController();


  @override
  void dispose() {
    codeEC.dispose();
    nameEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PeopleXModel? people;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      people = ModalRoute.of(context)!.settings.arguments as PeopleXModel;
      codeEC.text.isEmpty ? codeEC.text = people.sCODE : codeEC.text;
      nameEC.text.isEmpty ? nameEC.text = people.sNAME : nameEC.text;
    }

    final peopleAlterVm = ref.watch(peopleAlterVmProvider.notifier);


    ref.listen(peopleAlterVmProvider.select((state) => state.status),
        (_, status) {
      switch (status) {
        case PeopleAlterStateStatus.initial:
          break;
        case PeopleAlterStateStatus.success:
          Messages.showSuccess('Cadastro alterado com sucesso', context);
          Navigator.of(context).pop();
          ref.invalidate(peopleRegisterVmProvider);
          ref.invalidate(browserPeopleVmProvider);
        case PeopleAlterStateStatus.error:
          Messages.showError('Erro ao alter Cadastro', context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Cadastro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  controller: codeEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Codigo obrigatório'),
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(
                    label: Text("Codigo"),
                    enabled: false,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: nameEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Nome obrigatório'),
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(
                    label: Text("Nome"),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)),
                  onPressed: () async {
                    PeopleXModel peopleAlter = PeopleXModel(
                        sFILIAL: "",
                        sCODE: codeEC.text,
                        sNAME: nameEC.text);
                    await peopleAlterVm.alter(people: peopleAlter);
                    // ref.invalidate(browserPeopleVmProvider);
                  },
                  child: const Text(
                    'Alterar',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: ColorsConstants.red,
                      minimumSize: const Size.fromHeight(56)),
                  onPressed: () async {
                    await peopleAlterVm.delete(people: people);
                    // ref.invalidate(browserPeopleVmProvider);
                  },
                  child: const Text(
                    'Excluir',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
