import 'package:flutter/material.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/rest_client/rest_client.dart';
import 'package:multiplos_cadastros/src/core/ui/app_nav_global_key.dart';
import 'package:multiplos_cadastros/src/model/company_model.dart';
import 'package:multiplos_cadastros/src/model/user_model.dart';
import 'package:multiplos_cadastros/src/repositories/company_repository.dart';
import 'package:multiplos_cadastros/src/repositories/company_repository_impl.dart';
import 'package:multiplos_cadastros/src/repositories/people/people_repository.dart';
import 'package:multiplos_cadastros/src/repositories/people/people_repository_impl.dart';
import 'package:multiplos_cadastros/src/repositories/user/user_repository.dart';
import 'package:multiplos_cadastros/src/repositories/user/user_repository_impl.dart';
import 'package:multiplos_cadastros/src/services/users_login/user_login_service.dart';
import 'package:multiplos_cadastros/src/services/users_login/user_login_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_providers.g.dart';


@Riverpod(keepAlive: true)
RestClient restClient(RestClientRef ref) => RestClient();

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepositoryImpl(restClient: ref.read(restClientProvider));

@Riverpod(keepAlive: true)
PeopleRepository peopleRepository(PeopleRepositoryRef ref) =>
    PeopleRepositoryImpl(restClient: ref.read(restClientProvider)); 

@Riverpod(keepAlive: true)
UserLoginService userLoginService(UserLoginServiceRef ref) =>
    UserLoginServiceImpl(userRepository: ref.read(userRepositoryProvider));

@Riverpod(keepAlive: true)
Future<UserModel> getMe(GetMeRef ref) async {
  final result = await ref.watch(userRepositoryProvider).me();

  return switch (result) {
    Success(value: final userModel) => userModel,
    Failure(:final exception) => throw exception,
  };
}

@Riverpod(keepAlive: true)
CompanyRepository companyRepository(CompanyRepositoryRef ref) =>
    CompanyRepositoryImpl(restClient: ref.watch(restClientProvider));

@Riverpod(keepAlive: true)
Future<CompanyModel> getMyCompany(GetMyCompanyRef ref) async {
  final userModel = await ref.watch(getMeProvider.future);

  final companyRepository = ref.watch(companyRepositoryProvider);
  final result = await companyRepository.getMyCompany(userModel);

  return switch (result) {
    Success(value: final company) => company,
    Failure(:final exception) => throw exception
  };
}


@riverpod
Future<void> logout(LogoutRef ref) async {
  final sp = await SharedPreferences.getInstance();
  sp.clear();

  // ref.invalidate(getMyCompanyProvider);
  // ref.invalidate(getMeProvider);


  Navigator.of(AppNavGlobalKey.instance.navKey.currentContext!)
      .pushNamedAndRemoveUntil(
    "/",
    (route) => false,
  );
}

