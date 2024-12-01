import 'package:cinemapedia/domain/datasources/genres_datasource.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/repositories/genres_repository.dart';

class GenreRepositoryImpl extends GenresRepository {
  final GenresDatasource datasource;

  GenreRepositoryImpl(this.datasource);

  @override
  Future<List<Genre>> getOfficialGenresForMovies() async {
    return await datasource.getOfficialGenresForMovies();
  }
}
