import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String youtubeId;
  final String name;

  const YouTubeVideoPlayer({
    super.key,
    required this.youtubeId,
    required this.name,
  });

  @override
  State<YouTubeVideoPlayer> createState() => YouTubeVideoPlayerState();
}

class YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: YoutubePlayer(controller: _controller),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                widget.name,
                maxLines: 2,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ));
  }
}
