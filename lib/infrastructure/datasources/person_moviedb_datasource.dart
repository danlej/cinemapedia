import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/config/helpers/translator.dart';
import 'package:cinemapedia/domain/datasources/persons_datasource.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/infrastructure/mappers/mappers.dart';
import 'package:cinemapedia/infrastructure/models/models.dart';
import 'package:dio/dio.dart';

class PersonMoviedbDatasource extends PersonsDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'en-US',
    },
  ));

  @override
  Future<Person> getPersonById(String personId) async {
    final response = await dio.get('/person/$personId');

    final personResponse = PersonResponse.fromJson(response.data);

    Person person = PersonMapper.castToEntity(personResponse);

    if (person.alsoKnownAs.isNotEmpty) {
      final alsoKnownAs = await Translator.translate(person.alsoKnownAs);
      person = person.copyWith(alsoKnownAs: alsoKnownAs);
    }

    return person;
  }
}
