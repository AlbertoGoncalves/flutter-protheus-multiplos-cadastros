import 'package:multiplos_cadastros/src/core/exceptions/auth_exception.dart';
import 'package:multiplos_cadastros/src/core/exceptions/repository_exception.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/fp/nil.dart';
import 'package:multiplos_cadastros/src/model/user_model.dart';

abstract interface class UserRepository {
  Future<Either<AuthException, List<String>>> login(String email, String password);

  Future<Either<RepositoryException, UserModel>> me();

  Future<Either<RepositoryException, Nil>> registerAdmin(
      ({String name, String email, String password}) userData);

  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      String companyId);

  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({
        List<String> workDays,
        List<int> workHours,
      }) userModel);

  Future<Either<RepositoryException, Nil>> registerEmployee(
      ({
        String companyId,
        String name,
        String email,
        String password,
        List<String> workDays,
        List<int> workHours,
      }) userModel);

  Future<Either<RepositoryException, Nil>> alterUser(
      ({
        int id,
        String name,
        String email,
        String password,
        List<String> workDays,
        List<int> workHours,
      }) userModel);

  Future<Either<RepositoryException, Nil>> deleteEmployee(
      ({
        int id,
      }) userModel);
}
