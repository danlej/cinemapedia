class ExternalIdsResponse {
  final int id;
  final String? freebaseMid;
  final String? freebaseId;
  final String? imdbId;
  final int? tvrageId;
  final String? wikidataId;
  final String? facebookId;
  final String? instagramId;
  final String? tiktokId;
  final String? twitterId;
  final String? youtubeId;

  ExternalIdsResponse({
    required this.id,
    required this.freebaseMid,
    required this.freebaseId,
    required this.imdbId,
    required this.tvrageId,
    required this.wikidataId,
    required this.facebookId,
    required this.instagramId,
    required this.tiktokId,
    required this.twitterId,
    required this.youtubeId,
  });

  factory ExternalIdsResponse.fromJson(Map<String, dynamic> json) => ExternalIdsResponse(
        id: json["id"],
        freebaseMid: json["freebase_mid"],
        freebaseId: json["freebase_id"],
        imdbId: json["imdb_id"],
        tvrageId: json["tvrage_id"],
        wikidataId: json["wikidata_id"],
        facebookId: json["facebook_id"],
        instagramId: json["instagram_id"],
        tiktokId: json["tiktok_id"],
        twitterId: json["twitter_id"],
        youtubeId: json["youtube_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "freebase_mid": freebaseMid,
        "freebase_id": freebaseId,
        "imdb_id": imdbId,
        "tvrage_id": tvrageId,
        "wikidata_id": wikidataId,
        "facebook_id": facebookId,
        "instagram_id": instagramId,
        "tiktok_id": tiktokId,
        "twitter_id": twitterId,
        "youtube_id": youtubeId,
      };
}
