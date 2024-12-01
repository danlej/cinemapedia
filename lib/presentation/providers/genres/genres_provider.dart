import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/views/movies/genres_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/entities.dart';

final genresProvider =
    StateNotifierProvider<GenreMapNotifier, Map<int, List<Movie>>>((ref) {
  final getMovies = ref.watch(movieRepositoryProvider).getMoviesByGenreId;
  final genreId = ref.watch(selectedGenreProvider);

  return GenreMapNotifier(getMoviesByGenre: getMovies, genreId: genreId);
});

/*
  {
    12: List<Movie>
    878: List<Movie>
    1049: List<Movie>
  }

 */

typedef GetMovieGenreCallback = Future<List<Movie>> Function(int genreId,
    {int page});

class GenreMapNotifier extends StateNotifier<Map<int, List<Movie>>> {
  int currentPage = 0;
  bool isLoading = false;
  int genreId;
  GetMovieGenreCallback getMoviesByGenre;

  GenreMapNotifier({required this.getMoviesByGenre, required this.genreId})
      : super({});

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movies =
        await getMoviesByGenre(genreId, page: currentPage);

    if (state[genreId] == null) {
      state = {...state, genreId: movies};
      isLoading = false;
      return;
    }

    state[genreId]!.addAll(movies);

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }
}
