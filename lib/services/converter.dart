import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';

bool convertVideoToAudio(String videoFilePath, String audioFilePath) {
  //todo handle errors
  bool result = false;
  FFmpegKit.execute('-i $videoFilePath -q:a 0 -map a $audioFilePath')
      .then((session) async {
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
      result = true;
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
      debugPrint("canceled");
    } else {
      // ERROR
      debugPrint("failed ${await session.getAllLogsAsString()}");
    }
    result = false;
  });
  return result;
}

bool changeAudioFormat(String oldPath, String newPath) {
  bool result = false;
debugPrint('-i $oldPath $newPath');
  FFmpegKit.execute('-i $oldPath $newPath').then((session) async {
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
      result = true;
      print('succesfull');
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
      debugPrint("canceled");
    } else {
      // ERROR
      debugPrint("failed ${await session.getAllLogsAsString()}");
    }

  });
  return result;
}
