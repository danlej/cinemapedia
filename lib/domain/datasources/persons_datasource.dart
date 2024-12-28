import 'package:cinemapedia/domain/entities/person.dart';

abstract class PersonsDatasource {
  Future<Person> getPersonById(String personId);
}
