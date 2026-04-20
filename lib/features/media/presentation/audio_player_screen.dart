import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key, required this.url});

  final String url;

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _player.setUrl(widget.url);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '--:--';
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오디오 재생')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Colors.deepPurple)
                .animate(onPlay: (c) => c.repeat())
                .rotate(duration: 4.seconds),
            const Gap(32),
            StreamBuilder<Duration?>(
              stream: _player.durationStream,
              builder: (_, snapDuration) {
                return StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (_, snapPos) {
                    final duration = snapDuration.data ?? Duration.zero;
                    final position = snapPos.data ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          value: position.inMilliseconds.toDouble(),
                          max: duration.inMilliseconds.toDouble().clamp(1, double.infinity),
                          onChanged: (v) => _player.seek(
                            Duration(milliseconds: v.toInt()),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position)),
                            Text(_formatDuration(duration)),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Gap(24),
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (_, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                final processing = snapshot.data?.processingState;
                final isLoading = processing == ProcessingState.loading ||
                    processing == ProcessingState.buffering;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        final target = _player.position - const Duration(seconds: 10);
                        _player.seek(target < Duration.zero ? Duration.zero : target);
                      },
                    ),
                    const Gap(16),
                    isLoading
                        ? const CircularProgressIndicator()
                        : IconButton(
                            iconSize: 64,
                            icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                            onPressed: playing ? _player.pause : _player.play,
                          ),
                    const Gap(16),
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.forward_10),
                      onPressed: () => _player.seek(
                        _player.position + const Duration(seconds: 10),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
