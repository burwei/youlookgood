import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youlookgood/mark_object_page/drawing.dart';
import 'package:youlookgood/result_page/result_page.dart';

class MarkObjectPage extends StatefulWidget {
  const MarkObjectPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  MarkObjectPageState createState() => MarkObjectPageState();
}

class MarkObjectPageState extends State<MarkObjectPage> {
  List<Offset?> _points = [];
  Image? _image;

  void getPointsCallback(List<Offset?> points) {
    setState(() {
      _points = points;
    });
  }

  @override
  void initState() {
    super.initState();

    // If failed to load image and no previous image is stored,
    // naviage to last page to take a new picture.
    try {
      Image tmpImage = Image.file(File(widget.imagePath));
      _image = tmpImage;
    } catch (e) {
      if (_image == null) {
        Navigator.pop(context);
      }
    }
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
            // picture display
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: _image,
            ),
            // drawing board
            DrawingBoard(callback: getPointsCallback),
            // bottom bannar
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.pink,
                width: MediaQuery.of(context).size.width,
                height: 100,
              ),
            ),
            // submit button
            if (_points.isNotEmpty)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
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
                        builder: (context) => ResultPage(
                          imagePath: widget.imagePath,
                          drawnPoints: _points,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.submit,
                    style: const TextStyle(
                        fontSize: 20, color: Colors.pink, fontFamily: 'Ubuntu'),
                  ),
                ),
              ),
            // instruction text
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                AppLocalizations.of(context)!.makeItemInstruction,
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
