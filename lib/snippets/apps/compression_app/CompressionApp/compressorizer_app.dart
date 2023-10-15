import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fleeter/model/base_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'compressorizer_app_state.dart';

class CompressorizerApp extends AppBase {
  const CompressorizerApp({Key? key, required String appName}) : super(key: key, appName: appName);

  @override
  AppBaseState createState() => CompressorizerAppState();
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
