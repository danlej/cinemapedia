import 'package:cinemapedia/domain/repositories/genres_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/entities.dart';

final genresProvider = StateNotifierProvider.autoDispose<GenresNotifier, GenresState>((ref) {
  final genreRepository = ref.watch(genreRepositoryProvider);

  return GenresNotifier(genreRepository: genreRepository);
});

class GenresNotifier extends StateNotifier<GenresState> {
  final GenresRepository genreRepository;

  GenresNotifier({required this.genreRepository}) : super(GenresState()) {
    loadGenres();
  }

  Future<void> updateSelectedGenre(int genre) async {
    state = state.copyWith(
      selectedGenre: genre,
    );
  }

  Future<void> loadGenres() async {
    final genres = await genreRepository.getOfficialGenresForMovies();

    if (genres.isNotEmpty) {
      state = state.copyWith(
        genres: genres,
        selectedGenre: genres.first.id,
        isLoading: false,
      );
    }
  }
}

class GenresState {
  final List<Genre> genres;
  final int selectedGenre;
  final bool isLoading;

  GenresState({
    this.genres = const [],
    this.selectedGenre = 0,
    this.isLoading = true,
  });

  GenresState copyWith({
    List<Genre>? genres,
    int? selectedGenre,
    bool? isLoading,
  }) =>
      GenresState(
        genres: genres ?? this.genres,
        selectedGenre: selectedGenre ?? this.selectedGenre,
        isLoading: isLoading ?? this.isLoading,
      );
}
