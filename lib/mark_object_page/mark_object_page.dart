import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youlookgood/mark_object_page/drawing.dart';
import 'package:youlookgood/result_page/result_page.dart';

class MarkObjectPage extends StatefulWidget {
  const MarkObjectPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  MarkObjectPageState createState() => MarkObjectPageState();
}

class MarkObjectPageState extends State<MarkObjectPage> {
  final instructionText =
      'Mark the target item by painting to make it looks brighter later.';
  List<Offset?> points = [];

  void getPointsCallback(List<Offset?> points) {
    setState(() {
      this.points = points;
    });
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
              child: Image.file(File(widget.imagePath)),
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
            if (points.isNotEmpty)
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
                          drawnPoints: points,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'submit',
                    style: TextStyle(
                        fontSize: 20, color: Colors.pink, fontFamily: 'Ubuntu'),
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
