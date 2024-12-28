class Person {
  final int id;
  final String name;
  final DateTime birthday;
  final DateTime? deathday;
  final String placeOfBirth;
  final String biography;
  final double popularity;
  final String profilePath;
  final String imdbId;

  Person({
    required this.id,
    required this.name,
    required this.birthday,
    required this.deathday,
    required this.placeOfBirth,
    required this.biography,
    required this.popularity,
    required this.profilePath,
    required this.imdbId,
  });
}
