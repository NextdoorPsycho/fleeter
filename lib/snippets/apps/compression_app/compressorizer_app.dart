import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleeter/model/base_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';

class CompressorizerApp extends AppBase {
  const CompressorizerApp({super.key, required super.appName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await run();
            },
            child: const Text('Compress Files'),
          ),
        ),
      ),
    );
  }

  Future<void> run() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      return;
    }

    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      throw Exception('Directory does not exist');
    }

    await _processDirectory(directory);
  }

  Future<void> _processDirectory(Directory directory) async {
    await for (var entity in directory.list(recursive: false)) {
      if (entity is File) {
        await _processFile(entity);
      } else if (entity is Directory) {
        await _processDirectory(entity);
      }
    }
  }

  Future<void> _processFile(File file) async {
    final extension = p.extension(file.path).toLowerCase();
    if (extension == '.png' || extension == '.jpg' || extension == '.jpeg' || extension == '.tiff' || extension == '.gif' || extension == '.bmp' || extension == '.ico' || extension == '.webp') {
      await _compressImage(file);
    } else if (extension == '.jar' || extension == '.zip') {
      await _processArchive(file);
    }
  }

  Future<void> _compressImage(File file) async {
    final image = decodeImage(await file.readAsBytes());
    if (image != null) {
      final compressedImage = encodeJpg(image, quality: 75);
      await file.writeAsBytes(compressedImage);
      if (kDebugMode) {
        print('Compressed ${file.path}');
      }
    }
  }

  Future<void> _processArchive(File file) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final tempDir = await Directory.systemTemp.createTemp();
    final encoder = ZipFileEncoder();
    encoder.create('${tempDir.path}/${p.basename(file.path)}');

    final newArchive = Archive();

    for (var archiveFile in archive) {
      var newFile = archiveFile;
      if (_isImageFile(archiveFile)) {
        final decodedImage = decodeImage(archiveFile.content);
        if (decodedImage != null) {
          final compressedImage = encodeJpg(decodedImage, quality: 75);
          newFile = ArchiveFile(archiveFile.name, compressedImage.length, compressedImage);
        }
      }

      newArchive.addFile(newFile);
    }

    for (var newFile in newArchive) {
      encoder.addFile(File('${tempDir.path}/${newFile.name}'));
    }

    encoder.close();
    await file.delete();
    await File('${tempDir.path}/${p.basename(file.path)}').rename(file.path);
    if (kDebugMode) {
      print('Compressed files inside ${file.path}');
    }
  }

  bool _isImageFile(ArchiveFile file) {
    final extension = p.extension(file.name).toLowerCase();
    return extension == '.png' || extension == '.jpg' || extension == '.jpeg' || extension == '.tiff' || extension == '.gif' || extension == '.bmp' || extension == '.ico' || extension == '.webp';
  }
}

void main() async {
  final shell = Shell();

  await shell.run('''
  osascript -e 'tell application "Terminal" to do script "dart ${Platform.script.toFilePath()}"'
  ''');

  runApp(const CompressorizerApp(
    appName: 'Compressorizer',
  ));
}
