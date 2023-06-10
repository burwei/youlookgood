import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAboutDialog extends StatelessWidget {
  const MyAboutDialog({super.key, required Function btnCallback})
      : _btnCallback = btnCallback;

  final Function _btnCallback;

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
          AboutContent(
              title: AppLocalizations.of(context)!.aboutSectionTitle,
              content: AppLocalizations.of(context)!.aboutSectionContent),
          AboutContent(
              title: AppLocalizations.of(context)!.resultSectionTitle,
              content: AppLocalizations.of(context)!.resultSectionContent),
          AboutContent(
              title: AppLocalizations.of(context)!.dataPrivacySectionTitle,
              content: AppLocalizations.of(context)!.dataPrivacySectionContent),
          AboutContent(
              title: AppLocalizations.of(context)!.openSourceSectionTitle,
              content: AppLocalizations.of(context)!.openSourceSectionContent),
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
              child: Text(
                AppLocalizations.of(context)!.dismiss,
                style: const TextStyle(
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
