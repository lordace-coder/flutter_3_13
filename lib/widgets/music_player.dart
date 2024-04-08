import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';

/// widget for playing audio using the just_audio package
class MusicPlayer extends StatefulWidget {
  MusicPlayer({super.key, required this.filePath}) {
    player.setFilePath(filePath);
  }

  final player = AudioPlayer();

  final String filePath;

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  double playerPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    File file = File(widget.filePath);
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              file.uri.pathSegments.last,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.player.playing) {
                    widget.player.pause();
                  } else {
                    widget.player.play();
                  }
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent,
                  ),
                  child: StreamBuilder(
                      stream: widget.player.playingStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Icon(
                              snapshot.data! ? Icons.pause : Icons.play_arrow,
                              color: Colors.white60);
                        }
                        return const Icon(Icons.play_arrow);
                      }),
                ),
              ),
              const Gap(20),
              StreamBuilder(
                  stream: widget.player.positionStream,
                  builder: (context, snapshot) {
                    playerPosition = getPercentage(
                            num: widget.player.position.inMilliseconds,
                            total: widget.player.duration?.inMilliseconds)
                        .toDouble();
                    if (playerPosition >= 100.0) {
                      widget.player.seek(Duration.zero);
                      widget.player.stop();
                    }
                    return Expanded(
                      child: Slider(
                        value: playerPosition,
                        onChangeEnd: (newValue) {
                          widget.player.pause();

                          setState(() {});
                          widget.player.seek(Duration(
                              milliseconds: setPercentage(
                                  percentage: newValue.toInt(),
                                  total:
                                      widget.player.duration?.inMilliseconds)));

                          widget.player.play();

                          setState(() {});
                        },
                        max: 100.0,
                        onChanged: (double value) {},
                      ),
                    );
                  })
            ],
          ),
        ],
      ),
    );
  }
}

int getPercentage({required int num, required int? total}) {
  if (total == null) {
    total = 0;
    return total;
  }
  final result = (num * 100) ~/ total;
  return result;
}

int setPercentage({required int percentage, required int? total}) {
  if (total == null) {
    total = 0;
    return total;
  }
  final result = ((percentage / 100) * total).toInt();
  return result;
}
