import 'dart:io';

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
import 'package:video_compress/video_compress.dart';

class CompressorizerAppState extends AppBaseState {
  double compressionLevel = 0.5; // 0.0 to 1.0
  bool isLoading = false;
  List<String> selectedFileTypes = ['.zip', '.jar'];

  Map<String, Future Function(File)> compressorSupportedFormats = {};

  @override
  void initState() {
    super.initState();
    compressorSupportedFormats = {
      '.png': compressImageDI,
      '.jpg': compressImageDI,
      '.jpeg': compressImageDI,
      // '.webp': compressImageDI,
      '.mp4': compressVideoVC,
    };
  }

  bool isImageFile(String extension) {
    return compressorSupportedFormats.keys.contains(extension);
  }

  bool isArchiveFile(String extension) {
    return extension == '.jar' || extension == '.zip';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Compressorizer'),
        ),
        child: Stack(
          children: <Widget>[
            buildBackground(context),
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
                          [
                            ...compressorSupportedFormats.keys,
                            '.jar',
                            '.zip',
                          ],
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
                              filter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver),
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
                    filter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver),
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
    setState(() => isLoading = true);
    try {
      final dirPath = await FilePicker.platform.getDirectoryPath();
      print('Directory Path: $dirPath'); // Debug log

      if (dirPath == null) {
        print('Directory path is null'); // Debug log
        return;
      }

      final dir = Directory(dirPath);

      if (!await dir.exists()) {
        print('Directory does not exist'); // Debug log
        throw Exception('Directory does not exist');
      }
      await processDir(dir);
    } catch (e) {
      print('Error in run method: $e'); // Debug log
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> processDir(Directory directory) async {
    print('Processing directory: ${directory.path}'); // Debug log
    await for (var entity in directory.list(recursive: false)) {
      if (entity is File) {
        print('Processing file: ${entity.path}'); // Debug log
        await processFile(entity);
      } else if (entity is Directory) {
        print('Found sub-directory: ${entity.path}'); // Debug log
        await processDir(entity);
      }
    }
  }

  Future<void> processFile(File file) async {
    print('Inside processFile for ${file.path}'); // Debug log
    final ext = p.extension(file.path).toLowerCase();
    if (!selectedFileTypes.contains(ext)) {
      print('File extension not selected: $ext'); // Debug log
      return;
    }
    if (compressorSupportedFormats.keys.contains(ext)) {
      final compressor = compressorSupportedFormats[ext];
      if (compressor != null) {
        print('Compressing file: ${file.path}'); // Debug log
        await compressor(file);
      }
    } else if (ext == '.jar' || ext == '.zip') {
      print('Processing archive: ${file.path}'); // Debug log
      await processArchive(file);
    }
  }

  Future<void> processArchive(File file) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final tempDir = await Directory.systemTemp.createTemp();
    final extractor = ZipExtractor(archive, tempDir.path);
    await extractor.extract();
    await processDir(tempDir);
    final newArchive = await buildArchiveFromDir(tempDir);
    await tempDir.delete(recursive: true);
    final compressedData = ZipEncoder().encode(newArchive);
    await file.writeAsBytes(compressedData!);
  }

  Future<void> compressImageDI(File file) async {
    final image = img.decodeImage(await file.readAsBytes());
    final ext = p.extension(file.path).toLowerCase();

    int quality = (compressionLevel * 100).toInt();

    if (image != null) {
      List<int>? compressedImage;
      switch (ext) {
        case '.png':
          compressedImage = img.encodePng(
            image,
          );
          break;
        case '.jpg':
        case '.jpeg':
          compressedImage = img.encodeJpg(image, quality: quality);
          break;
        default:
          return;
      }
      await file.writeAsBytes(compressedImage);
    }
  }

  Future<void> compressVideoVC(File file) async {
    VideoQuality videoQuality;
    if (compressionLevel <= 0.1) {
      videoQuality = VideoQuality.Res640x480Quality;
    } else if (compressionLevel <= 0.49) {
      videoQuality = VideoQuality.LowQuality;
    } else if (compressionLevel <= 0.60) {
      videoQuality = VideoQuality.MediumQuality;
    } else {
      videoQuality = VideoQuality.DefaultQuality;
    }

    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: videoQuality,
      deleteOrigin: false,
    );

    if (mediaInfo == null) {
      print('Compression failed'); // Debug log
      throw UnimplementedError('Compression failed');
    }
  }

  Future<Archive> buildArchiveFromDir(Directory directory) async {
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
}
