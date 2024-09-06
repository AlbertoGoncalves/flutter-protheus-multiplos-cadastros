// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$restClientHash() => r'0ee58f1fd102b2016ed621885f1e8d52ed00da66';

/// See also [restClient].
@ProviderFor(restClient)
final restClientProvider = Provider<RestClient>.internal(
  restClient,
  name: r'restClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$restClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RestClientRef = ProviderRef<RestClient>;
String _$userRepositoryHash() => r'4a324f69804b6738f220b7c48b19aad627021894';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$peopleRepositoryHash() => r'fe14a7cd6ff052250948a5c7ab322bf9c981c836';

/// See also [peopleRepository].
@ProviderFor(peopleRepository)
final peopleRepositoryProvider = Provider<PeopleRepository>.internal(
  peopleRepository,
  name: r'peopleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$peopleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PeopleRepositoryRef = ProviderRef<PeopleRepository>;
String _$userLoginServiceHash() => r'62431221aac8e45888e74928ecf0b5836e72b999';

/// See also [userLoginService].
@ProviderFor(userLoginService)
final userLoginServiceProvider = Provider<UserLoginService>.internal(
  userLoginService,
  name: r'userLoginServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userLoginServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserLoginServiceRef = ProviderRef<UserLoginService>;
String _$getMeHash() => r'835de91f459d1216fe7813de1ce4ffa8c28975d4';

/// See also [getMe].
@ProviderFor(getMe)
final getMeProvider = FutureProvider<UserModel>.internal(
  getMe,
  name: r'getMeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getMeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetMeRef = FutureProviderRef<UserModel>;
String _$companyRepositoryHash() => r'1521ec1fac30cc1424ddfd8a542126c42d2f1553';

/// See also [companyRepository].
@ProviderFor(companyRepository)
final companyRepositoryProvider = Provider<CompanyRepository>.internal(
  companyRepository,
  name: r'companyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompanyRepositoryRef = ProviderRef<CompanyRepository>;
String _$getMyCompanyHash() => r'ebb8ece39740793b1cfa0b8ab3209c82fb43b452';

/// See also [getMyCompany].
@ProviderFor(getMyCompany)
final getMyCompanyProvider = FutureProvider<CompanyModel>.internal(
  getMyCompany,
  name: r'getMyCompanyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getMyCompanyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetMyCompanyRef = FutureProviderRef<CompanyModel>;
String _$logoutHash() => r'6ba219dc1ab80179af7b564e1813cdd6eb0eb0db';

/// See also [logout].
@ProviderFor(logout)
final logoutProvider = AutoDisposeFutureProvider<void>.internal(
  logout,
  name: r'logoutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$logoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LogoutRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
