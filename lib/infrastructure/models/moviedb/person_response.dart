class PersonResponse {
  final bool adult;
  final List<String> alsoKnownAs;
  final String biography;
  final DateTime? birthday;
  final DateTime? deathday;
  final int gender;
  final String homepage;
  final int id;
  final String imdbId;
  final String knownForDepartment;
  final String name;
  final String placeOfBirth;
  final double? popularity;
  final String profilePath;

  PersonResponse({
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    this.birthday,
    this.deathday,
    required this.gender,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    this.popularity,
    required this.profilePath,
  });

  factory PersonResponse.fromJson(Map<String, dynamic> json) => PersonResponse(
        adult: json["adult"],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
        biography: json["biography"] ?? '',
        birthday: json["birthday"] != null && json["birthday"].toString().isNotEmpty
            ? DateTime.parse(json["birthday"])
            : null,
        deathday: json["deathday"] != null && json["deathday"].toString().isNotEmpty
            ? DateTime.parse(json["deathday"])
            : null,
        gender: json["gender"],
        homepage: json["homepage"] ?? '',
        id: json["id"],
        imdbId: json["imdb_id"] ?? '',
        knownForDepartment: json["known_for_department"] ?? '',
        name: json["name"],
        placeOfBirth: json["place_of_birth"] ?? '',
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "also_known_as": List<dynamic>.from(alsoKnownAs.map((x) => x)),
        "biography": biography,
        "birthday": birthday == null
            ? birthday
            : "${birthday!.year.toString().padLeft(4, '0')}-${birthday!.month.toString().padLeft(2, '0')}-${birthday!.day.toString().padLeft(2, '0')}",
        "deathday": deathday == null
            ? deathday
            : "${deathday!.year.toString().padLeft(4, '0')}-${deathday!.month.toString().padLeft(2, '0')}-${deathday!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "known_for_department": knownForDepartment,
        "name": name,
        "place_of_birth": placeOfBirth,
        "popularity": popularity,
        "profile_path": profilePath,
      };
}
