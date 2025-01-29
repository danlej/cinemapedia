import 'package:cinemapedia/domain/entities/entities.dart';

abstract class PersonRepository {
  Future<Person> getPersonById(String personId);
  Future<List<Movie>> getMovieCreditsByPersonId(String personId);
  Future<ExternalIds> getExternalIdsByPersonId(String personId);
}
