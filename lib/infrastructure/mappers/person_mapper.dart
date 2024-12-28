import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/person_response.dart';

class PersonMapper {
  static Person castToEntity(PersonResponse personResponse) => Person(
        id: personResponse.id,
        name: personResponse.name,
        birthday: personResponse.birthday,
        deathday: personResponse.deathday,
        placeOfBirth: personResponse.placeOfBirth,
        biography: personResponse.biography,
        popularity: personResponse.popularity,
        profilePath: personResponse.profilePath != null
            ? 'https://images.tmdb.org/t/p/w500${personResponse.profilePath}'
            : 'https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg',
        imdbId: personResponse.imdbId,
      );
}
