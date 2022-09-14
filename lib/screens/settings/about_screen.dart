import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        SliverAppBar(
            floating: true,
            iconTheme: IconThemeData(color: Colors.grey.shade300),
            titleTextStyle: TextStyle(
                color: Colors.lightBlue.shade800, fontWeight: FontWeight.w500),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            title: const Text('Tentang Aplikasi')),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eget accumsan ex. Donec faucibus elementum nulla sed ullamcorper. Fusce urna nisi, tincidunt vitae lectus ut, tristique egestas elit. Nam ac diam quis leo tincidunt convallis in nec sem. Nam maximus purus velit, non efficitur purus placerat eu. Nam mauris dui, tempus eget tortor nec, imperdiet accumsan lacus.'),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi eget accumsan ex. Donec faucibus elementum nulla sed ullamcorper. Fusce urna nisi, tincidunt vitae lectus ut, tristique egestas elit. Nam ac diam quis leo tincidunt convallis in nec sem. Nam maximus purus velit, non efficitur purus placerat eu. Nam mauris dui, tempus eget tortor nec, imperdiet accumsan lacus.'),
                ),
              ],
            ),
          )
        ])),
        SliverList(delegate: SliverChildListDelegate([])),
      ]),
    );
  }
}
