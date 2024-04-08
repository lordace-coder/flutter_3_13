import 'dart:io';

import 'package:flutter_3_13/models/projects_manager.dart';
import 'package:flutter_3_13/models/video_provider.dart';
import 'package:flutter_3_13/pages/audio_editing_page.dart';
import 'package:flutter_3_13/services/file_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).textTheme.displayLarge!.color,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Consumer<ProjectManager>(builder: (context, projectManager, _) {
        if (projectManager.files == null) {
          projectManager.getProjects();
        }
        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await projectManager.getProjects();
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                final files = projectManager.files;
                if (files == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListTile(
                  onTap: () async {
                    try {
                      await projectManager.openFileLocation(files[index]);
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      showToast("an error occurred", context: context);
                    }
                  },
                  title: Text(
                    basename(files![index].path),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge!.color),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellowAccent,
                    ),
                    child: Icon(
                      isAudioFile(files[index].path)
                          ? Icons.music_note
                          : Icons.play_arrow,
                    ),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            projectManager
                                .deleteFile(files[index])
                                .then((value) => showToast(
                                      "deleted",
                                      context: context,
                                    ));
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              Gap(6),
                              Text("delete"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Provider.of<FileProvider>(context, listen: false)
                                .editProject(files[index].path)
                                .then(
                                  (value) => _navigateTo(
                                    context,
                                    AudioEditingPage(
                                        file: File(files[index].path)),
                                  ),
                                );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.edit),
                              Gap(6),
                              Text("edit file"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            projectManager
                                .getFileProperties(files[index])
                                .then((props) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                        backgroundColor: const Color.fromARGB(
                                            255, 28, 28, 28),
                                        alignment: Alignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 18),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  props.title,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Gap(10),
                                                Text(
                                                  props.path,
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          'ltim-Regular'),
                                                ),
                                                const Gap(6),
                                                Text(props.size.bitLength
                                                    .toString()),
                                                const Gap(6),
                                                Text(
                                                  props.stat.modified
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]);
                                  });
                            });
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.info),
                              Gap(6),
                              Text("properties"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            try {
                              projectManager
                                  .saveToDownloads(files[index])
                                  .then((value) => showToast(
                                        "saved to downloads successfully",
                                        context: context,
                                      ));
                            } catch (e) {
                              showToast("request cannot be completed",
                                  context: context);
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.save),
                              Gap(6),
                              Text("save to downloads"),
                            ],
                          ),
                        ),
                      ];
                    },
                    // iconColor: Colors.grey[400],
                  ),
                );
              },
              itemCount: projectManager.files?.length,
            ),
          ),
        );
      }),
    );
  }
}

//helper function for page navigation
void _navigateTo(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}
