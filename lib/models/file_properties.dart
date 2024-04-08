  // properties['title'] = current.uri.pathSegments.last;
  // properties['path'] = current.path;
  // properties['size'] = stats.size;
  // properties['changed'] = stats.changed;

import 'dart:io';

class FileProperties{
  final String title;
  final String path;
  final int size;
  final FileStat stat;

  FileProperties({required this.title, required this.path, required this.stat}):size = stat.size;
}