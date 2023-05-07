import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youlookgood/mark_object_page/drawing.dart';
import 'package:youlookgood/result_page/result_page.dart';

class MarkObjectPage extends StatelessWidget {
  const MarkObjectPage({super.key, required this.imagePath});

  final String imagePath;
  final instructionText =
      'Mark the target object by painting.\nThe place you paint will be brighter later.';

  final StatefulWidget drawingBoard = const DrawingBoard();

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
              child: Image.file(File(imagePath)),
            ),
            // drawing board
            drawingBoard,
            // submit button
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
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
                        imagePath: imagePath,
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
