import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/genres_datasource.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/infrastructure/mappers/genre_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/genres_response.dart';
import 'package:dio/dio.dart';

class GenreMoviedbDatasource extends GenresDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'en-US',
    },
  ));

  @override
  Future<List<Genre>> getOfficialGenresForMovies() async {
    final response = await dio.get('/genre/movie/list');

    final genresResponse = GenresResponse.fromJson(response.data);

    List<Genre> genres = genresResponse.genres
        .map((genre) => GenreMapper.genreMovieDBToEntity(genre))
        .toList();

    return genres;
  }
}
