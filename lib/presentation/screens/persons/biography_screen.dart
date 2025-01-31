import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/providers/persons/external_ids_provider.dart';
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
    ref.read(externalIdsProvider.notifier).loadExternalIds(widget.personId);
    ref.read(movieCreditsByPersonProvider.notifier).loadMovieCredits(widget.personId);
  }

  @override
  Widget build(BuildContext context) {
    final Person? person = ref.watch(personsProvider)[widget.personId];
    final List<Movie>? movies = ref.watch(movieCreditsByPersonProvider)[widget.personId];
    final ExternalIds? externalIds = ref.watch(externalIdsProvider)[widget.personId];

    final size = MediaQuery.of(context).size;

    if (person == null || movies == null) {
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _BiographyImage(imagePath: person.profilePath, size: size),
                      if (externalIds != null)
                        SocialMediaButtons(
                          externalIds: externalIds,
                        )
                    ],
                  ),
                  const SizedBox(width: 10),
                  _BiographyDetails(person: person, size: size),
                ],
              ),
              const SizedBox(height: 10),
              _BiographyDescription(content: person.biography),
              const SizedBox(height: 10),
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

class _BiographyDescription extends StatefulWidget {
  final String content;

  const _BiographyDescription({required this.content});

  @override
  State<_BiographyDescription> createState() => _BiographyDescriptionState();
}

class _BiographyDescriptionState extends State<_BiographyDescription> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Verifica si realmente se está moviendo el scroll
    bool isCurrentlyScrolling = _scrollController.position.userScrollDirection != ScrollDirection.idle;

    if (isCurrentlyScrolling && !_isScrolling) {
      setState(() => _isScrolling = true);
    }

    // Cancelamos cualquier Timer previo
    _scrollTimer?.cancel();

    // Iniciamos un nuevo Timer para detectar si el usuario deja de hacer scroll
    _scrollTimer = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.userScrollDirection == ScrollDirection.idle) {
        setState(() => _isScrolling = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.content.isEmpty) return const SizedBox();

    return Stack(children: [
      Container(
        constraints: const BoxConstraints(maxHeight: 180),
        decoration: BoxDecoration(
          color: _isScrolling ? (isDark ? Colors.black : Colors.white) : null,
          boxShadow: _isScrolling
              ? [
                  BoxShadow(
                    color: isDark ? Colors.white54 : Colors.black.withAlpha(50),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            child: Text(widget.content),
          ),
        ),
      ),
      // Positioned(
      //   right: 2,
      //   bottom: 2,
      //   child: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.arrow_drop_down),
      //     style: const ButtonStyle(
      //       iconColor: WidgetStatePropertyAll(Colors.white),
      //       iconSize: WidgetStatePropertyAll(35),
      //     ),
      //   ),
      // ),
      // Positioned(
      //   right: 2,
      //   top: 2,
      //   child: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.arrow_drop_up),
      //     style: const ButtonStyle(
      //       iconColor: WidgetStatePropertyAll(Colors.white),
      //       iconSize: WidgetStatePropertyAll(35),
      //     ),
      //   ),
      // ),
    ]);
  }
}

class _BiographyImage extends StatelessWidget {
  final String imagePath;
  final Size size;

  const _BiographyImage({required this.imagePath, required this.size});

  @override
  Widget build(BuildContext context) {
    Image image = Image.network(imagePath, fit: BoxFit.cover);

    return GestureDetector(
      onTap: () => showImageDialog(context, image),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(1.0, 1.0),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: size.width * 0.3,
            child: image,
          ),
        ),
      ),
    );
  }

  void showImageDialog(BuildContext context, Image image) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            // Blur effect in the background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Ajusta el nivel de desenfoque
              child: Container(
                color: Colors.black.withAlpha(128), // Un ligero fondo semitransparente
              ),
            ),
            // Image
            Center(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: image,
                      ),
                      Positioned(
                        top: 1,
                        right: 1,
                        child: IconButton(
                          onPressed: () => context.pop(),
                          color: Colors.white,
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BiographyDetails extends StatelessWidget {
  final Person person;
  final Size size;

  const _BiographyDetails({required this.person, required this.size});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return SizedBox(
      width: (size.width - 50) * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                text: '${person.name} ',
                style: textStyles.titleLarge?.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 3),
          RichText(
            text: TextSpan(
                text:
                    '${person.alsoKnownAs} ${person.birthday != null ? '(${HumanFormats.howOld(person.birthday!, person.deathday)} years old)' : ''}',
                style: textStyles.titleMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                )),
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
          if (person.deathday != null) const SizedBox(height: 3),
          BiographyItem(
            label: 'Place of Birth: ',
            content: person.placeOfBirth,
            condition: person.placeOfBirth.isNotEmpty,
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
              style: textStyles.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: content,
                  style: textStyles.titleSmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}

class SocialMediaButtons extends StatelessWidget {
  final ExternalIds externalIds;

  const SocialMediaButtons({super.key, required this.externalIds});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 13,
      children: [
        if (externalIds.instagramId != null && externalIds.instagramId!.isNotEmpty)
          InkWell(
            onTap: openInstagram,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 35,
                height: 35,
                child: Image.asset(
                  'assets/images/instagram.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        if (externalIds.facebookId != null && externalIds.facebookId!.isNotEmpty)
          InkWell(
            onTap: openFacebook,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 35,
                height: 35,
                child: Image.asset(
                  'assets/images/facebook.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
      ],
    );
  }

  Future<void> openInstagram() async {
    final Uri appUrl = Uri.parse('instagram://user?username=${externalIds.instagramId}');
    final Uri webUrl = Uri.parse('https://www.instagram.com/${externalIds.instagramId}/');

    try {
      // Intenta abrir la app de Instagram.
      if (!await launchUrl(appUrl, mode: LaunchMode.externalApplication)) {
        // Si falla, abre el perfil en el navegador.
        if (!await launchUrl(webUrl, mode: LaunchMode.externalApplication)) {
          throw 'No se pudo abrir Instagram.';
        }
      }
    } catch (e) {
      debugPrint('Error al abrir Instagram: $e');
    }
  }

  Future<void> openFacebook() async {
    // Detecta si es un ID numérico (probable página) o un nombre de usuario (perfil)
    final bool isPage = RegExp(r'^\d+$').hasMatch(externalIds.facebookId!);

    final Uri? appUrl = isPage ? Uri.parse('fb://page/${externalIds.facebookId}') : null;
    final Uri webUrl = Uri.parse('https://www.facebook.com/${externalIds.facebookId}/');

    try {
      if (appUrl != null && await canLaunchUrl(appUrl)) {
        // Si es una página y la app de Facebook puede manejarlo, abre la app
        await launchUrl(appUrl, mode: LaunchMode.externalApplication);
      } else {
        // Si es un perfil o la app no puede abrirlo, abre en el navegador
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error al abrir Facebook: $e');
    }
  }
}
