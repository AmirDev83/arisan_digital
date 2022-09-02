import 'package:arisan_digital/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

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
            title: Text('Pengaturan')),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return AboutScreen();
                    }));
                  },
                  trailing: Icon(Icons.chevron_right),
                  title: Text('Tentang Aplikasi'),
                ),
                ListTile(
                  onTap: () {
                    _googleSignIn.signOut();
                    print('keluar');
                  },
                  trailing: Icon(Icons.chevron_right),
                  title: Text('Keluar'),
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
