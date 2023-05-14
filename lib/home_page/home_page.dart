import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../take_picture_page/take_picture.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _titleText = 'Let\'s answer the question:\n\n"How do I look?"';
  bool _showAboutDialog = false;

  void aboutDiagramBtnCallback() {
    setState(() {
      _showAboutDialog = false;
    });
  }

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
                _titleText,
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
                      builder: (context) =>
                          TakePicturePage(camera: widget.camera),
                    ),
                  );
                },
                child: const Text(
                  'start',
                  style: TextStyle(
                      fontSize: 20, color: Colors.pink, fontFamily: 'Ubuntu'),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAboutDialog = true;
                  });
                },
                child: Text(
                  "about",
                  style: TextStyle(
                    fontFamily: "Ubuntu",
                    fontSize: 15,
                    color: Colors.pink.shade100,
                  ),
                ),
              ),
            ),
            // about dialog
            if (_showAboutDialog)
              Container(
                alignment: Alignment.center,
                color: const Color.fromARGB(150, 0, 0, 0),
                child: MyAboutDialog(btnCallback: aboutDiagramBtnCallback),
              ),
          ],
        ),
      ),
    );
  }
}
