import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesRespository {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
