import 'package:flutter/material.dart';

class MyAboutDialog extends StatelessWidget {
  const MyAboutDialog({super.key, required Function btnCallback})
      : _btnCallback = btnCallback;

  final Function _btnCallback;
  final _titleAbout = 'About';
  final _contentAbout = '''
Shopping with girlfriend/wife is just so boring.
Hope this app will bring some fun to you.
''';

  final _titleResult = 'The reulst';
  final _contentResult = '''
This is NOT a real fashion rating app.
Result is always "You look GOOD".
Score is just a random number: 50~100%.
Analyzing time is also random: 2~10 sec.
''';

  final _titleDataPrivacy = 'Data Privacy';
  final _contentDataPrivacy = '''
No data will be upload.
No data will be download.
No internet needed.
No data will be stored in your phone.
''';
  final _titleOpenSource = "Open Source";
  final _contentOpenSource = '''
This is an open source project:
github.com/burwei/youlookgood
''';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      width: 300,
      height: 560,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AboutContent(title: _titleAbout, content: _contentAbout),
          AboutContent(title: _titleResult, content: _contentResult),
          AboutContent(title: _titleDataPrivacy, content: _contentDataPrivacy),
          AboutContent(title: _titleOpenSource, content: _contentOpenSource),
          const SizedBox(
            height: 30,
          ),
          // close button
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.pink,
                elevation: 8,
                shadowColor: Colors.grey.shade700,
                fixedSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(color: Colors.pink),
                ),
              ),
              onPressed: () {
                _btnCallback();
              },
              child: const Text(
                'close',
                style: TextStyle(
                    fontSize: 20, color: Colors.white, fontFamily: 'Ubuntu'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutContent extends StatelessWidget {
  const AboutContent({super.key, required this.title, required this.content});

  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "Ubuntu",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade900,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            content,
            style: TextStyle(
              fontFamily: "Ubuntu",
              fontSize: 10,
              color: Colors.pink.shade800,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
