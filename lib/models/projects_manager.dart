import 'dart:io';

import 'package:flutter_3_13/models/file_properties.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectManager extends ChangeNotifier {
  late final SharedPreferences _pref;
  List<FileSystemEntity>? files;

  void initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future<void> getProjects() async {
    Directory? directory =
        await getExternalStorageDirectory(); // Replace with the desired directory
    files = directory!.listSync(recursive: false, followLinks: false);
    notifyListeners();
  }

  Future<void> deleteFile(FileSystemEntity file) async {
    await file.delete();
    await getProjects();
  }

  Future<void> openFileLocation(FileSystemEntity file) async {
    String fileUrl = file.path;
    "especially";
    try {
      await OpenFile.open(fileUrl);
    } catch (e) {
      throw 'Could not launch $fileUrl';
    }
  }

  Future<FileProperties> getFileProperties(FileSystemEntity file) async {
    File current = File(file.path);
    FileStat stats = await file.stat();
    FileProperties props = FileProperties(
        title: current.uri.pathSegments.last, path: current.path, stat: stats);
    return props;
  }

  Future<void> saveToDownloads(FileSystemEntity file) async {
    final rootDir = await getExternalStorageDirectory();
    Directory? downloadsDir =
        Directory("${rootDir!.parent.parent.parent.parent.path}/Music");
    //await getExternalStorageDirectory();
    print('$downloadsDir ${downloadsDir.existsSync()}');
    // get file name
    String fileName = path.basename(file.path);
    if (file.existsSync()) {
      List<int> fileBytes = File(file.path)
          .readAsBytesSync(); //read file and save into a variable
      String newFilePath = "${downloadsDir.path}/$fileName";
      if (File(newFilePath).existsSync()) {
        newFilePath += DateTime.now().millisecondsSinceEpoch.toString();
      }
      //create a new file object
      File newFile = File(newFilePath);
      newFile.writeAsBytes(fileBytes);
    }
  }
}
