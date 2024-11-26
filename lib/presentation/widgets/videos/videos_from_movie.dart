import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final FutureProviderFamily<List<Video>, int> videosFromMovieProvider =
    FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});

class VideosFromMovie extends ConsumerWidget {
  final int movieId;

  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesFromVideo = ref.watch(videosFromMovieProvider(movieId));

    return moviesFromVideo.when(
      data: (videos) => _VideosList(videos: videos),
      error: (_, __) =>
          const Center(child: Text('No se pudo cargar películas similares')),
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _VideosList extends StatefulWidget {
  final List<Video> videos;

  const _VideosList({required this.videos});

  @override
  State<_VideosList> createState() => _VideosListState();
}

class _VideosListState extends State<_VideosList> {
  late PageController _pageViewController;
  int _currentPageIndex = 1;
  bool isAnimationTriggered = false; // Flag para controlar la animación

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void swipeToRight() async {
    if (widget.videos.length > 1) {
      await Future.delayed(const Duration(milliseconds: 400));

      if (_pageViewController.hasClients) {
        _pageViewController.animateTo(
          _pageViewController.position.pixels + 120,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //* Nada que mostrar
    if (widget.videos.isEmpty) {
      return const SizedBox();
    }

    void handlePageViewChanged(int currentPageIndex) {
      setState(() {
        _currentPageIndex = currentPageIndex + 1;
      });
    }

    return VisibilityDetector(
      key: const Key('videos-list'),
      onVisibilityChanged: (info) {
        // Detecta cuando al menos el 90% del widget es visible
        if (info.visibleFraction > 0.9 && !isAnimationTriggered) {
          isAnimationTriggered = true;
          swipeToRight();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ignore: prefer_const_constructors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Text(
                  'Videos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text('$_currentPageIndex de ${widget.videos.length}')
              ],
            ),
          ),

          //* Aunque tengo varios videos, sólo quiero mostrar el primero
          // _YouTubeVideoPlayer(
          //     youtubeId: videos.first.youtubeKey, name: videos.first.name)

          //* Si se desean mostrar todos los videos
          // ...widget.videos.map(
          //         (video) => YouTubeVideoPlayer(
          //             youtubeId: video.youtubeKey, name: video.name),)

          SizedBox(
            height: 250,
            width: size.width,
            child: PageView.builder(
              controller: _pageViewController,
              onPageChanged: handlePageViewChanged,
              itemCount: widget.videos.length,
              itemBuilder: (context, index) {
                final video = widget.videos[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: YouTubeVideoPlayer(
                    youtubeId: video.youtubeKey,
                    name: video.name,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
