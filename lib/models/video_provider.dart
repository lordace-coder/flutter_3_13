import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import '../services/converter.dart';

enum CurrentState { error, loading, defaultState }

enum SelectedFileType { video, audio }

class FileProvider extends ChangeNotifier {
  File? file;
  CurrentState state = CurrentState.defaultState;
  SelectedFileType? selectedFileType;

  Future<bool> checkAndRequestPermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      Map<Permission, PermissionStatus> status = await [
        Permission.storage,
      ].request();
      if (status[Permission.storage] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> getVideo() async {
    final bool _can_select_video = await checkAndRequestPermission();
    if (_can_select_video) {
      //  select video
      String? filePath = await FilePicker.platform
          .pickFiles(
            type: FileType.video,
            // Specify the allowed video file extensions
          )
          .then((result) => result!.files.single.path)
          .catchError((err) => debugPrint("error occured cause off $err"));

      if (filePath != null) {
        file = File(filePath);
        selectedFileType = SelectedFileType.video;
        return true;
      } else {
        // No video file was selected
        // Handle this scenario accordingly
        debugPrint('No video file selected');
      }
    }
    notifyListeners();
    return false;
  }

  Future<bool> getAudio() async {
    final bool _can_select_video = await checkAndRequestPermission();
    if (_can_select_video) {
      //  select video
      String? filePath = await FilePicker.platform
          .pickFiles(
            type: FileType.audio,
            // Specify the allowed video file extensions
            allowCompression: false,
          )
          .then((result) => result!.files.single.path)
          .catchError((err) => debugPrint("error occurred cause off $err"));

      if (filePath != null) {
        file = File(filePath);
        selectedFileType = SelectedFileType.audio;
        return true;
      } else {
        // No video file was selected
        // Handle this scenario accordingly
        debugPrint('No video file selected');
      }
    }
    notifyListeners();
    return false;
  }

  void clearVideo() async {
    file = null;
    notifyListeners();
  }

  Future<bool> convert(String? title) async {
    if (title == '' || title == null) {
      title = "audio ${DateTime.now().microsecondsSinceEpoch.toString()}";
    }
    state = CurrentState.loading;
    notifyListeners();
    Directory? dir = await getExternalStorageDirectory();
    String audioFilePath =
        path.join(dir!.path, "$title.mp3"); // Construct the full file path
    try {
      convertVideoToAudio(file!.path, audioFilePath);
      state = CurrentState.defaultState;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editProject(String filePath) async {
    try {
      file = File(filePath);
      selectedFileType = SelectedFileType.audio;
      return true;
    } catch (e) {
      return false;
    }
  }
}
