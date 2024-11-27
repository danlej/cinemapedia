import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/genres_response.dart';

class GenreMapper {
  static Genre genreMovieDBToEntity(GenreMovieDB genreMovieDB) => Genre(
        id: genreMovieDB.id,
        name: genreMovieDB.name,
      );
}
