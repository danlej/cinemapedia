import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/entities.dart';

import 'persons_repository_provider.dart';

final externalIdsProvider = StateNotifierProvider<ExternalIdsMapNotifier, Map<String, ExternalIds>>((ref) {
  final getExternalIds = ref.watch(personRepositoryProvider).getExternalIdsByPersonId;

  return ExternalIdsMapNotifier(getExternalIds: getExternalIds);
});

/*
  {
    '18918': ExternalIds(),
    '109513': ExternalIds(),
    '17832': ExternalIds(),
    '128645': ExternalIds(),
  }
 */

typedef GetExternalIdsCallback = Future<ExternalIds> Function(String personId);

class ExternalIdsMapNotifier extends StateNotifier<Map<String, ExternalIds>> {
  final GetExternalIdsCallback getExternalIds;

  ExternalIdsMapNotifier({required this.getExternalIds}) : super({});

  Future<void> loadExternalIds(String personId) async {
    if (state[personId] != null) return;

    final externalIds = await getExternalIds(personId);

    state = {...state, personId: externalIds};
  }
}
