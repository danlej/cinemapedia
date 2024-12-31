import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../persons/persons_repository_provider.dart';

final movieCreditsByPersonProvider =
    StateNotifierProvider<MovieCreditsByPersonNotifier, Map<String, List<Movie>>>((ref) {
  final getMovies = ref.watch(personRepositoryProvider).getMovieCreditsByPersonId;

  return MovieCreditsByPersonNotifier(getMovies: getMovies);
});

/*
  {
    '206': <Movie>[],
    '6384': <Movie>[],
    '18918': <Movie>[],
    '4775908': <Movie>[],
    '1564846': <Movie>[],
  }
 */

typedef GetMovieCreditsCallback = Future<List<Movie>> Function(String personId);

class MovieCreditsByPersonNotifier extends StateNotifier<Map<String, List<Movie>>> {
  final GetMovieCreditsCallback getMovies;

  MovieCreditsByPersonNotifier({required this.getMovies}) : super({});

  Future<void> loadMovieCredits(String personId) async {
    if (state[personId] != null) return;

    final List<Movie> movieCredits = await getMovies(personId);

    state = {...state, personId: movieCredits};
  }
}
