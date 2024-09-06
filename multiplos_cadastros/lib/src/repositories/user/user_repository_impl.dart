import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:multiplos_cadastros/src/core/exceptions/auth_exception.dart';
import 'package:multiplos_cadastros/src/core/exceptions/repository_exception.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/fp/nil.dart';
import 'package:multiplos_cadastros/src/core/rest_client/rest_client.dart';
import 'package:multiplos_cadastros/src/model/user_model.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;
  UserRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<AuthException, List<String>>> login(
      String email, String password) async {
    try {
      final Response(:data) =
          await restClient.unAuth.post('/api/oauth2/v1/token',
              queryParameters: {
            "grant_type": "password",
            "username": email,
            "password": password,
          });
      return Success([data["access_token"],data["refresh_token"]]);
    } on DioException catch (e, s) {
      if (e.response != null) {
        final Response(:statusCode) = e.response!;
        if (statusCode == HttpStatus.forbidden) {
          log('login ou senha inválidos', error: e, stackTrace: s);
          return Failure(AuthUnauthorizedException());
        }
      }
      log('Erro ao realizar login', error: e, stackTrace: s);
      return Failure(
        AuthError(message: 'Erro ao realizar login'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(data: id) = await restClient.auth.get('Users/GetUserId');

      final Response(:data) = await restClient.auth.get(
        '/api/framework/v1/users',
        queryParameters: {
          "id": id['userID'],
        },
      );

      return Success(UserModel.fromMap(data['items'][0]));
    } on DioException catch (e, s) {
      log('Erro ao buscar usuário logado', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao buscar usuário logado'),
      );
    } on ArgumentError catch (e, s) {
      log('Invalid Json', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: e.message),
      );
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
      ({String email, String name, String password}) userData) async {
    try {
      await restClient.unAuth.post('/users', data: {
        'name': userData.name,
        'email': userData.email,
        'password': userData.password,
        'profile': 'ADM'
      });
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar usuário admin', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao registrar usuário admin'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      String companyId) async {
    try {
      final Response(:List data) = await restClient.auth
          .get('/users', queryParameters: {'company_id': companyId});

      final employees = data.map((e) => UserModelEmployee.fromMap(e)).toList();
      return Success(employees);
    } on DioException catch (e, s) {
      log('Erro ao buscar colaboradores', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar colaboradores'));
    } on ArgumentError catch (e, s) {
      log('Erro ao converter colaboradores (Invalid Json)',
          error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar colaboradores'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({List<String> workDays, List<int> workHours}) userModel) async {
    try {
      final userModelResult = await me();

      final String userId;

      switch (userModelResult) {
        case Success(value: UserModel(:var id)):
          userId = id;
        case Failure(:var exception):
          return Failure(exception);
      }

      await restClient.auth.put('/users/$userId', data: {
        'work_days': userModel.workDays,
        'work_hours': userModel.workHours,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir administrador como colaborador',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
          message: 'Erro ao inserir administrador como colaborador'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerEmployee(
      ({
        String companyId,
        String email,
        String name,
        String password,
        List<String> workDays,
        List<int> workHours,
      }) userModel) async {
    try {
      await restClient.auth.post('/users/', data: {
        'name': userModel.name,
        'email': userModel.email,
        'password': userModel.password,
        'company_id': userModel.companyId,
        'profile': 'EMPLOYEE',
        'work_days': userModel.workDays,
        'work_hours': userModel.workHours,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir administrador como colaborador',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
          message: 'Erro ao inserir administrador como colaborador'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> alterUser(
      ({
        int id,
        String name,
        String email,
        String password,
        List<String> workDays,
        List<int> workHours,
      }) userModel) async {
    try {
      await restClient.auth.patch('/users/${userModel.id}', data: {
        'id': userModel.id,
        'name': userModel.name,
        'email': userModel.email,
        'password': userModel.password,
        'work_days': userModel.workDays,
        'work_hours': userModel.workHours,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao alterar usuario', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao alterar usuario'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> deleteEmployee(
      ({
        int id,
      }) userModel) async {
    try {
      await restClient.auth.delete('/users/${userModel.id}', data: {
        'id': userModel.id,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao delete um usuario', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao delete um usuario'));
    }
  }
}
