import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/infrastructure/models/models.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '')
          ? 'https://images.tmdb.org/t/p/w500${moviedb.backdropPath}'
          : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '')
          ? 'https://images.tmdb.org/t/p/w500${moviedb.posterPath}'
          : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);

  static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '')
          ? 'https://images.tmdb.org/t/p/w500${moviedb.backdropPath}'
          : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg',
      genreIds: moviedb.genres.map((e) => e.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '')
          ? 'https://images.tmdb.org/t/p/w500${moviedb.posterPath}'
          : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);

  static MovieCredit movieCreditDBToEntity(MovieCreditDB movieCreditDB) => MovieCredit(
      adult: movieCreditDB.adult,
      backdropPath: (movieCreditDB.backdropPath != '')
          ? 'https://images.tmdb.org/t/p/w500${movieCreditDB.backdropPath}'
          : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg',
      genreIds: movieCreditDB.genreIds.map((e) => e.toString()).toList(),
      id: movieCreditDB.id,
      originalLanguage: movieCreditDB.originalLanguage,
      originalTitle: movieCreditDB.originalTitle,
      overview: movieCreditDB.overview,
      popularity: movieCreditDB.popularity,
      posterPath: (movieCreditDB.posterPath != '')
          ? 'https://images.tmdb.org/t/p/w500${movieCreditDB.posterPath}'
          : 'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg',
      releaseDate: movieCreditDB.releaseDate,
      title: movieCreditDB.title,
      video: movieCreditDB.video,
      voteAverage: movieCreditDB.voteAverage,
      voteCount: movieCreditDB.voteCount,
      character: movieCreditDB.character,
      creditId: movieCreditDB.creditId,
      order: movieCreditDB.order,
      department: movieCreditDB.department,
      job: movieCreditDB.job);

  static Movie movieCreditToMovie(MovieCredit movieCredit) => Movie(
      adult: movieCredit.adult,
      backdropPath: movieCredit.backdropPath,
      genreIds: movieCredit.genreIds,
      id: movieCredit.id,
      originalLanguage: movieCredit.originalLanguage,
      originalTitle: movieCredit.originalTitle,
      overview: movieCredit.overview,
      popularity: movieCredit.popularity,
      posterPath: movieCredit.posterPath,
      releaseDate: movieCredit.releaseDate,
      title: movieCredit.title,
      video: movieCredit.video,
      voteAverage: movieCredit.voteAverage,
      voteCount: movieCredit.voteCount);
}
