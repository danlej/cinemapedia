class GenresResponse {
  final List<GenreMovieDB> genres;

  GenresResponse({
    required this.genres,
  });

  factory GenresResponse.fromJson(Map<String, dynamic> json) => GenresResponse(
        genres: List<GenreMovieDB>.from(
            json["genres"].map((x) => GenreMovieDB.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
      };
}

class GenreMovieDB {
  final int id;
  final String name;

  GenreMovieDB({
    required this.id,
    required this.name,
  });

  factory GenreMovieDB.fromJson(Map<String, dynamic> json) => GenreMovieDB(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
