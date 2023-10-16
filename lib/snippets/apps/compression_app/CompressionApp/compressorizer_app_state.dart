import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleeter/model/base_app.dart';
import 'package:fleeter/model/cup_widgets.dart';
import 'package:fleeter/snippets/apps/compression_app/CompressionApp/compressorizer_app.dart';
import 'package:fleeter/snippets/apps/compression_app/zips/zip_manip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:video_compress/video_compress.dart';

class CompressorizerAppState extends AppBaseState {
  int tinyUploadCounter = 0;
  int tinyUploadLimitPerKey = 0;
  double compressionLevel = 0.5; // 0.0 to 1.0
  bool isLoading = false;
  List<String> selectedFileTypes = ['.zip', '.jar'];
  String apiKey = ""; // Initialized as empty
  bool showApiKeyInput = false;

  Map<String, Future Function(File)> compressorSupportedFormats = {};

  @override
  void initState() {
    print("CompressorizerAppState init"); // Debug log
    submitForms(['paviye7880@ksyhtc.com']);
    super.initState();
    compressorSupportedFormats = {
      '.png': (File file) => compressImageTiny(file: file),
      '.jpg': (File file) => compressImageTiny(file: file),
      '.jpeg': (File file) => compressImageTiny(file: file),
      '.webp': (File file) => compressImageTiny(file: file),

      // '.png': compressImageDI,
      // '.jpg': compressImageDI,
      // '.jpeg': compressImageDI,
      // '.webp': compressImageDI,

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

  void updateApiKey(String newApiKey) {
    setState(() {
      apiKey = newApiKey;
    });
  }

  void updateUploadLimit(int newLimit) {
    setState(() {
      tinyUploadLimitPerKey = newLimit;
    });
  }

  void resetTinyUploadCounter() {
    setState(() {
      tinyUploadCounter = 0;
    });
  }

  void incrementTinyUploadCounter() {
    setState(() {
      tinyUploadCounter += 1;
    });
  }

  Future<void> showApiKeyDialog(BuildContext context) async {
    String tempApiKey = apiKey;
    int tempUploadLimit = tinyUploadLimitPerKey;
    await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Enter New API Key and Upload Limit'),
          content: Column(
            children: [
              CupertinoTextField(
                placeholder: 'API Key',
                onChanged: (String value) {
                  tempApiKey = value;
                },
              ),
              CupertinoTextField(
                placeholder: 'Upload Limit',
                onChanged: (String value) {
                  tempUploadLimit = int.tryParse(value) ?? tinyUploadLimitPerKey;
                },
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Update'),
              onPressed: () {
                updateApiKey(tempApiKey);
                updateUploadLimit(tempUploadLimit);
                resetTinyUploadCounter(); // Add this line to reset the counter
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  height: 550,
                  width: 400,
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
                        //spacer
                        const SizedBox(height: 20.0),

                        // the title for the button
                        const Text('TinyPNG API Key'),
                        //the switch for the button
                        CupertinoSwitch(
                          value: showApiKeyInput,
                          onChanged: (bool value) {
                            setState(() {
                              showApiKeyInput = value;
                            });
                          },
                        ),
                        if (showApiKeyInput)
                          // the text place
                          CupertinoTextField(
                            placeholder: 'Enter TinyPNG API Key',
                            onChanged: (String value) {
                              apiKey = value;
                              tinyUploadCounter = 0;
                            },
                          ),
                        if (showApiKeyInput)
                          // numberField
                          CupertinoTextField(
                            placeholder: 'Enter TinyPNG Upload Limit',
                            onChanged: (String value) {
                              tinyUploadLimitPerKey = int.parse(value);
                            },
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

      if (apiKey.isNotEmpty) {
        // Second pass for Tiny compression
        print('Starting second pass for Tiny compression'); // Debug log
        await processDirForTiny(dir);
      }
    } catch (e) {
      print('Error in run method: $e'); // Debug log
    } finally {
      setState(() => isLoading = false);
      setState(() => tinyUploadCounter = 0);
      setState(() => tinyUploadLimitPerKey = 0);
    }
  }

  Future<void> processDirForTiny(Directory directory) async {
    print('Processing directory for Tiny: ${directory.path}'); // Debug log
    await for (var entity in directory.list(recursive: false)) {
      if (entity is File) {
        print('Processing file for Tiny: ${entity.path}'); // Debug log
        await processFileForTiny(entity);
      } else if (entity is Directory) {
        print('Found sub-directory for Tiny: ${entity.path}'); // Debug log
        await processDirForTiny(entity);
      }
    }
  }

  Future<void> processFileForTiny(File file) async {
    print('Inside processFileForTiny for ${file.path}'); // Debug log
    final ext = p.extension(file.path).toLowerCase();
    if (!selectedFileTypes.contains(ext)) {
      print('File extension not selected for Tiny: $ext'); // Debug log
      return;
    }
    if (compressorSupportedFormats.keys.contains(ext)) {
      print('Compressing file with Tiny: ${file.path}'); // Debug log
      await compressImageTiny(file: file);
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
        print('Compressing file with DI: ${file.path}'); // Debug log
        await compressImageDI(file); // Use DI first
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

  Future<void> compressImageTiny({required File file}) async {
    var apiKey = this.apiKey;
    if (apiKey.isEmpty) {
      return;
    }

    var url = "api.tinify.com";
    Uri uri = Uri.https(url, "/shrink");
    var auth = "api:$apiKey";
    var authData = base64Encode(utf8.encode(auth));
    var authorizationHeader = "Basic $authData";
    var headers = {
      "Accept": "application/json",
      "Authorization": authorizationHeader,
    };

    final ext = p.extension(file.path).toLowerCase();

    // Read the file's bytes
    var fileBytes = await file.readAsBytes();

    // Switch case for file type
    switch (ext) {
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.webp':
        print("Uploading image to TinyPNG...");
        await uploadToTinyPNG(uri, headers, fileBytes, file);
        break;
      default:
        return;
    }
  }

  Future<List<int>> downloadCompressedImageFromTinyPNG(http.Response response) async {
    var json = jsonDecode(utf8.decode(response.bodyBytes));
    String? url = json['output']['url'];
    if (url == null) {
      throw Exception('Compressed image URL not found in the response.');
    }
    Uri uri = Uri.parse(url);
    var dio = Dio();
    List<int> compressedBytes = [];
    try {
      await dio.get<List<int>>(
        uri.toString(),
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (count, total) {
          // Optional: You can track download progress here.
        },
      ).then((rsp) {
        if (rsp.statusCode == 200) {
          compressedBytes = rsp.data!;
        } else {
          throw Exception('Failed to download compressed image.');
        }
      });
    } catch (e) {
      throw Exception('Download error: $e');
    }
    print('Downloaded compressed image from TinyPNG');
    print('debug: url is -> $url');
    return compressedBytes;
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

  Future<void> uploadToTinyPNG(Uri uri, Map<String, String> headers, List<int> fileBytes, File file) async {
    try {
      // Check if counter has reached the limit
      if (tinyUploadCounter >= tinyUploadLimitPerKey) {
        await showApiKeyDialog(context); // Show dialog for new API key
        return; // Exit the method
      }

      print("Attempting Upload:  tinyUploadCounter: $tinyUploadCounter : tinyUploadLimitPerKey: $tinyUploadLimitPerKey");

      var response = await http.post(uri, headers: headers, body: fileBytes);
      if (response.statusCode != 201) {
        print("Upload failed. Status code is ${response.statusCode}");
      } else {
        incrementTinyUploadCounter(); // Increment the counter
        var compressedBytes = await downloadCompressedImageFromTinyPNG(response);
        await file.writeAsBytes(compressedBytes);
        var json = jsonDecode(utf8.decode(response.bodyBytes));
        var jsonString = jsonEncode(json);
        print("Upload success. JSON: $jsonString");
        print("New Counter -> tinyUploadCounter: $tinyUploadCounter : tinyUploadLimitPerKey: $tinyUploadLimitPerKey");
      }
    } catch (e, ee) {
      print("Upload error: $e");
      print(ee);
    }
  }
}
