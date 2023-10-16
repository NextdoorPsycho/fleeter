import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fleeter/model/base_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'compressorizer_app_state.dart';

class CompressorizerApp extends AppBase {
  const CompressorizerApp({Key? key, required String appName}) : super(key: key, appName: appName);

  @override
  AppBaseState createState() => CompressorizerAppState();
}

void main() async {
  var emails = ['email1@example.com', 'email2@example.com', 'email3@example.com'];
  var successfulEmails = await submitForms(emails);
  print('Successful emails: $successfulEmails');
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

Future<List<String>> submitForms(List<String> emails) async {
  List<String> successfulEmails = [];
  print('submitForms');
  for (var email in emails) {
    var response = await http.post(
      Uri.parse('https://tinypng.com/developers'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'name': 'anamehere',
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      successfulEmails.add(email);
    }
  }

  return successfulEmails;
}
