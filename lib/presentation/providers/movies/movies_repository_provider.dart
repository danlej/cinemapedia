import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este provider es de solo lectura, es inmutable. Su objetivo es básicamente
// proporcionar a todos los demás providers que tengo la información necesaria
// para que puedan consultar la información del MovieRespositoryImpl()
final movieRepositoryProvider =
    Provider((ref) => MovieRepositoryImpl(MoviedbDatasource()));
