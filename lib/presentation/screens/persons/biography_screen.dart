import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/domain/entities/entities.dart';

class BiographyScreen extends ConsumerStatefulWidget {
  static const name = 'biography';
  final String personId;

  const BiographyScreen({
    super.key,
    required this.personId,
  });

  @override
  BiographyScreenState createState() => BiographyScreenState();
}

class BiographyScreenState extends ConsumerState<BiographyScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(personsProvider.notifier).loadPerson(widget.personId);
    ref.read(movieCreditsByPersonProvider.notifier).loadMovieCredits(widget.personId);
  }

  @override
  Widget build(BuildContext context) {
    final Person? person = ref.watch(personsProvider)[widget.personId];
    final List<Movie>? movies = ref.watch(movieCreditsByPersonProvider)[widget.personId];

    final size = MediaQuery.of(context).size;

    if (person == null) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      person.profilePath,
                      width: size.width * 0.3,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _BiographyDetails(person: person, size: size),
                ],
              ),
              const SizedBox(height: 10),
              if (person.biography.isNotEmpty)
                SizedBox(height: 180, child: SingleChildScrollView(child: SizedBox(child: Text(person.biography)))),
              _KnownForMovies(movies: movies),
            ],
          ),
        ),
      ),
    );
  }
}

class _KnownForMovies extends StatelessWidget {
  final List<Movie>? movies;

  const _KnownForMovies({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies == null) return const Center(child: CircularProgressIndicator(strokeWidth: 2));

    if (movies!.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 10),
      child: MovieHorizontalListview(title: 'Known For', movies: movies!),
    );
  }
}

class _BiographyDetails extends StatelessWidget {
  final Person person;
  final Size size;

  const _BiographyDetails({required this.person, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (size.width - 45) * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            person.name,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                person.alsoKnownAs,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
              ),
              const Spacer(),
              if (person.birthday != null && person.deathday == null)
                Text('${HumanFormats.howOld(person.birthday!)} yo'),
            ],
          ),
          const SizedBox(height: 8),
          if (person.birthday != null)
            BiographyItem(
              label: 'Birthday: ',
              content: HumanFormats.shortDate(person.birthday!),
            ),
          const SizedBox(height: 3),
          if (person.deathday != null)
            BiographyItem(
              label: 'Deathday: ',
              content: HumanFormats.shortDate(person.deathday!),
            ),
          const SizedBox(height: 3),
          BiographyItem(
            label: 'Place of Birth: ',
            content: person.placeOfBirth,
            condition: person.placeOfBirth.isNotEmpty,
          ),
          const SizedBox(height: 3),
          BiographyItem(
            label: 'Department: ',
            content: person.knownForDepartment,
            condition: person.knownForDepartment.isNotEmpty,
          ),
          const SizedBox(height: 3),
          BiographyItem(
            label: 'Homepage: ',
            content: person.homepage,
            condition: person.homepage.isNotEmpty,
          ),
        ],
      ),
    );
  }
}

class BiographyItem extends StatelessWidget {
  final String label;
  final String content;
  final bool condition;

  const BiographyItem({
    super.key,
    required this.label,
    required this.content,
    this.condition = true,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return condition
        ? RichText(
            text: TextSpan(
              text: label,
              style: textStyles.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              children: <TextSpan>[
                TextSpan(
                  text: content,
                  style: textStyles.titleSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          )
        : Container();
  }
}
