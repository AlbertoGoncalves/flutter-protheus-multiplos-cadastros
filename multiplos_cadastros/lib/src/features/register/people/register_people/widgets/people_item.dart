import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiplos_cadastros/src/core/ui/app_icons.dart';
import 'package:multiplos_cadastros/src/core/ui/constants.dart';
import 'package:multiplos_cadastros/src/core/ui/format_txt.dart';
import 'package:multiplos_cadastros/src/core/ui/helpers/form_helper.dart';
import 'package:multiplos_cadastros/src/core/ui/helpers/messages.dart';
import 'package:multiplos_cadastros/src/core/ui/widgets/image_person_type.dart';
import 'package:multiplos_cadastros/src/features/register/people/register_people/people_register_vm.dart';
import 'package:multiplos_cadastros/src/model/peoplex_model.dart';
import 'package:validatorless/validatorless.dart';

class PeopleItem extends ConsumerStatefulWidget {
  final PeopleXModel? people;
  final int? index;
  final int? lastIndex;
  final bool showAlter;

  const PeopleItem({super.key, this.people, this.index, this.lastIndex})
      : showAlter = false;
  const PeopleItem.alter(
      {super.key, required this.people, this.index, this.lastIndex})
      : showAlter = true;

  @override
  ConsumerState<PeopleItem> createState() => _PeopleItemState();
}

class _PeopleItemState extends ConsumerState<PeopleItem> {
  bool showFormField = false;

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
    final peopleRegisterVM = ref.watch(peopleRegisterVmProvider.notifier);

    final PeopleItem(:showAlter, :people, :index, :lastIndex) = widget;

    final intIndex = index;

    codeEC.text.isEmpty ? codeEC.text = people!.sCODE : codeEC.text;
    nameEC.text.isEmpty ? nameEC.text = people!.sNAME : nameEC.text;

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorsConstants.grey,
        ),
      ),
      child: Column(
        children: [
          Offstage(
            offstage: showFormField,
            child: Form(
              key: formKey,
              child: Column(
                children: [
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
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                    ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Offstage(
                        offstage: showAlter,
                        child:
                            addPeoplescheckButton(peopleRegisterVM, intIndex),
                      ),
                      Offstage(
                        offstage: showAlter,
                        child: removePeoplescheckButton(
                            peopleRegisterVM, intIndex),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !showFormField,
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      people!.sCODE,
                      // people!.sCODE.substring(people.sCODE.length - 6),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ImagePersonType(peopleType: "00001")
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Codigo: ${people.sCODE}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Nome: ${people.sNAME}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    editPeoplesButton(),
                    const SizedBox(
                      height: 5,
                    ),
                    removePeoplescheckButton(peopleRegisterVM, intIndex),
                    const SizedBox(
                      height: 5,
                    ),
                    Offstage(
                        offstage: !((lastIndex! - 1) == intIndex),
                        child: addNewPeoplesButton(
                            context, peopleRegisterVM, intIndex)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  ElevatedButton editPeoplesButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // minimumSize: const Size.fromHeight(30),
        shape: const CircleBorder(),
        backgroundColor: ColorsConstants.brow,
      ),
      onPressed: () async {
        setState(() {
          showFormField = false;
        });
        // await Navigator.of(context).pushNamed(
        //     '/register/register_People',
        //     arguments: People);
      },
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 17,
        child: Icon(
          AppIcons.penEdit,
          size: 25,
          color: ColorsConstants.brow,
        ),
      ),
    );
  }

  ElevatedButton removePeoplescheckButton(
      PeopleRegisterVm peopleRegisterVM, int? intIndex) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // minimumSize: const Size.fromHeight(30),
        shape: const CircleBorder(),
        backgroundColor: ColorsConstants.red,
      ),
      onPressed: () {
        showFormField = true;
        peopleRegisterVM.removePeopleItems(index: intIndex!);
        ref.invalidate(peopleRegisterVmProvider);
      },
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 17,
        child: Icon(
          AppIcons.trash,
          color: ColorsConstants.brow,
        ),
      ),
    );
  }

  ElevatedButton addPeoplescheckButton(
      PeopleRegisterVm peopleRegisterVM, int? intIndex) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // minimumSize: const Size.fromHeight(30),
        shape: const CircleBorder(),
        backgroundColor: ColorsConstants.green,
      ),
      onPressed: () {
        switch (formKey.currentState?.validate()) {
          case false || null:
            Messages.showError(
                'Filtro deve conter pelo menos 3 caracteres', context);
          case true:
            const filial = " ";
            final code = codeEC.text;
            final name = nameEC.text;

            setState(() {
              showFormField = true;
              peopleRegisterVM.alterPeopleItems(
                  filial: filial,
                  code: code,
                  name: name,
                  index: intIndex!);
            });
            ref.invalidate(peopleRegisterVmProvider);
        }
      },
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 17,
        child: Icon(
          // AppIcons.active,
          Icons.check_circle_rounded,
          size: 35,
          color: ColorsConstants.green,
        ),
      ),
    );
  }

  ElevatedButton addNewPeoplesButton(
      BuildContext context, PeopleRegisterVm peopleRegisterVM, int? intIndex) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // minimumSize: const Size.fromHeight(30),
        shape: const CircleBorder(),
        backgroundColor: ColorsConstants.green,
      ),
      onPressed: () {
        setState(() {
          showFormField = true;
          peopleRegisterVM.addNewPeopleItems();
        });
        ref.invalidate(peopleRegisterVmProvider);
      },
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 17,
        child: Icon(
          AppIcons.addEmployee,
          color: ColorsConstants.brow,
        ),
      ),
    );
  }
}
