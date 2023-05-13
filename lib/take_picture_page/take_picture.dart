import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youlookgood/mark_object_page/mark_object_page.dart';

// This page is modify from offical tutorial:
// https://docs.flutter.dev/cookbook/plugins/picture-using-camera#complete-example
class TakePicturePage extends StatefulWidget {
  const TakePicturePage({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePicturePageState createState() => TakePicturePageState();
}

class TakePicturePageState extends State<TakePicturePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  final instructionText = 'Take a picture of your girl with the target object.';

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // background
            Container(
              color: Colors.pink,
            ),
            // camera preview
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            // bottom bannar
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.pink,
                width: MediaQuery.of(context).size.width,
                height: 100,
              ),
            ),
            // capture button
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  onPressed: () async {
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Some camera setting: orientation, flash and  focus mode.
                      _controller
                          .lockCaptureOrientation(DeviceOrientation.portraitUp);
                      _controller.setFlashMode(FlashMode.off);
                      _controller.setFocusMode(FocusMode.auto);

                      // Attempt to take a picture and get the file `image`
                      // where it was saved.
                      final image = await _controller.takePicture();

                      if (!mounted) return;

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            // Pass the automatically generated path to MarkObjectPage widget.
                            builder: (context) =>
                                MarkObjectPage(imagePath: image.path)),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.pink,
                    size: 50,
                  ),
                ),
              ),
            ),
            // instruction text
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                instructionText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
