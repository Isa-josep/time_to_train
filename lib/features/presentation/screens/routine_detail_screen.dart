import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:time_to_train/features/models/routine_model.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;

  const RoutineDetailScreen({Key? key, required this.routine}) : super(key: key);

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.routine.videoUrl != null && widget.routine.videoUrl!.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.routine.videoUrl!);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
        setState(() {}); // Actualizamos la UI cuando el controlador está listo
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.routine.nombre,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              widget.routine.descripcion,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (_youtubeController != null)
              YoutubePlayer(
              
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                onReady: () {
                  _youtubeController!.addListener(() {});
                },
              ),
            if (_youtubeController == null)
              const Center(child: Text('No hay un video disponible o el formato no es compatible.')),
          ],
        ),
      ),
      floatingActionButton: _youtubeController != null
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _youtubeController!.value.isPlaying ? _youtubeController!.pause() : _youtubeController!.play();
                });
              },
              child: Icon(
                _youtubeController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
