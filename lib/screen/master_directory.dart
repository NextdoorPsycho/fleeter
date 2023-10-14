import 'dart:ui';

import 'package:fleeter/model/base_app.dart';
import 'package:fleeter/snippets/apps/demo_file_app/demo_file_app.dart';
import 'package:flutter/material.dart';

import '../snippets/apps/compression_app/compressorizer_app.dart';

class MasterListScreen extends StatelessWidget {
  const MasterListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AppBase> appLists = [
      DemoFileApp(
        appName: 'Demo',
      ),
      CompressorizerApp(
        appName: "Compressorizer",
      )
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Programming Challenges'),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    title: const Text('App Projects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    children: appLists.map((app) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(app.appName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => app),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
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
