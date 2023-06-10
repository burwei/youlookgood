import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'mask.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key, required this.imagePath, required this.drawnPoints});

  final String imagePath;
  final List<Offset?> drawnPoints;

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  bool _isDone = false;
  double _progress = 0.0;
  int _percentageToBuy = 0;
  Image? _image;

  @override
  void initState() {
    super.initState();

    // If failed to load image and no previous image is stored,
    // naviage naviage to home page.
    try {
      Image tmpImage = Image.file(File(widget.imagePath));
      _image = tmpImage;
    } catch (e) {
      if (_image == null) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }

    // Start the fake progress loading.
    _isDone = false;
    _progress = 0;
    var random = Random();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _progress = 1.0;
            _isDone = true;
            _percentageToBuy = 50 + random.nextInt(50);
          });
        }
      }
      if (mounted) {
        setState(() {
          if (_progress < 1.0) {
            _progress += 0.01 * random.nextInt(5);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Remove the image file from cache folder.
    var imgFile = File(widget.imagePath);
    imgFile.exists().then((isExist) {
      if (isExist) {
        imgFile.delete();
      }
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
            // display picture
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: _image,
            ),
            // target object mask
            CustomPaint(
              painter: Mask(widget.drawnPoints),
              // picture display
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            // full screen mask and the fake process circle
            if (!_isDone)
              Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints.expand(),
                color: const Color.fromARGB(100, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(value: _progress),
                    Text(
                      '${AppLocalizations.of(context)!.analyzing}${(_progress * 100).round()}%',
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
            if (_isDone)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 220),
                child: Text(
                  AppLocalizations.of(context)!.youLookGood,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ),
            // percentage to buy text
            if (_isDone)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 160),
                child: Text(
                  '$_percentageToBuy%${AppLocalizations.of(context)!.girlSays}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Ubuntu',
                  ),
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
            // back to home button
            if (_isDone)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
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
                  child: Text(
                    AppLocalizations.of(context)!.finish,
                    style: const TextStyle(
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
