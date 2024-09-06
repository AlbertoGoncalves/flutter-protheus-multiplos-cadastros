import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:multiplos_cadastros/src/core/exceptions/repository_exception.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/fp/nil.dart';
import 'package:multiplos_cadastros/src/core/rest_client/rest_client.dart';
import 'package:multiplos_cadastros/src/model/peoplex_model.dart';
import 'package:multiplos_cadastros/src/repositories/people/people_repository.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  final RestClient restClient;
  PeopleRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, List<PeopleXModel>>> getPeoples(
    String apiFilter,
    String emp,
    String code,
    String description,
  ) async {
    try {
      final Response(:data) = await restClient.auth
          .get('/ffmpapi01/cad01/$code', queryParameters: {
        'cApiFilter': apiFilter,
        'cZFilial': emp,
        'cDescription': description,
      });

      final List<dynamic> list = data['Cad01'];
      final products = list.map((e) => PeopleXModel.fromMap(e)).toList();
      // print('last Pepople: ${list.last}');
      return Success(products);
    } on DioException catch (e, s) {
      log('Erro ao buscar Cad01', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao buscar Cad01'));
    } on ArgumentError catch (e, s) {
      log('Erro ao converter Cad01 (Invalid Json)', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao buscar Cad01'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> register(
      List<PeopleXModel>? listPeople) async {
    try {

      final datapost = listPeople?.map((e) => e.toJson()).toList();

      final datapost1 = {"Cad01": datapost};
      final Response(:data) = await restClient.auth.post(
          '/ffmpapi01/cad01/',
          data: datapost1,
        );
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir Cad01', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao inserir Cad01'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> alter(
      PeopleXModel? people) async {
    try {

      final datapost = people?.toJson();

      final Response(:data) = await restClient.auth.put(
          '/ffmpapi01/cad01/${people!.sCODE}',
          data: datapost,
        );

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao alterar Cad01', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao alterar Cad01'));
    }
  }

    @override
  Future<Either<RepositoryException, Nil>> delete(
      PeopleXModel? people) async {
    try {
      final datapost = people?.toJson();

      final Response(:data) = await restClient.auth.delete(
          '/ffmpapi01/cad01/',
          data: datapost,
        );

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao deletar Cad01', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao deletar Cad01'));
    }
  }
}
