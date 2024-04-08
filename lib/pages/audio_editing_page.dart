import 'dart:io';

import 'package:flutter_3_13/models/video_provider.dart';
import 'package:flutter_3_13/services/converter.dart';
import 'package:flutter_3_13/services/file_type.dart';
import 'package:flutter_3_13/widgets/music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

const TextStyle dropDownStyles = TextStyle(color: Colors.black, fontSize: 18);

class AudioEditingPage extends StatefulWidget {
  AudioEditingPage({super.key, required this.file});

  final File file;

  // final String filePath;
  @override
  State<AudioEditingPage> createState() => _AudioEditingPageState();
}

class _AudioEditingPageState extends State<AudioEditingPage> {
  String audioFormat = '.mp3';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Flex(
              direction: Axis.vertical,
              children: [
                // from audio
                SizedBox(
                  height: 130,
                  child: MusicPlayer(filePath: widget.file.path),
                ),
                const Gap(20),
                // convert to :
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Convert to:',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(20),
                    DropdownButton(
                        value: audioFormat,
                        items: const [
                          DropdownMenuItem(
                            value: '.mp3',
                            child: Text(
                              ".mp3",
                              style: dropDownStyles,
                            ),
                          ),
                          DropdownMenuItem(
                            value: '.wav',
                            child: Text(
                              ".wav",
                              style: dropDownStyles,
                            ),
                          ),
                          DropdownMenuItem(
                            value: '.aac',
                            child: Text(
                              ".aac",
                              style: dropDownStyles,
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val == getFileExtension(widget.file.path)) return;
                          setState(() {
                            audioFormat = val!;
                          });
                        }),
                  ],
                ),
                ActionChip.elevated(
                  label: const Text(
                    "convert",
                    style: dropDownStyles,
                  ),
                  onPressed: () async {
                    if (audioFormat == getFileExtension(widget.file.path)) {
                      showToast(
                          "cant convert audio file to its existing extension",
                          context: context);
                      return;
                    }
                    final String newAudioPath =
                        await getFileDir(widget.file, audioFormat);
                    if (await File(newAudioPath).exists()) {
                      showToast("file with this title already exists",
                          context: context);
                    } else {
                      // convert to format
                      final result =
                          changeAudioFormat(widget.file.path, newAudioPath);
                      if (result) {
                        showToast("converted format succesfully",
                            context: context);
                      } else {
                        showToast("sorry an error occured", context: context);
                      }
                    }
                  },
                ),
              ],
            ),
            if (loading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black45,
                child: const Center(
                  child:
                      CircularProgressIndicator(color: Colors.deepOrangeAccent),
                ),
              )
          ],
        ),
      ),
    );
  }
}

Future<String> getFileDir(File file, String newExt) async {
  String name = path.basename(file.path);
  String ext = getFileExtension(file.path);
  name = name.replaceFirst(RegExp(ext), newExt);
  final baseDir = await getExternalStorageDirectory();

  return '${baseDir!.path}/$name';
}
