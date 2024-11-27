import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/repositories/genre_repository_impl.dart';
import 'package:cinemapedia/infrastructure/datasources/genre_moviedb_datasource.dart';

final genresRepositoryProvider = Provider(
  (ref) => GenreRepositoryImpl(GenreMoviedbDatasource()),
);
