import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:multiplos_cadastros/src/core/exceptions/repository_exception.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/fp/nil.dart';
import 'package:multiplos_cadastros/src/core/rest_client/rest_client.dart';
import 'package:multiplos_cadastros/src/model/company_model.dart';
import 'package:multiplos_cadastros/src/model/user_model.dart';
import 'package:multiplos_cadastros/src/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final RestClient restClient;

  CompanyRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, CompanyModel>> getMyCompany(
      UserModel userModel) async {
    const groupEmp = '99';
    const group = '01';

    switch (userModel) {
      case UserModelADM():
        final Response(:data) = await restClient.auth.get(
          '/api/tsi/v1/TSIBranches',
          queryParameters: {'companyId': '$groupEmp|$group'},
        );
        return Success(CompanyModel.fromMap(data['branches'][1]));

      case UserModelEmployee():
        final Response(:data) =
            await restClient.auth.get('/company/${userModel.companyId}');
        return Success(CompanyModel.fromMap(data));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> save(
      ({
        String email,
        String company,
        List<String> openingDays,
        List<int> openingHours,
      }) data) async {
    try {
      await restClient.auth.post('/company', data: {
        'user_id': '#userAuthRef',
        'company': data.company,
        'email': data.email,
        'opening_days': data.openingDays,
        'opening_hours': data.openingHours,
      });
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar barbearia', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao registrar barbearia'),
      );
    }
  }
}
