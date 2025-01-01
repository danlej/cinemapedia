import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_masonry.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class GenresView extends ConsumerStatefulWidget {
  const GenresView({super.key});

  @override
  GenresViewState createState() => GenresViewState();
}

class GenresViewState extends ConsumerState<GenresView> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController(); // Controlador para el desplazamiento

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final genresState = ref.watch(genresProvider);

    if (genresState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (genresState.genres.isEmpty) {
      return const Center(
        child: Text('No genres available'),
      );
    }

    return Column(
      children: [
        _GenreSelector(
          scrollController: scrollController,
          genres: genresState.genres,
          selectedGenre: genresState.selectedGenre,
        ),
        const Expanded(child: _GenreMoviesView()),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _GenreMoviesView extends ConsumerWidget {
  const _GenreMoviesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesGenreState = ref.watch(moviesGenreProvider);

    return MovieMasonry(
      movies: moviesGenreState.movies,
      loadNextPage: ref.read(moviesGenreProvider.notifier).loadNextPage,
    );
  }
}

class _GenreSelector extends ConsumerWidget {
  final ScrollController scrollController;
  final List<Genre> genres;
  final int selectedGenre;

  const _GenreSelector({
    required this.scrollController,
    required this.genres,
    required this.selectedGenre,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: SizedBox(
          height: 50,
          child: Stack(
            children: [
              // ListView con ChoiceChips de géneros
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ListView.builder(
                    controller: scrollController, // Controlador de scroll
                    scrollDirection: Axis.horizontal,
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      final genre = genres[index];
                      bool isSelected = selectedGenre == genre.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            genre.name,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: Colors.white,
                          showCheckmark: false,
                          backgroundColor: Colors.grey.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onSelected: (bool selected) {
                            if (selected) {
                              final key = ref.read(genresProvider).selectedGenre;
                              final value = ref.read(moviesGenreProvider);

                              ref.read(genresTabProvider.notifier).update(key, value);

                              ref.read(genresProvider.notifier).updateSelectedGenre(genre.id);
                            }
                          },
                        ),
                      );
                    }),
              ),

              // Flecha Izquierda
              Positioned(
                  left: 0,
                  child: _CustomGradientButton(
                      width: 70,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      icon: Icons.arrow_back_ios,
                      alignment: Alignment.centerLeft,
                      onPressed: _scrollLeft)),

              // Flecha Derecha
              Positioned(
                  right: 0,
                  child: _CustomGradientButton(
                      width: 70,
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      icon: Icons.arrow_forward_ios,
                      alignment: Alignment.centerRight,
                      onPressed: _scrollRight)),
            ],
          ),
        ),
      ),
    );
  }

  /// Mueve el ListView hacia la izquierda
  void _scrollLeft() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.offset - 200, // Desplaza 100 píxeles a la izquierda
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Mueve el ListView hacia la derecha
  void _scrollRight() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.offset + 200, // Desplaza 100 píxeles a la derecha
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

class _CustomGradientButton extends StatelessWidget {
  final double width;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final IconData icon;
  final AlignmentGeometry alignment;
  final VoidCallback onPressed;

  const _CustomGradientButton({
    required this.width,
    required this.begin,
    required this.end,
    required this.icon,
    required this.alignment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: const [0.5, 1.0],
            colors: const [
              Colors.black87,
              Colors.transparent,
            ],
          ),
        ),
        child: Align(
          alignment: alignment,
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
