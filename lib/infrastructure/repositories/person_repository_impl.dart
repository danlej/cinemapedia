import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/domain/datasources/persons_datasource.dart';
import 'package:cinemapedia/domain/repositories/person_repository.dart';

class PersonRepositoryImpl extends PersonRepository {
  final PersonsDatasource datasource;

  PersonRepositoryImpl(this.datasource);

  @override
  Future<Person> getPersonById(String personId) async {
    return datasource.getPersonById(personId);
  }

  @override
  Future<List<Movie>> getMovieCreditsByPersonId(String personId) {
    return datasource.getMovieCreditsByPersonId(personId);
  }
}
