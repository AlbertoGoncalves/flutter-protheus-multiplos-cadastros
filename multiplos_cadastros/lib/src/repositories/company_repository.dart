import 'package:multiplos_cadastros/src/core/exceptions/repository_exception.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/fp/nil.dart';
import 'package:multiplos_cadastros/src/model/company_model.dart';
import 'package:multiplos_cadastros/src/model/user_model.dart';

abstract interface class CompanyRepository {
  Future<Either<RepositoryException, Nil>> save(
      ({
        String company,
        String email,
        List<String> openingDays,
        List<int> openingHours,
      }) data);

  Future<Either<RepositoryException, CompanyModel>> getMyCompany(
      UserModel userModel);
}
