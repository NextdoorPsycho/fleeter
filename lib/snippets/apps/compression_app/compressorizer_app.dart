import 'dart:io';
import 'dart:ui';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleeter/model/base_app.dart';
import 'package:fleeter/model/cup_widgets.dart';
import 'package:fleeter/snippets/apps/compression_app/zips/zip_manip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

class CompressorizerApp extends AppBase {
  const CompressorizerApp({Key? key, required String appName}) : super(key: key, appName: appName);

  @override
  AppBaseState createState() => _CompressorizerAppState();
}

class _CompressorizerAppState extends AppBaseState {
  double compressionLevel = 0.5; // 0.0 to 1.0
  final GlobalKey _globalKey = GlobalKey();
  bool isLoading = false;
  List<String> selectedFileTypes = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Compressorizer'),
        ),
        child: Stack(
          children: <Widget>[
            buildBackground(),
            SafeArea(
              child: Center(
                child: GlassContainer.frostedGlass(
                  height: 500,
                  width: 300,
                  borderRadius: BorderRadius.circular(15.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Compression Level: ${(compressionLevel * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        CupertinoSlider(
                          value: compressionLevel,
                          onChanged: (value) => setState(() {
                            compressionLevel = value;
                          }),
                        ),
                        const SizedBox(height: 20.0),
                        ...CupertinoWidgets.checkboxList(
                          ['.png', '.jpg', '.jpeg', '.tiff', '.gif', '.bmp', '.ico', '.webp', '.jar', '.zip'],
                          selectedFileTypes,
                          (value) => setState(() {
                            selectedFileTypes = value;
                          }),
                        ),
                        const SizedBox(height: 20.0),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await run();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                height: 50.0,
                                width: 200.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[500]!.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Compress Files',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[500]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
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
    print('run function called'); // Add this line

    try {
      setState(() {
        isLoading = true;
      });

      final directoryPath = await FilePicker.platform.getDirectoryPath();
      print('Directory path: $directoryPath'); // Add this line

      if (directoryPath == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        throw Exception('Directory does not exist');
      }

      await processDirectory(directory);
    } catch (e) {
      print('Error: $e'); // Add this line
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> processDirectory(Directory directory) async {
    await for (var entity in directory.list(recursive: false)) {
      if (entity is File) {
        await processFile(entity);
      } else if (entity is Directory) {
        await processDirectory(entity);
      }
    }
  }

  void dupdate(String message) {
    print(message);
    setState(() {}); // Trigger a rebuild to refresh the UI
  }

  Future<void> processFile(File file) async {
    final extension = p.extension(file.path).toLowerCase();
    print('Processing file with extension: $extension');
    // Only process file if the extension is in the selectedFileTypes
    if (selectedFileTypes.contains(extension)) {
      if (isImageFile(extension)) {
        await compressImage(file);
        dupdate('Compressed: ${file.path}');
      } else if (isArchiveFile(extension)) {
        await processArchive(file);
        dupdate('Compressed: ${file.path}');
      }
    }
  }

  Future<void> compressImage(File file) async {
    print('compressImage function called on file: ${file.path}');
    setState(() {
      isLoading = true;
    });

    final image = img.decodeImage(await file.readAsBytes());
    if (image != null) {
      final compressedImage = img.encodeJpg(image, quality: (compressionLevel * 100).toInt());
      await file.writeAsBytes(compressedImage);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> processArchive(File file) async {
    print('processArchive function called on file: ${file.path}');
    setState(() {
      isLoading = true;
    });

    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final tempDir = await Directory.systemTemp.createTemp();
    final extractor = ZipExtractor(archive, tempDir.path);
    await extractor.extract();

    await processDirectory(tempDir);

    final newArchive = await buildArchiveFromDirectory(tempDir);
    await tempDir.delete(recursive: true);

    final encoder = ZipEncoder();
    final compressedData = encoder.encode(newArchive);

    await file.writeAsBytes(compressedData!);

    setState(() {
      isLoading = false;
    });
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
  runApp(const CompressorizerApp(
    appName: 'Compressorizer',
  ));
}

Future<Archive> buildArchiveFromDirectory(Directory directory) async {
  final archive = Archive();
  await for (var entity in directory.list(recursive: true)) {
    if (entity is File) {
      final data = await entity.readAsBytes();
      final archiveFile = ArchiveFile(p.relative(entity.path, from: directory.path), data.length, data);
      archive.addFile(archiveFile);
    }
  }
  return archive;
}
