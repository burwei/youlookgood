import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../take_picture_page/take_picture.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.camera});

  final CameraDescription camera;

  final titleText = 'Let\'s answer the question:\n\n"How do I look?"';
  final databaseConnText =
      'Not connected to any database. No internet needed.\nWe know the answer already.\nWe always do.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // background
            Container(
              color: Colors.pink,
            ),
            // title text
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text(
                titleText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
            // start button
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: Colors.grey.shade700,
                  fixedSize: const Size(150, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TakePicturePage(camera: camera)),
                  );
                },
                child: const Text(
                  'start',
                  style: TextStyle(
                      fontSize: 20, color: Colors.pink, fontFamily: 'Ubuntu'),
                ),
              ),
            ),
            // database connection text
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                databaseConnText,
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
