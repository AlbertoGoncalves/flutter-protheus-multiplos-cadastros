import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiplos_cadastros/src/core/ui/app_icons.dart';
import 'package:multiplos_cadastros/src/core/ui/constants.dart';
import 'package:multiplos_cadastros/src/core/ui/helpers/messages.dart';
import 'package:multiplos_cadastros/src/core/ui/widgets/image_person_type.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/browser_people_vm.dart';
import 'package:multiplos_cadastros/src/model/peoplex_model.dart';

class PeopleTile extends ConsumerWidget {
  final PeopleXModel people;

  const PeopleTile({super.key, required this.people});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorsConstants.grey,
        ),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                people.sCODE.substring(people.sCODE.length - 6),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                 height: 15,
              ),
              const ImagePersonType(peopleType: "0001")
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
              InkWell(
                onTap: () async {
                  await Navigator.of(context)
                      .pushNamed('/register/people/alter', arguments: people);
                },
                child: const Icon(
                  AppIcons.penEdit,
                  size: 25,
                  color: ColorsConstants.brow,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  Messages.showSuccess(
                      'Pessoa excluída com sucesso', context);
                  // await PeopleRegisterVM.delete(id: people.code);
                  ref.invalidate(browserPeopleVmProvider);
                  // ref.invalidate(PeopleRegisterVmProvider);
                },
                child: const Icon(
                  // Icons.barcode_reader,
                  AppIcons.trash,
                  size: 25,
                  color: ColorsConstants.brow,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
