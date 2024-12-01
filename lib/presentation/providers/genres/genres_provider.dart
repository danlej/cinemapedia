import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/entities.dart';

final genresProvider =
    StateNotifierProvider<GenreMapNotifier, Map<int, List<Movie>>>((ref) {
  final getMovies = ref.watch(movieRepositoryProvider).getMoviesByGenreId;

  return GenreMapNotifier(getMoviesByGenre: getMovies);
});

/*
  {
    12: List<Movie>
    878: List<Movie>
    1049: List<Movie>
  }

 */

typedef GetMovieCallback = Future<List<Movie>> Function(int genreId,
    {int page});

class GenreMapNotifier extends StateNotifier<Map<int, List<Movie>>> {
  int currentPage = 0;
  bool isLoading = false;
  final GetMovieCallback getMoviesByGenre;

  GenreMapNotifier({required this.getMoviesByGenre}) : super({});

  Future<void> loadNextPage(int genreId) async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movies =
        await getMoviesByGenre(genreId, page: currentPage);

    if (state[genreId] == null) {
      state = {...state, genreId: movies};
      return;
    }

    state[genreId]!.addAll(movies);

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }
}
