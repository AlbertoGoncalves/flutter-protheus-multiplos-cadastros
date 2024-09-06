import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiplos_cadastros/src/core/providers/application_providers.dart';
import 'package:multiplos_cadastros/src/core/ui/app_icons.dart';
import 'package:multiplos_cadastros/src/core/ui/constants.dart';
import 'package:multiplos_cadastros/src/core/ui/widgets/app_loader.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/browser_people_state.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/browser_people_vm.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/widgets/people_header.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/widgets/people_tile.dart';

class BrowserPeoplePage extends ConsumerWidget {
  const BrowserPeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserPeopleState = ref.watch(browserPeopleVmProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ColorsConstants.brow,
        onPressed: () async {
          await Navigator.of(context).pushNamed('/register/people/register');
          ref.invalidate(getMeProvider);
          ref.invalidate(browserPeopleVmProvider);
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(
            AppIcons.addEmployee,
            color: ColorsConstants.brow,
          ),
        ),
      ),
      body: browserPeopleState.when(
        data: (BrowserPeopleState data) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: PeopleHeader(
                  textHeader: 'Cad 01',
                  textFilter: 'Buscar Cad 01',
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PeopleTile(people: data.people[index]),
                  childCount: data.people.length,
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log('Erro ao carregar Movimentos internos',
              error: error, stackTrace: stackTrace);
          return const Center(
            child: Text('Erro ao carregar pagina'),
          );
        },
        loading: () {
          return const AppLoader();
        },
      ),
    );
  }
}
