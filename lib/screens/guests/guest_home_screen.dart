import 'package:flutter/material.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({Key? key}) : super(key: key);

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.grey.shade300),
            titleTextStyle: TextStyle(
                color: Colors.lightBlue.shade800, fontWeight: FontWeight.w500),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            title: const Text('Tetangga')),
      ]),
    );
  }
}
