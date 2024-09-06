
import 'package:multiplos_cadastros/src/core/exceptions/repository_exception.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/fp/nil.dart';
import 'package:multiplos_cadastros/src/model/peoplex_model.dart';

abstract interface class PeopleRepository {
  Future<Either<RepositoryException, List<PeopleXModel>>> getPeoples(
      String apiFilter, String emp, String code, String description);

  Future<Either<RepositoryException, Nil>> register(
      List<PeopleXModel>? listPeople);

  Future<Either<RepositoryException, Nil>> alter(
      PeopleXModel? people);

  Future<Either<RepositoryException, Nil>> delete(
      PeopleXModel? people);
}
