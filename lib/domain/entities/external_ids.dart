class ExternalIds {
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

  ExternalIds({
    required this.id,
    required this.freebaseMid,
    required this.freebaseId,
    required this.imdbId,
    this.tvrageId,
    required this.wikidataId,
    required this.facebookId,
    required this.instagramId,
    required this.tiktokId,
    required this.twitterId,
    required this.youtubeId,
  });
}
