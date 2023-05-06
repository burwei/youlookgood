import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  var isDone = false;
  var progress = 0.0;
  var percentageToBuy = 0;

  final youLookGoodText = "You look GOOD!";

  @override
  void initState() {
    super.initState();

    isDone = false;
    progress = 0;
    var random = Random();

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        setState(() {
          progress = 1.0;
          isDone = true;
          percentageToBuy = 50 + random.nextInt(50);
        });
      }

      setState(() {
        if (progress < 1.0) {
          progress += 0.01 * random.nextInt(5);
        }
      });
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
            // full screen mask and the fake process circle
            if (!isDone)
              Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints.expand(),
                color: const Color.fromARGB(100, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(value: progress),
                    Text(
                      'analyzing: ${(progress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Ubuntu',
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            // you look good text
            if (isDone)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 220),
                child: Text(
                  youLookGoodText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ),
            // percentage to buy text
            if (isDone)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 150),
                child: Text(
                  '$percentageToBuy% of girls say\nyou sould buy it!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ),
            // back to home button
            if (isDone)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.grey.shade700,
                    fixedSize: const Size(200, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'back to home',
                    style: TextStyle(
                        fontSize: 20, color: Colors.pink, fontFamily: 'Ubuntu'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
