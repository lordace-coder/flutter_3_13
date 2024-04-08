import 'dart:io';

import 'package:flutter_3_13/models/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoEditingPage extends StatefulWidget {
  const VideoEditingPage({super.key, this.video});

  final File? video;

  @override
  State<VideoEditingPage> createState() => _VideoEditingPageState();
}

class _VideoEditingPageState extends State<VideoEditingPage> {
  late VideoPlayerController? player;
  late Future<void> _initializeVideoPlayer;
  bool _playing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player = VideoPlayerController.file(widget.video!);

    _initializeVideoPlayer = player!.initialize();
    player!.setLooping(true);
  }

  @override
  void dispose() {
    player!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_playing) {
            _playing = false;
            player!.pause();
          } else {
            _playing = true;
            player!.play();
          }
        },
        child: Icon(_playing ? Icons.pause : Icons.play_arrow,
            color: Colors.deepPurple),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _initializeVideoPlayer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPlayer(player!),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:
                          VideoProgressIndicator(player!, allowScrubbing: true),
                    ),
                    const Gap(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              //todo ask user to type in desired video title
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    final textController =
                                        TextEditingController();
                                    return AlertDialog(
                                      backgroundColor: Colors.black,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Provider.of<FileProvider>(context,
                                                    listen: false)
                                                .convert(textController.text)
                                                .then((successful) {
                                              debugPrint(
                                                  "convert status is $successful");
                                              if (successful) {
                                                toast("converted successfully",
                                                    context);
                                                // todo update projectList via provider
                                              } else {
                                                toast("sorry an error occurred",
                                                    context);
                                              }
                                            });
                                          },
                                          child: const Text("ok"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            textController.clear();
                                          },
                                          child: const Text("clear"),
                                        ),
                                      ],
                                      title: Text("audio name".toUpperCase()),
                                      content: TextField(
                                        controller: textController,
                                      ),
                                    );
                                  });
                            },
                            style: const ButtonStyle(
                              textStyle:
                                  MaterialStatePropertyAll<TextStyle>(TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                            child: const Text('convert to mp3')),
                      ],
                    )
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.orangeAccent,
                ),
              );
            }),
      ),
    );
  }
}

void toast(String message, BuildContext context) {
  showToast(message,
      animation: StyledToastAnimation.fade,
      backgroundColor: Colors.white,
      textStyle: const TextStyle(color: Colors.black),
      context: context);
}
