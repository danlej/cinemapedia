import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/infrastructure/models/models.dart';

class ExternalIdsMapper {
  static ExternalIds externalIdsToEntity(ExternalIdsResponse externalIdsResponse) => ExternalIds(
        id: externalIdsResponse.id,
        freebaseMid: externalIdsResponse.freebaseMid,
        freebaseId: externalIdsResponse.freebaseId,
        imdbId: externalIdsResponse.imdbId,
        tvrageId: externalIdsResponse.tvrageId,
        wikidataId: externalIdsResponse.wikidataId,
        facebookId: externalIdsResponse.facebookId,
        instagramId: externalIdsResponse.instagramId,
        tiktokId: externalIdsResponse.tiktokId,
        twitterId: externalIdsResponse.twitterId,
        youtubeId: externalIdsResponse.youtubeId,
      );
}
