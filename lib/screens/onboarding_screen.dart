import 'package:arisan_digital/screens/starting_screen.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) {
      return const StartingScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Arisan Digital",
          body:
              "Yuk, mulai arisan kamu sekarang juga.",
          image: Image.asset(
            'assets/images/onboarding/group.png',
            width: 240,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ngga ribet",
          body:
              "Atur keuangan harianmu dengan mudah dan ngga ribet bikin rencana keuangan.",
          image: Image.asset(
            'assets/images/onboarding/member.png',
            width: 235,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Makin Hemat",
          body:
              "Membuatmu semakin hemat, mengelola pengeluaran secara terstruktur.",
          image: Image.asset(
            'assets/images/onboarding/reward.png',
            width: 220,
          ),
          footer: ElevatedButton(
            onPressed: () {
              _onIntroEnd(context);
            },
            child: const Text(
              'Ayo Mulai !!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 1,
      nextFlex: 1,
      dotsFlex: 2,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Lewati',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.blue,
      ),
      done: const Text('Selesai',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: Colors.blue,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
