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
        GenreSelector(
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

class GenreSelector extends ConsumerStatefulWidget {
  final List<Genre> genres;
  final int selectedGenre;

  const GenreSelector({
    super.key,
    required this.genres,
    required this.selectedGenre,
  });

  @override
  GenreSelectorState createState() => GenreSelectorState();
}

class GenreSelectorState extends ConsumerState<GenreSelector> {
  final ScrollController scrollController = ScrollController();
  bool isLeftArrowVisible = true;
  bool isRightArrowVisible = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.offset <= 0 && isLeftArrowVisible) {
      setState(() {
        isLeftArrowVisible = false;
      });
    }

    if (scrollController.offset > 0 && !isLeftArrowVisible) {
      setState(() {
        isLeftArrowVisible = true;
      });
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent && isRightArrowVisible) {
      setState(() {
        isRightArrowVisible = false;
      });
    }

    if (scrollController.offset < scrollController.position.maxScrollExtent && !isRightArrowVisible) {
      setState(() {
        isRightArrowVisible = true;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeNotifierProvider).isDarkMode; //Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: isDark ? Colors.black : Colors.white,
        child: Stack(
          children: [
            // ListView con ChoiceChips de géneros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  controller: scrollController, // Controlador de scroll
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.genres.length,
                  itemBuilder: (context, index) {
                    final genre = widget.genres[index];
                    bool isSelected = widget.selectedGenre == genre.id;

                    return Container(
                      color: isDark ? Colors.black : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ChoiceChip(
                          label: Text(
                            genre.name,
                            style: TextStyle(
                              color: isDark
                                  ? (isSelected ? Colors.black : Colors.white)
                                  : (isSelected ? Colors.white : Colors.black),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          visualDensity: isSelected ? VisualDensity.comfortable : VisualDensity.compact,
                          selected: isSelected,
                          selectedColor: isDark ? Colors.white : Colors.black,
                          showCheckmark: false,
                          side: const BorderSide(style: BorderStyle.none),
                          backgroundColor: isDark
                              ? (isSelected ? Colors.white : Colors.grey.shade800)
                              : (isSelected ? Colors.black : Colors.grey.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
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
                      ),
                    );
                  }),
            ),

            // Flecha Izquierda
            if (isLeftArrowVisible)
              Positioned(
                left: 0,
                child: _CustomGradientButton(
                    width: 70,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    icon: Icons.arrow_back_ios,
                    alignment: Alignment.centerLeft,
                    onPressed: _scrollLeft),
              ),

            // Flecha Derecha
            if (isRightArrowVisible)
              Positioned(
                right: 0,
                child: _CustomGradientButton(
                    width: 70,
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    icon: Icons.arrow_forward_ios,
                    alignment: Alignment.centerRight,
                    onPressed: _scrollRight),
              ),
          ],
        ),
      ),
    );
  }

  /// Mueve el ListView hacia la izquierda
  void _scrollLeft() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.offset - 200, // Desplaza 200 píxeles a la izquierda
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Mueve el ListView hacia la derecha
  void _scrollRight() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.offset + 200, // Desplaza 200 píxeles a la derecha
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: const [0.5, 1.0],
            colors: [
              if (isDark) Colors.black87 else Colors.white,
              if (isDark) Colors.transparent else Colors.white10,
            ],
          ),
        ),
        child: Align(
          alignment: alignment,
          child: IconButton(
            icon: Icon(icon, color: isDark ? Colors.white : Colors.black),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
