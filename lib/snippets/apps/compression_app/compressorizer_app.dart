import 'dart:io';
import 'dart:ui';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleeter/model/base_app.dart';
import 'package:fleeter/model/cup_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

class CompressorizerApp extends AppBase {
  const CompressorizerApp({Key? key, required String appName}) : super(key: key, appName: appName);

  @override
  AppBaseState createState() => _CompressorizerAppState();
}

class _CompressorizerAppState extends AppBaseState {
  final _consoleController = TextEditingController();
  double compressionLevel = 0.5; // 0.0 to 1.0
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      key: _globalKey,
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Compressorizer'),
        ),
        child: Stack(
          children: [
            buildBackground(),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withOpacity(0)),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                    width: 300,
                    height: 400, // Increased height
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Compression Level: ${compressionLevel.toStringAsFixed(2)}'),
                        CupertinoWidgets.slider(
                          compressionLevel,
                          (value) => setState(() {
                            compressionLevel = value;
                          }),
                        ),
                        const SizedBox(height: 20),
                        CupertinoWidgets.button('Compress Files', () async {
                          await run(); // Passing context
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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

    // Use _globalKey.currentContext to get the current BuildContext
    showCupertinoModalPopup<void>(
      context: _globalKey.currentContext!,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text("Console Output"),
        message: SingleChildScrollView(
          child: CupertinoTextField(
            controller: _consoleController,
            maxLines: 20, // Adjust as needed
            readOnly: true,
          ),
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ),
    );

    _consoleController.text += 'Processing directory: $directoryPath\n';
    await processDirectory(directory);

    Navigator.pop(_globalKey.currentContext!); // Close the action sheet
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
    final image = img.decodeImage(await file.readAsBytes());
    if (image != null) {
      final compressedImage = img.encodeJpg(image, quality: (compressionLevel * 100).toInt());
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
        final decodedImage = img.decodeImage(archiveFile.content);
        if (decodedImage != null) {
          final compressedImage = img.encodeJpg(decodedImage, quality: (compressionLevel * 100).toInt());
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

  buildBackground() {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Colors.grey[900]!],
              ),
            ),
            child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() async {
  runApp(CompressorizerApp(
    appName: 'Compressorizer',
  ));
}
