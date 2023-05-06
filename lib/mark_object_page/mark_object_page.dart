import 'dart:io';

import 'package:flutter/material.dart';

class MarkObjectPage extends StatelessWidget {
  const MarkObjectPage({super.key, required this.imagePath});

  final String imagePath;
  final instructionText =
      'Mark the target object by painting.\nThe place you paint will be brighter later.';

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
