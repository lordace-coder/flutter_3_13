
import 'package:path/path.dart' as path;

bool isAudioFile(String filePath) {
  String extension = path.extension(filePath).toLowerCase();
  return extension == '.mp3' ||
      extension == '.wav' ||
      extension == '.aac' ||
      extension == '.ogg'; // Add more audio file extensions as needed
}

bool isVideoFile(String filePath) {
  String extension = path.extension(filePath).toLowerCase();
  return extension == '.mp4' ||
      extension == '.avi' ||
      extension == '.mov' ||
      extension == '.mkv'; // Add more video file extensions as needed
}


String getFileExtension(String filePath){
  return path.extension(filePath).toLowerCase();
}