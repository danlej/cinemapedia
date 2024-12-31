import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

final moviesGenreProvider = StateNotifierProvider.autoDispose<MoviesGenreNotifier, MoviesGenreState>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  final selectedGenre = ref.watch(genresProvider).selectedGenre;

  return MoviesGenreNotifier(
    moviesRepository: movieRepository,
    selectedGenre: selectedGenre,
  );
});

class MoviesGenreNotifier extends StateNotifier<MoviesGenreState> {
  final MoviesRepository moviesRepository;
  final int selectedGenre;

  MoviesGenreNotifier({
    required this.moviesRepository,
    required this.selectedGenre,
  }) : super(MoviesGenreState()) {
    loadNextPage();
  }

  Future<void> reset() async {
    state = state.copyWith(
      currentPage: 0,
      isLoading: false,
      isLastPage: false,
      movies: const [],
    );
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage || !mounted) return;

    state = state.copyWith(
      currentPage: state.currentPage + 1,
      isLoading: true,
    );

    final movies = await moviesRepository.getMoviesByGenreId(selectedGenre, page: state.currentPage);

    if (movies.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      isLastPage: false,
      currentPage: state.currentPage,
      movies: [...state.movies, ...movies],
    );
  }
}

class MoviesGenreState {
  final int currentPage;
  final bool isLoading;
  final bool isLastPage;
  final List<Movie> movies;

  MoviesGenreState({
    this.currentPage = 0,
    this.isLoading = false,
    this.isLastPage = false,
    this.movies = const [],
  });

  MoviesGenreState copyWith({
    int? currentPage,
    bool? isLoading,
    bool? isLastPage,
    List<Movie>? movies,
  }) =>
      MoviesGenreState(
        currentPage: currentPage ?? this.currentPage,
        isLoading: isLoading ?? this.isLoading,
        isLastPage: isLastPage ?? this.isLastPage,
        movies: movies ?? this.movies,
      );
}
