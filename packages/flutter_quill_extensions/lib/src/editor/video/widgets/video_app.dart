import 'package:flutter/material.dart';

/// Widget for playing back video
/// Refer to https://github.com/flutter/plugins/tree/master/packages/video_player/video_player
class VideoApp extends StatefulWidget {
  const VideoApp({
    required this.videoUrl,
    required this.readOnly,
    @Deprecated(
      'The context is no longer required and will be removed on future releases',
    )
    BuildContext? context,
    super.key,
    this.onVideoInit,
  });

  final String videoUrl;
  final bool readOnly;
  final void Function(GlobalKey videoContainerKey)? onVideoInit;

  @override
  VideoAppState createState() => VideoAppState();
}

class VideoAppState extends State<VideoApp> {
  GlobalKey videoContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
