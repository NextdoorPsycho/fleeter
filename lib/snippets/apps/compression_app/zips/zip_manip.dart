import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

class ZipExtractor {
  final Archive archive;
  final String outputPath;

  ZipExtractor(this.archive, this.outputPath);

  Future<void> extract() async {
    for (var file in archive) {
      final filePath = p.join(outputPath, file.name);
      if (file.isFile) {
        final data = file.content as List<int>;
        await File(filePath).create(recursive: true).then((f) => f.writeAsBytes(data));
      } else {
        await Directory(filePath).create(recursive: true);
      }
    }
  }
}
