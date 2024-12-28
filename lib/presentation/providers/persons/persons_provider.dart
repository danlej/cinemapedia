import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/entities.dart';

import 'persons_repository_provider.dart';

final personsProvider = StateNotifierProvider<PersonMapNotifier, Map<String, Person>>((ref) {
  final getPerson = ref.watch(personRepositoryProvider).getPersonById;

  return PersonMapNotifier(getPerson: getPerson);
});

/*
  {
    '18918': Person(),
    '109513': Person(),
    '17832': Person(),
    '128645': Person(),
  }
 */

typedef GetPersonCallback = Future<Person> Function(String personId);

class PersonMapNotifier extends StateNotifier<Map<String, Person>> {
  final GetPersonCallback getPerson;

  PersonMapNotifier({required this.getPerson}) : super({});

  Future<void> loadPerson(String personId) async {
    if (state[personId] != null) return;

    final person = await getPerson(personId);

    state = {...state, personId: person};
  }
}
