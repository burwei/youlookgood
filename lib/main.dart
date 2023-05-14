import 'dart:async';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page/home_page.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required CameraDescription camera})
      : _camera = camera;

  final CameraDescription _camera;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.pink));
    return MaterialApp(
      title: 'YouLookGood',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(
        camera: _camera,
      ),
    );
  }
}
