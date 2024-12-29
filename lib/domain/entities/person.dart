class Person {
  final int id;
  final String name;
  final String alsoKnownAs;
  final DateTime? birthday;
  final DateTime? deathday;
  final String placeOfBirth;
  final String biography;
  final double? popularity;
  final String profilePath;
  final String? imdbId;
  final String knownForDepartment;
  final String homepage;

  Person({
    required this.id,
    required this.name,
    required this.alsoKnownAs,
    required this.birthday,
    required this.deathday,
    required this.placeOfBirth,
    required this.biography,
    required this.popularity,
    required this.profilePath,
    required this.imdbId,
    required this.knownForDepartment,
    required this.homepage,
  });

  Person copyWith({
    int? id,
    String? name,
    String? alsoKnownAs,
    DateTime? birthday,
    DateTime? deathday,
    String? placeOfBirth,
    String? biography,
    double? popularity,
    String? profilePath,
    String? imdbId,
    String? knownForDepartment,
    String? homepage,
  }) =>
      Person(
        id: id ?? this.id,
        name: name ?? this.name,
        alsoKnownAs: alsoKnownAs ?? this.alsoKnownAs,
        birthday: birthday ?? this.birthday,
        deathday: deathday ?? this.deathday,
        placeOfBirth: placeOfBirth ?? this.placeOfBirth,
        biography: biography ?? this.biography,
        popularity: popularity ?? this.popularity,
        profilePath: profilePath ?? this.profilePath,
        imdbId: imdbId ?? this.imdbId,
        knownForDepartment: knownForDepartment ?? this.knownForDepartment,
        homepage: homepage ?? this.homepage,
      );
}
