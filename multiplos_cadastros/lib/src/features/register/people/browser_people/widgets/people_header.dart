import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiplos_cadastros/src/core/providers/application_providers.dart';
import 'package:multiplos_cadastros/src/core/ui/app_icons.dart';
import 'package:multiplos_cadastros/src/core/ui/constants.dart';
import 'package:multiplos_cadastros/src/core/ui/format_txt.dart';
import 'package:multiplos_cadastros/src/core/ui/helpers/form_helper.dart';
import 'package:multiplos_cadastros/src/core/ui/helpers/messages.dart';
import 'package:multiplos_cadastros/src/core/ui/widgets/app_loader.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/browser_people_vm.dart';
import 'package:validatorless/validatorless.dart';

class PeopleHeader extends ConsumerWidget {
  final bool showFilter;
  final String textHeader;
  final String textFilter;

  // OPÇÃO 01 CHAMANDO UM Widget com comportamento diferntes
  const PeopleHeader({super.key, required this.textHeader, required this.textFilter})
      : showFilter = true;
  const PeopleHeader.withoutFilter(
      {super.key, required this.textHeader, required this.textFilter})
      : showFilter = false;

  // OPÇÃO 02 CHAMANDO UM Widget com comportamento diferntes
  // const PeopleHeader({super.key, this.showFilter = true}) ;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(getMyCompanyProvider);
    
    final browserPeopleState =
        ref.watch(browserPeopleVmProvider.notifier);
    final formKey = GlobalKey<FormState>();
    final filterEC = TextEditingController();

    // filterEC.dispose();

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        color: Colors.black,
        image: DecorationImage(
            image: AssetImage(
              ImageConstants.backgroundChair,
            ),
            fit: BoxFit.cover,
            opacity: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          company.maybeWhen(
            data: (companyData) {
              return Row(
                children: [
                  Offstage(
                    offstage: !showFilter,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_circle_left_outlined,
                        color: ColorsConstants.brow,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      '${companyData.company} - ${companyData.id}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(logoutProvider.future).asyncLoader();
                    },
                    icon: const Icon(
                      AppIcons.exit,
                      color: ColorsConstants.brow,
                      size: 32,
                    ),
                  ),
                ],
              );
            },
            orElse: () {
              return const Center(
                child: AppLoader(),
              );
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            textHeader,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Offstage(
            offstage: !showFilter,
            child: const SizedBox(
              height: 24,
            ),
          ),
          Offstage(
            offstage: !showFilter,
            child: Form(
              key: formKey,
              child: TextFormField(
                inputFormatters: [UpperCaseTextFormatter(),],
                controller: filterEC,
                validator: Validatorless.multiple([
                  // Validatorless.required(
                  //     'Digite o Codigo do produto ou descrição para pesquisar'),
                  Validatorless.min(2, ''),
                ]),
                onTapOutside: (_) => context.unfocus(),
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  label: Text(
                    textFilter,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: IconButton(
                      onPressed: () {
                        switch (formKey.currentState?.validate()) {
                          case false || null:
                            Messages.showError(
                                'Filtro deve conter pelo menos 2 caracteres',
                                context);
                          case true:
                            final code = filterEC.text.toUpperCase();

                            if (code.isEmpty) {
                              browserPeopleState
                                  .setFilterPeople(
                                apiFilter: "N",
                                emp: "",
                                code: "code",
                                description: "code",
                              );
                            } else {
                              browserPeopleState
                                  .setFilterPeople(
                                apiFilter: "S",
                                emp: "",
                                code: code,
                                description: code
                              );
                            }

                            ref.invalidate(browserPeopleVmProvider);
                        }
                      },
                      icon: const Icon(
                        AppIcons.search,
                        color: Color.fromARGB(255, 15, 14, 10),
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
