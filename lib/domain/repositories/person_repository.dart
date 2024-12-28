import 'package:cinemapedia/domain/entities/person.dart';

abstract class PersonRepository {
  Future<Person> getPersonById(String personId);
}
