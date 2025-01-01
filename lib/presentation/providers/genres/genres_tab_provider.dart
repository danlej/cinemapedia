import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final genresTabProvider = StateNotifierProvider<GenresTabNotifier, Map<int, MoviesGenreState>>((ref) {
  return GenresTabNotifier();
});

/*
  {
    '28': MoviesGenreState(),
    '12': MoviesGenreState(),
    '16': MoviesGenreState(),
  }
 */

class GenresTabNotifier extends StateNotifier<Map<int, MoviesGenreState>> {
  GenresTabNotifier() : super({});

  void update(int key, MoviesGenreState value) {
    state = {...state, key: value};
  }
}

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../providers.dart';

// final genresTabProvider = StateNotifierProvider<GenresTabNotifier, Map<int, MoviesGenreState>>((ref) {
//   final moviesGenreState = ref.read(moviesGenreProvider);
//   final selectedGenre = ref.watch(genresProvider).selectedGenre;

//   final notifier = GenresTabNotifier();

//   notifier.update(selectedGenre, moviesGenreState);

//   return notifier;
// });

// /*
//   {
//     '28': MoviesGenreState(),
//     '12': MoviesGenreState(),
//     '16': MoviesGenreState(),
//   }
//  */

// class GenresTabNotifier extends StateNotifier<Map<int, MoviesGenreState>> {
//   GenresTabNotifier() : super({});

//   void update(int key, MoviesGenreState value) {
//     state = {...state, key: value};
//   }
// }
