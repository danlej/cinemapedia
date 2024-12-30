import 'package:cinemapedia/domain/entities/entities.dart';

abstract class PersonsDatasource {
  Future<Person> getPersonById(String personId);
  Future<List<Movie>> getMovieCreditsByPersonId(String personId);
}
