import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleeter/model/base_app.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as p;

class CompressorizerApp extends AppBase {
  final _consoleController = TextEditingController();

  CompressorizerApp({super.key, required super.appName});

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

    runApp(MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: SingleChildScrollView(
            child: TextField(
              controller: _consoleController,
              style: TextStyle(color: Colors.white),
              maxLines: null,
              enabled: false,
            ),
          ),
        ),
      ),
    ));

    _consoleController.text += 'Processing directory: $directoryPath\n';
    await processDirectory(directory);

    runApp(CompressorizerApp(
      appName: 'Compressorizer',
    ));
  }

  Future<void> processDirectory(Directory directory) async {
    await for (var entity in directory.list(recursive: false)) {
      if (entity is File) {
        _consoleController.text += 'Processing file: ${entity.path}\n';
        await processFile(entity);
      } else if (entity is Directory) {
        _consoleController.text += 'Processing directory: ${entity.path}\n';
        await processDirectory(entity);
      }
    }
  }

  Future<void> processFile(File file) async {
    final extension = p.extension(file.path).toLowerCase();
    if (isImageFile(extension)) {
      _consoleController.text += 'Compressing image: ${file.path}\n';
      await compressImage(file);
    } else if (isArchiveFile(extension)) {
      _consoleController.text += 'Processing archive: ${file.path}\n';
      await processArchive(file);
    }
  }

  Future<void> compressImage(File file) async {
    final image = decodeImage(await file.readAsBytes());
    if (image != null) {
      final compressedImage = encodeJpg(image, quality: 75);
      await file.writeAsBytes(compressedImage);
      _consoleController.text += 'Compressed ${file.path}\n';
    }
  }

  Future<void> processArchive(File file) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final newArchive = Archive();

    for (var archiveFile in archive) {
      var newFile = archiveFile;
      if (isImageFile(p.extension(archiveFile.name).toLowerCase())) {
        final decodedImage = decodeImage(archiveFile.content);
        if (decodedImage != null) {
          final compressedImage = encodeJpg(decodedImage, quality: 75);
          newFile = ArchiveFile(archiveFile.name, compressedImage.length, compressedImage);
        }
      }

      newArchive.addFile(newFile);
    }

    final encoder = ZipEncoder();
    final compressedData = encoder.encode(newArchive);

    await file.writeAsBytes(compressedData!);
    _consoleController.text += 'Compressed files inside ${file.path}\n';
  }

  bool isImageFile(String extension) {
    return extension == '.png' || extension == '.jpg' || extension == '.jpeg' || extension == '.tiff' || extension == '.gif' || extension == '.bmp' || extension == '.ico' || extension == '.webp';
  }

  bool isArchiveFile(String extension) {
    return extension == '.jar' || extension == '.zip';
  }
}

void main() async {
  runApp(CompressorizerApp(
    appName: 'Compressorizer',
  ));
}
