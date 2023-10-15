import 'dart:ui';

import 'package:fleeter/model/base_app.dart';
import 'package:fleeter/snippets/apps/compression_app/CompressionApp/compressorizer_app.dart';
import 'package:fleeter/snippets/apps/demo_file_app/demo_file_app.dart';
import 'package:flutter/material.dart';

class MasterListScreen extends StatelessWidget {
  const MasterListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AppBase> appLists = [
      DemoFileApp(
        appName: 'Demo',
      ),
      const CompressorizerApp(
        appName: "Compressorizer",
      )
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.grey[500]!.withOpacity(0.5),
              elevation: 0,
              title: const Text('Programming Challenges', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: ExpansionTile(
                      title: const Text('App Projects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      children: appLists.map((app) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(app.appName, style: const TextStyle(color: Colors.white)),
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
        ],
      ),
    );
  }
}
